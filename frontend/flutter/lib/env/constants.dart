// ignore_for_file: constant_identifier_names

/// 头像 base64 前缀
const String AVATAR_BASE64_PREFIX = 'data:image/jpg;base64,';

/// 用户 - 配置信息
const String STORAGE_USER_PROFILE_KEY = 'user_profile';

/// 用户 - Access Token（兼容旧值 'user_token'）
const String STORAGE_USER_TOKEN_KEY = 'user_token';

/// 用户 - Access Token（新系统使用）
const String STORAGE_ACCESS_TOKEN_KEY = 'user_token';

/// 用户 - Refresh Token
const String STORAGE_REFRESH_TOKEN_KEY = 'user_refresh_token';

/// 系统 - 配置信息
class AppConstants {
  AppConstants._();

  static const AndroidConfig android = AndroidConfig(
    amapKey: 'YOUR_ANDROID_AMAP_KEY',
    umengKeyTest: 'YOUR_ANDROID_UMENG_KEY_TEST',
    umengKeyProd: 'YOUR_ANDROID_UMENG_KEY_PROD',
  );

  static const IosConfig ios = IosConfig(
    amapKey: 'YOUR_IOS_AMAP_KEY',
    umengKeyTest: 'YOUR_IOS_UMENG_KEY_TEST',
    umengKeyProd: 'YOUR_IOS_UMENG_KEY_PROD',
  );
}

/// Android 平台配置模型（挂在 AppConstants.android 下）
class AndroidConfig {
  final String amapKey;
  final String umengKeyTest;
  final String umengKeyProd;

  const AndroidConfig({
    required this.amapKey,
    required this.umengKeyTest,
    required this.umengKeyProd,
  });
}

/// iOS 平台配置模型（挂在 AppConstants.ios 下）
class IosConfig {
  final String amapKey;
  final String umengKeyTest;
  final String umengKeyProd;

  const IosConfig({
    required this.amapKey,
    required this.umengKeyTest,
    required this.umengKeyProd,
  });
}
