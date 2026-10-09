import 'package:dio/dio.dart';

import '../../storage/token_storage.dart';
import '../api_client.dart';

/// 认证拦截器 — Token 注入与自动刷新
///
/// [onRequest]: 自动注入 Authorization header
/// [onError]: 捕获 401 后自动刷新 Token，重试原请求
///
/// 使用共享 Future 模式避免并发重复刷新 Token。
class AuthInterceptor extends Interceptor {
  /// 正在刷新中的 Future，用于共享刷新状态
  Future<void>? _refreshFuture;

  /// 等待刷新的请求队列
  final List<_PendingRequest> _pendingRequests = [];

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = TokenStorage.instance.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 仅处理 401 错误
    if (err.response?.statusCode != 401) {
      handler.next(err);
      return;
    }

    // 如果是刷新 Token 自身的请求出错，不重试，直接拒绝
    if (_isRefreshRequest(err.requestOptions)) {
      handler.next(err);
      return;
    }

    _handleTokenRefresh(err, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  /// 判断是否为 Token 刷新请求（避免递归）
  bool _isRefreshRequest(RequestOptions options) {
    final path = options.path;
    return path.contains('/token/refresh');
  }

  /// 处理 Token 刷新逻辑
  void _handleTokenRefresh(DioException err, ErrorInterceptorHandler handler) {
    if (_refreshFuture != null) {
      // 已有刷新请求在进行中，排队等待
      _pendingRequests.add(
        _PendingRequest(options: err.requestOptions, handler: handler),
      );
      return;
    }

    // 开始刷新 Token
    _refreshFuture = _doRefreshToken();

    _refreshFuture!
        .then((_) {
          // 刷新成功：重试当前请求
          _retryRequest(err.requestOptions, handler);

          // 重试所有排队请求
          final pending = List<_PendingRequest>.from(_pendingRequests);
          _pendingRequests.clear();
          for (final pr in pending) {
            _retryRequest(pr.options, pr.handler);
          }
        })
        .catchError((Object e) {
          // 刷新失败：拒绝所有排队请求
          handler.reject(err);
          for (final pr in _pendingRequests) {
            pr.handler.reject(err);
          }
          _pendingRequests.clear();
        })
        .whenComplete(() {
          _refreshFuture = null;
        });
  }

  /// 执行 Token 刷新请求
  Future<void> _doRefreshToken() async {
    final refreshToken = TokenStorage.instance.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      throw Exception('Refresh token 不存在');
    }

    final apiClient = ApiClient.instance;
    final response = await apiClient.dio.post(
      '/system/auth/token/refresh',
      data: {'refresh_token': refreshToken},
    );

    final data = response.data as Map<String, dynamic>?;
    if (data == null) {
      throw Exception('刷新 Token 失败：响应为空');
    }

    // 等待 token 落盘完成后再重试，确保新 token 已持久化
    await TokenStorage.instance.saveTokens(
      accessToken: data['access_token'] as String,
      refreshToken: data['refresh_token'] as String,
    );
  }

  /// 使用刷新后的 Token 重试请求
  Future<void> _retryRequest(
    RequestOptions options,
    ErrorInterceptorHandler handler,
  ) async {
    // 注入新 Token
    final newToken = TokenStorage.instance.getAccessToken();
    if (newToken != null) {
      options.headers['Authorization'] = 'Bearer $newToken';
    }

    try {
      final response = await ApiClient.instance.dio.fetch(options);
      handler.resolve(response);
    } catch (e) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: e,
          type: DioExceptionType.unknown,
        ),
      );
    }
  }
}

/// 等待刷新的请求记录
class _PendingRequest {
  final RequestOptions options;
  final ErrorInterceptorHandler handler;

  _PendingRequest({required this.options, required this.handler});
}
