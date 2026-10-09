import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

/// 网络质量枚举
enum NetworkQuality {
  /// WiFi/以太网 — 超时 10s
  excellent,

  /// 4G — 超时 15s
  good,

  /// 3G/2G（弱网）— 超时 30s
  poor,

  /// 无网络
  none,
}

/// 网络状态检测服务
///
/// 监听网络连接变化，自动计算网络质量。
/// 支持动态超时配置，根据网络质量自动调整 Dio 超时时间。
class NetworkStatusService {
  static final NetworkStatusService instance = NetworkStatusService._();

  NetworkStatusService._();

  NetworkQuality _currentQuality = NetworkQuality.excellent;

  /// 当前网络质量
  NetworkQuality get currentQuality => _currentQuality;

  /// Dio 实例（由 ApiClient 注入，用于动态调整超时）
  Dio? _dio;

  StreamSubscription<List<ConnectivityResult>>? _subscription;

  bool _initialized = false;

  /// 初始化网络监听
  ///
  /// 调用后网络状态已就绪（[_currentQuality] 已更新）。
  Future<void> init({Dio? dio}) async {
    if (_initialized) return;
    _initialized = true;
    _dio = dio;

    // 立即检查当前网络状态
    await _checkConnectivity();

    // 持续监听网络变化
    _subscription = Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      _updateQuality(results);
    });
  }

  /// 手动绑定 Dio 实例（可在 ApiClient 初始化后调用）
  void bindDio(Dio dio) {
    _dio = dio;
  }

  /// 获取当前连接超时时间
  Duration get connectTimeout {
    switch (_currentQuality) {
      case NetworkQuality.excellent:
        return const Duration(seconds: 10);
      case NetworkQuality.good:
        return const Duration(seconds: 15);
      case NetworkQuality.poor:
        return const Duration(seconds: 30);
      case NetworkQuality.none:
        return const Duration(seconds: 10);
    }
  }

  /// 获取当前接收超时时间
  Duration get receiveTimeout => connectTimeout;

  /// 检查当前网络状态
  Future<void> _checkConnectivity() async {
    final results = await Connectivity().checkConnectivity();
    _updateQuality(results);
  }

  /// 根据 ConnectivityResult 更新网络质量
  void _updateQuality(List<ConnectivityResult> results) {
    if (results.isEmpty || results.contains(ConnectivityResult.none)) {
      _setQuality(NetworkQuality.none);
      return;
    }

    if (results.contains(ConnectivityResult.wifi) ||
        results.contains(ConnectivityResult.ethernet)) {
      _setQuality(NetworkQuality.excellent);
      return;
    }

    if (results.contains(ConnectivityResult.mobile)) {
      // 移动网络统一视为 good（4G），无法精确区分 3G/4G/5G
      _setQuality(NetworkQuality.good);
      return;
    }

    _setQuality(NetworkQuality.good);
  }

  /// 设置网络质量并更新 Dio 超时
  void _setQuality(NetworkQuality quality) {
    if (_currentQuality == quality) return;
    _currentQuality = quality;
    _updateDioTimeout();
  }

  /// 更新 Dio 超时配置
  void _updateDioTimeout() {
    _dio?.options.connectTimeout = connectTimeout;
    _dio?.options.receiveTimeout = receiveTimeout;
  }

  /// 释放资源
  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    _initialized = false;
  }

  /// 网络是否可用
  bool get isConnected => _currentQuality != NetworkQuality.none;
}
