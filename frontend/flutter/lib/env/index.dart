import 'package:flutter_dotenv/flutter_dotenv.dart';

/// 环境配置入口 — 统一管理 dotenv 加载与配置读取
class AppEnv {
  AppEnv._();

  /// 初始化：通过 --dart-define=ENV=xxx 选择环境文件
  static Future<void> init() async {
    const String env = String.fromEnvironment('ENV', defaultValue: 'dev');
    const String fileName = 'lib/env/.env.$env';
    try {
      await dotenv.load(fileName: fileName);
    } catch (_) {
      await dotenv.load(fileName: 'lib/env/.env.dev');
    }
  }

  /// 当前环境（dev / test / prod）
  static String get env => dotenv.get('ENV', fallback: 'dev');

  /// API 基础地址
  static String get apiUrl =>
      dotenv.get('API_BASE_URL', fallback: 'http://127.0.0.1:6100');

  /// App 名称
  static String get appName => dotenv.get('APP_NAME', fallback: 'FastapiAdmin');

  /// App 版本号（Flutter 端使用 dotenv；Android 端由 gradle 读同一份 .env 写入 versionName，天然一致）
  static String get appVersion => dotenv.get('APP_VERSION', fallback: '1.0.0');

  // ---- 辅助判断 ----
  static bool get isDev => env == 'dev';
  static bool get isTest => env == 'test';
  static bool get isProd => env == 'prod';
}
