import 'package:dio/dio.dart';
import '../api_result.dart';
import '../network/api_client.dart';

// 代替子类导入
export '../api_result.dart';

/// API 基类 — 封装通用请求方法，减少子类样板代码
///
/// 所有 API 类继承此类即可使用 [get]/[post]/[put] 等便捷方法，
/// 无需重复调用 `ApiClient.instance`。
///
/// 子类示例：
/// ```dart
/// class NoticeApi extends BaseApi {
///   static Future<PageResult<Map<String, dynamic>>> list(...) async {
///     final data = await get<Map<String, dynamic>>('/system/notice/list');
///     return PageResult.fromJson(data);
///   }
/// }
/// ```
///
/// 注意: 由于 Dart 静态方法必须用定义类型限定，子类中需使用
/// `BaseApi.get(...)` 而非 `get(...)`。
class BaseApi {
  /// GET 请求
  static Future<T> get<T>(
    String url, {
    Map<String, dynamic>? params,
    bool showLoading = true,
    bool showError = true,
  }) {
    return ApiClient.instance.get<T>(
      url,
      params: params,
      showLoading: showLoading,
      showError: showError,
    );
  }

  /// POST 请求
  static Future<T> post<T>(
    String url, {
    Map<String, dynamic>? params,
    dynamic data,
    bool showLoading = true,
    bool showError = true,
    Options? options,
  }) {
    final mergedOptions = Options(
      extra: {'showLoading': showLoading, 'showError': showError},
    );
    if (options != null) {
      mergedOptions.extra?.addAll(options.extra ?? {});
      if (options.contentType != null) {
        mergedOptions.contentType = options.contentType;
      }
    }
    return ApiClient.instance.post<T>(
      url,
      params: params,
      data: data,
      options: mergedOptions,
    );
  }

  /// PUT 请求
  static Future<T> put<T>(
    String url, {
    dynamic data,
    bool showLoading = true,
    bool showError = true,
  }) {
    return ApiClient.instance.put<T>(
      url,
      data: data,
      showLoading: showLoading,
      showError: showError,
    );
  }

  /// 通用的分页列表查询
  ///
  /// 子类只需传入路径，即可获得分页结果。
  static Future<PageResult<Map<String, dynamic>>> listPage(
    String url, {
    PageParams params = const PageParams(),
  }) async {
    final data = await get<Map<String, dynamic>>(url, params: params.toJson());
    return PageResult.fromJson(data);
  }
}
