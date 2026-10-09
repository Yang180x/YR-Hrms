import 'package:dio/dio.dart';
import 'package:gm_crypto/gm_crypto.dart';
import 'base_api.dart';

/// 认证相关 API
///
/// 提供登录、登出、SM2 公钥获取等认证接口。
class AuthApi extends BaseApi {
  /// SM2 公钥缓存
  static String? _smPublicKey;

  /// 获取 SM2 公钥（带缓存）
  static Future<String?> getSmPublicKey() async {
    if (_smPublicKey != null) return _smPublicKey;
    try {
      final data = await BaseApi.get<dynamic>(
        '/system/auth/sm-public-key',
        showLoading: false,
        showError: false,
      );
      if (data is Map<String, dynamic> && data['public_key'] is String) {
        _smPublicKey = data['public_key'] as String;
        return _smPublicKey;
      }
    } catch (_) {}
    return null;
  }

  static Future<String> _encryptPassword(String password) async {
    final publicKey = await getSmPublicKey();
    if (publicKey == null || publicKey.isEmpty) {
      throw Exception('无法获取 SM2 公钥，加密登录不可用');
    }
    return SM2.encrypt(password, publicKey);
  }

  /// 登录（SM2 密码加密）
  ///
  /// 返回 `{ access_token, refresh_token }`。
  static Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    final encryptedPassword = await _encryptPassword(password);
    final data = await BaseApi.post<Map<String, dynamic>>(
      '/system/auth/login',
      data: {
        'username': username,
        'password': encryptedPassword,
        'captcha_key': '',
        'captcha': '',
        'login_type': 'FLUTTER',
      },
      options: Options(contentType: 'application/x-www-form-urlencoded'),
      showLoading: false,
    );
    return data;
  }

  /// 退出登录
  static Future<void> logout() async {
    await BaseApi.post('/system/auth/logout', showError: false);
  }
}
