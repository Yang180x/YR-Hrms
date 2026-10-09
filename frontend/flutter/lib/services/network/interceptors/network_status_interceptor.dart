import 'package:dio/dio.dart';
import '../network_status.dart';
import '../request_queue.dart';

/// 网络状态拦截器 — 断网检测与请求入队
///
/// 断网时将请求入队而非直接失败，网络恢复后自动冲刷队列。
class NetworkStatusInterceptor extends Interceptor {
  final RequestQueue _queue = RequestQueue();
  bool _isFlushing = false;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final status = NetworkStatusService.instance;
    if (status.currentQuality == NetworkQuality.none) {
      // 断网：入队等待
      _queue.enqueue(QueuedRequest(options: options, handler: handler));
      handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
          message: '当前无网络连接，请求已排队等待恢复',
        ),
      );
      return;
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(err);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  /// 网络恢复时冲刷请求队列
  Future<void> flushQueue() async {
    if (_isFlushing) return;
    _isFlushing = true;
    await _queue.flush();
    _isFlushing = false;
  }
}
