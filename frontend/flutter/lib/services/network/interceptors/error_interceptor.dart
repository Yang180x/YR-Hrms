import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

/// 错误拦截器 — 统一处理网络错误（业务错误已在 ResponseInterceptor 处理）
///
/// 根据 [DioExceptionType] 显示对应的中文错误提示。
/// 可通过请求参数的 `showError` 控制是否弹出提示。
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // badResponse 已在 ResponseInterceptor 中处理并提示，此处跳过
    if (err.type == DioExceptionType.badResponse) {
      handler.next(err);
      return;
    }

    // 检查调用方是否要求显示错误提示
    final showError = err.requestOptions.extra['showError'] ?? true;
    if (showError as bool) {
      switch (err.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          EasyLoading.showError('连接超时，请稍后重试');
          break;
        case DioExceptionType.connectionError:
          EasyLoading.showError('网络连接失败，请检查网络');
          break;
        case DioExceptionType.unknown:
          EasyLoading.showError('网络异常，请稍后重试');
          break;
        case DioExceptionType.cancel:
          // 请求已取消，静默处理
          break;
        default:
          EasyLoading.showError(err.message ?? '请求失败');
          break;
      }
    }

    handler.next(err);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }
}
