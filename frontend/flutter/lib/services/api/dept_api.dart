import 'base_api.dart';

/// 部门 API
///
/// 提供部门分页列表查询接口。
class DeptApi extends BaseApi {
  /// 部门分页列表
  static Future<PageResult<Map<String, dynamic>>> list({
    PageParams params = const PageParams(),
  }) async {
    return BaseApi.listPage('/system/dept/list', params: params);
  }
}
