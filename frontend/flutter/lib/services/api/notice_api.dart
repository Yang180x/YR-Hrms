import 'base_api.dart';

/// 通知公告 API
///
/// 提供通知公告分页列表查询接口。
class NoticeApi extends BaseApi {
  /// 通知公告分页列表
  static Future<PageResult<Map<String, dynamic>>> list({
    PageParams params = const PageParams(),
  }) async {
    return BaseApi.listPage('/system/notice/list', params: params);
  }
}
