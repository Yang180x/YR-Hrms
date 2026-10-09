import 'base_api.dart';

/// 岗位 API
///
/// 提供岗位分页列表查询接口。
class PositionApi extends BaseApi {
  /// 岗位分页列表
  static Future<PageResult<Map<String, dynamic>>> list({
    PageParams params = const PageParams(),
  }) async {
    return BaseApi.listPage('/system/position/list', params: params);
  }
}
