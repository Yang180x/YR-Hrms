import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'env/index.dart';
import 'provider/auth/auth_provider.dart';
import 'services/index.dart';

/// 全局初始化
class Global {
  /// 全局 Riverpod 容器：启动时创建并预热 auth provider，
  /// 将 token/用户信息一次性读入内存，避免运行期重复 IO 读取
  static late final ProviderContainer container;

  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    // 并行初始化（环境变量 + 本地存储 + 初始化网络状态监听）
    await Future.wait([AppEnv.init(), KVStorage.init(), NetworkStatusService.instance.init()]);

    // 初始化 API 客户端
    ApiClient.instance.init(baseUrl: AppEnv.apiUrl);

    // 创建全局容器并预热 auth provider：
    // - AuthNotifier.build 触发 TokenStorage.loadFromDisk，将 token 一次性读入内存
    //   （之后所有 token 读取走内存，零 IO）
    // - 基于内存 token 确定 AuthStatus，并恢复缓存用户信息
    container = ProviderContainer();
    container.read(authProvider);

    // 设置系统 UI 样式（Web 不支持 SystemChrome）
    if (!kIsWeb) {
      _initSystemUI();
    }
  }

  static void _initSystemUI() {
    // Android/iOS 共用状态栏样式
    const systemUi = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    );
    SystemChrome.setSystemUIOverlayStyle(systemUi);
  }
}
