import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

/// Loading 拦截器 — 全局请求计数控制的加载动画
///
/// 通过请求参数的 `showLoading` 控制是否显示 loading。
/// 使用引用计数确保多个并发请求时 loading 不会提前消失。
class LoadingInterceptor extends Interceptor {
  int _pendingRequests = 0;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final showLoading = options.extra['showLoading'] ?? true;
    if (showLoading as bool) {
      _pendingRequests++;
      if (_pendingRequests == 1) {
        EasyLoading.show(status: '加载中...');
      }
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _decrementLoading(err.requestOptions);
    handler.next(err);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _decrementLoading(response.requestOptions);
    handler.next(response);
  }

  void _decrementLoading(RequestOptions options) {
    final showLoading = options.extra['showLoading'] ?? true;
    if (showLoading as bool) {
      _pendingRequests--;
      if (_pendingRequests <= 0) {
        _pendingRequests = 0;
        EasyLoading.dismiss();
      }
    }
  }
}
