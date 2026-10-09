import 'base_api.dart';

/// 用户管理 API（后台管理员功能）
///
/// 提供后台用户管理相关的分页列表查询接口。
class UserAdminApi extends BaseApi {
  /// 用户分页列表
  static Future<PageResult<Map<String, dynamic>>> list({
    PageParams params = const PageParams(),
  }) async {
    return BaseApi.listPage('/system/user/list', params: params);
  }
}
