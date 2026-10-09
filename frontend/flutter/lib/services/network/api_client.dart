import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'cookie_safe_adapter.dart'
    if (dart.library.html) 'web_http_adapter_stub.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/loading_interceptor.dart';
import 'interceptors/network_status_interceptor.dart';
import 'interceptors/response_interceptor.dart';
import 'interceptors/retry_interceptor.dart';
import 'network_status.dart';

/// API 客户端 — 核心网络请求封装
///
/// 特性：
/// - 单例模式，全局共享一个 Dio 实例
/// - 6 层拦截器链：Auth → NetworkStatus → Loading → Retry → Response → Error
/// - 泛型方法：get\<T\>()、post\<T\>()、put\<T\>()、delete\<T\>()
/// - 动态超时配置：根据网络质量自动调整
/// - 全局 CancelToken + 按路径 CancelToken 管理
/// - 请求级控制：showLoading、showError
class ApiClient {
  static final ApiClient instance = ApiClient._();

  ApiClient._();

  late Dio _dio;

  /// 公开 Dio 实例，供拦截器等外部访问
  Dio get dio => _dio;

  /// 全局 CancelToken — 一键取消所有请求
  CancelToken _globalCancelToken = CancelToken();

  /// 按路径存储的 CancelToken
  final Map<String, CancelToken> _requestTokens = {};

  bool _initialized = false;

  /// 初始化 ApiClient
  ///
  /// [baseUrl]: API 基础地址
  /// [connectTimeout]: 可选，覆盖默认连接超时
  /// [receiveTimeout]: 可选，覆盖默认接收超时
  void init({
    required String baseUrl,
    Duration? connectTimeout,
    Duration? receiveTimeout,
  }) {
    if (_initialized) return;
    _initialized = true;

    final networkStatus = NetworkStatusService.instance;

    // 基础配置
    final options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: connectTimeout ?? networkStatus.connectTimeout,
      receiveTimeout: receiveTimeout ?? networkStatus.receiveTimeout,
      contentType: 'application/json',
      responseType: ResponseType.json,
      headers: {'accept': 'application/json'},
    );

    _dio = Dio(options);

    // 🔴 性能优化：显式使用 dio 默认 BackgroundTransformer——
    //   响应 JSON >50KB 时在后台 isolate 解析，避免大响应体在主线程 jsonDecode 掉帧
    _dio.transformer = BackgroundTransformer();

    // Web 使用默认浏览器适配器，非 Web 使用 CookieSafeAdapter
    if (!kIsWeb) {
      _dio.httpClientAdapter = CookieSafeAdapter();
    }

    // 绑定 Dio 到 NetworkStatusService（动态超时更新）
    networkStatus.bindDio(_dio);

    // 设置拦截器链
    _setupInterceptors();

    // 开发环境日志
    if (!kReleaseMode) {
      _dio.interceptors.add(_createLogInterceptor());
    }
  }

  /// 配置拦截器链
  ///
  /// 执行顺序：Auth → NetworkStatus → Loading → Retry → Response → Error
  void _setupInterceptors() {
    _dio.interceptors.add(AuthInterceptor());
    _dio.interceptors.add(NetworkStatusInterceptor());
    _dio.interceptors.add(LoadingInterceptor());
    _dio.interceptors.add(RetryInterceptor(dioGetter: () => _dio));
    _dio.interceptors.add(ResponseInterceptor());
    _dio.interceptors.add(ErrorInterceptor());
  }

  /// 创建开发环境日志拦截器
  Interceptor _createLogInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        debugPrint('╔═══ REQUEST ══');
        debugPrint('║ ${options.method} ${options.uri}');
        if (options.queryParameters.isNotEmpty) {
          debugPrint('║ Params: ${options.queryParameters}');
        }
        if (options.data != null && options.data.toString() != '{}') {
          debugPrint('║ Body: ${options.data}');
        }
        debugPrint('╚══════════════');
        handler.next(options);
      },
    );
  }

  // ─── 请求方法 ───────────────────────────────────────────

  /// GET 请求
  Future<T> get<T>(
    String url, {
    Map<String, dynamic>? params,
    bool showLoading = true,
    bool showError = true,
    CancelToken? cancelToken,
  }) async {
    final response = await _dio.get(
      url,
      queryParameters: params,
      options: _buildOptions(showLoading: showLoading, showError: showError),
      cancelToken: cancelToken ?? _createCancelToken(url),
    );
    return response.data as T;
  }

  /// POST 请求
  Future<T> post<T>(
    String url, {
    Map<String, dynamic>? params,
    dynamic data,
    bool showLoading = true,
    bool showError = true,
    CancelToken? cancelToken,
    Options? options,
  }) async {
    final mergedOptions = _buildOptions(
      showLoading: showLoading,
      showError: showError,
    );
    if (options != null) {
      mergedOptions.extra?.addAll(options.extra ?? {});
      if (options.contentType != null) {
        mergedOptions.contentType = options.contentType;
      }
    }
    final response = await _dio.post(
      url,
      queryParameters: params,
      data: data,
      options: mergedOptions,
      cancelToken: cancelToken ?? _createCancelToken(url),
    );
    return response.data as T;
  }

  /// PUT 请求
  Future<T> put<T>(
    String url, {
    Map<String, dynamic>? params,
    dynamic data,
    bool showLoading = true,
    bool showError = true,
    CancelToken? cancelToken,
  }) async {
    final response = await _dio.put(
      url,
      queryParameters: params,
      data: data,
      options: _buildOptions(showLoading: showLoading, showError: showError),
      cancelToken: cancelToken ?? _createCancelToken(url),
    );
    return response.data as T;
  }

  /// DELETE 请求
  Future<T> delete<T>(
    String url, {
    Map<String, dynamic>? params,
    dynamic data,
    bool showLoading = true,
    bool showError = true,
    CancelToken? cancelToken,
  }) async {
    final response = await _dio.delete(
      url,
      queryParameters: params,
      data: data,
      options: _buildOptions(showLoading: showLoading, showError: showError),
      cancelToken: cancelToken ?? _createCancelToken(url),
    );
    return response.data as T;
  }

  /// 文件上传
  Future<T> upload<T>(
    String url, {
    required FormData formData,
    bool showLoading = true,
    bool showError = true,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
  }) async {
    final response = await _dio.post(
      url,
      data: formData,
      options: _buildOptions(showLoading: showLoading, showError: showError),
      cancelToken: cancelToken ?? _createCancelToken(url),
      onSendProgress: onSendProgress,
    );
    return response.data as T;
  }

  // ─── 请求控制 ───────────────────────────────────────────

  /// 构建请求配置
  Options _buildOptions({bool showLoading = true, bool showError = true}) {
    return Options(extra: {'showLoading': showLoading, 'showError': showError});
  }

  /// 创建按路径的 CancelToken
  CancelToken _createCancelToken(String path) {
    final token = CancelToken();

    // 监听全局 CancelToken
    _globalCancelToken.whenCancel.then((_) {
      if (!token.isCancelled) {
        token.cancel('所有请求已取消');
      }
    });

    // 取消已存在的相同路径请求
    if (_requestTokens.containsKey(path)) {
      final existing = _requestTokens[path]!;
      if (!existing.isCancelled) {
        existing.cancel('新请求已发起');
      }
    }

    _requestTokens[path] = token;
    return token;
  }

  /// 取消所有进行中的请求
  void cancelAllRequests() {
    if (!_globalCancelToken.isCancelled) {
      _globalCancelToken.cancel('所有请求已取消');
    }
    _globalCancelToken = CancelToken();
    _requestTokens.forEach((_, token) {
      if (!token.isCancelled) {
        token.cancel('请求已取消');
      }
    });
    _requestTokens.clear();
  }

  /// 取消指定路径的请求
  void cancelRequest(String path) {
    final token = _requestTokens[path];
    if (token != null && !token.isCancelled) {
      token.cancel('请求已取消');
      _requestTokens.remove(path);
    }
  }
}
