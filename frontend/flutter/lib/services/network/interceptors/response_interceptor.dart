import 'package:dio/dio.dart';
import '../../api_result.dart';

/// 响应拦截器 — 统一解析后端 { code, msg, data } 结构
///
/// 将后端统一响应体解析为业务数据，code != 0 时拒绝请求。
class ResponseInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // HTTP 状态码校验
    if (response.statusCode != 200) {
      handler.reject(
        DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        ),
        true,
      );
      return;
    }

    final data = response.data;
    if (data is! Map) {
      handler.next(response);
      return;
    }

    final body = data as Map<String, dynamic>;
    final result = ApiResult.fromJson(body);

    // 业务状态码校验：code == 0 表示成功
    if (!result.isSuccess) {
      handler.reject(
        DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          message: result.msg,
        ),
        true,
      );
      return;
    }

    // 直接透传 data，调用方根据业务自行处理类型
    response.data = result.data;
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(err);
  }
}
