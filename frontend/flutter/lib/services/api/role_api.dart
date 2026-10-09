import 'base_api.dart';

/// 角色 API
///
/// 提供角色分页列表查询接口。
class RoleApi extends BaseApi {
  /// 角色分页列表
  static Future<PageResult<Map<String, dynamic>>> list({
    PageParams params = const PageParams(),
  }) async {
    return BaseApi.listPage('/system/role/list', params: params);
  }
}
