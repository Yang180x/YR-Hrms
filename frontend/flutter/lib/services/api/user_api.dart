import '../models/user_profile.dart';
import 'base_api.dart';

/// 用户信息相关 API
///
/// 提供当前用户资料的获取、更新、密码修改等接口。
class UserApi extends BaseApi {
  /// 获取当前用户信息
  static Future<UserProfile> profile() async {
    final data = await BaseApi.get<Map<String, dynamic>>(
      '/system/user/current/info',
    );
    return UserProfile.fromJson(data);
  }

  /// 更新当前用户基本信息
  static Future<void> updateProfile(Map<String, dynamic> body) async {
    await BaseApi.put('/system/user/current/info/update', data: body);
  }

  /// 修改密码
  static Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    await BaseApi.put(
      '/system/user/current/password/change',
      data: {'old_password': oldPassword, 'new_password': newPassword},
    );
  }
}
