import 'dart:math';

import 'package:dio/dio.dart';

import '../circuit_breaker.dart';
import '../network_status.dart';

/// 重试拦截器 — 指数退避 + 随机抖动重试
///
/// 重试策略：
/// - GET/HEAD 无条件重试
/// - POST/PUT/DELETE 仅对 connectionError/timeout 类错误重试
/// - 4xx/cancel 不重试
/// - 熔断器打开时直接拒绝不重试
///
/// 弱网环境下减少重试次数、增大基础延迟。
class RetryInterceptor extends Interceptor {
  final Random _random = Random();
  final CircuitBreaker _circuitBreaker = CircuitBreaker.instance;

  /// Dio 实例获取器（由 ApiClient 注入，避免循环依赖）
  final Dio Function() dioGetter;

  RetryInterceptor({required this.dioGetter});

  /// 不可重试的 HTTP 方法
  static const Set<String> _nonRetryableMethods = {
    'POST',
    'PUT',
    'DELETE',
    'PATCH',
  };

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final options = err.requestOptions;

    // 校验是否允许重试
    if (!_shouldRetry(err)) {
      handler.next(err);
      return;
    }

    // 记录失败到熔断器
    _circuitBreaker.recordFailure();

    // 获取重试次数
    final retryCount = _getRetryCount(options);
    final maxRetries = _getMaxRetries();
    if (retryCount >= maxRetries) {
      handler.next(err);
      return;
    }

    // 计算延迟
    final delay = _calculateDelay(retryCount);

    Future.delayed(delay, () {
      // 重试前检查熔断器
      if (!_circuitBreaker.allowRequest) {
        handler.next(err);
        return;
      }

      // 更新重试计数
      options.extra['retryCount'] = retryCount + 1;
      options.extra['retryFromInterceptor'] = true;

      // 重新发起请求
      dioGetter()
          .fetch(options)
          .then((response) => handler.resolve(response))
          .catchError((_) => handler.reject(err));
    });
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // 请求成功，通知熔断器
    _circuitBreaker.recordSuccess();
    handler.next(response);
  }

  /// 判断是否应该重试
  bool _shouldRetry(DioException err) {
    // 取消的请求不重试
    if (err.type == DioExceptionType.cancel) return false;

    // 熔断器中不重试
    if (!_circuitBreaker.allowRequest) return false;

    // 已有重试标记的不重复判断
    if (err.requestOptions.extra['retryFromInterceptor'] == true) return false;

    // GET/HEAD 无条件重试
    final method = err.requestOptions.method.toUpperCase();
    if (method == 'GET' || method == 'HEAD') return true;

    // POST/PUT/DELETE/PATCH 仅对网络类错误重试
    if (_nonRetryableMethods.contains(method)) {
      return err.type == DioExceptionType.connectionTimeout ||
          err.type == DioExceptionType.sendTimeout ||
          err.type == DioExceptionType.receiveTimeout ||
          err.type == DioExceptionType.connectionError;
    }

    return false;
  }

  /// 获取当前重试次数
  int _getRetryCount(RequestOptions options) {
    return options.extra['retryCount'] as int? ?? 0;
  }

  /// 获取最大重试次数
  int _getMaxRetries() {
    final quality = NetworkStatusService.instance.currentQuality;
    return quality == NetworkQuality.poor ? 2 : 3;
  }

  /// 计算指数退避 + 随机抖动延迟
  Duration _calculateDelay(int retryCount) {
    final quality = NetworkStatusService.instance.currentQuality;
    final baseDelay = quality == NetworkQuality.poor ? 2000 : 500;
    const jitterRatio = 0.3;

    // 指数退避: baseDelay * 2^(retryCount)
    final exponentialDelay = baseDelay * (1 << retryCount);

    // 随机抖动: 0 ~ exponentialDelay * jitterRatio
    final maxJitter = (exponentialDelay * jitterRatio).toInt();
    final jitter = maxJitter > 0 ? _random.nextInt(maxJitter + 1) : 0;

    return Duration(milliseconds: exponentialDelay + jitter);
  }
}
