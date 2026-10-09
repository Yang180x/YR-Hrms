import 'base_api.dart';

/// 系统相关 API
///
/// 提供菜单树等系统级接口。
class SystemApi extends BaseApi {
  /// 获取菜单树
  static Future<dynamic> menu() async {
    return await BaseApi.get('/system/menu/tree');
  }
}
