import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';

/// Web 编译期占位实现，替代 [CookieSafeAdapter] 避免 `dart:io` 编译依赖。
///
/// 在 `factory_http.dart` 中通过条件导入切换：
/// - native → `cookie_safe_adapter.dart`
/// - web → `web_http_adapter_stub.dart`
///
/// 运行时不会被调用（[CookieSafeAdapter] 创建处有 `kIsWeb` 保护），
/// 此处仅为实现接口以保证编译通过。
class CookieSafeAdapter implements HttpClientAdapter {
  // ignore: public_member_api_docs
  CookieSafeAdapter({Object? createHttpClient});

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) {
    throw UnsupportedError('CookieSafeAdapter is not available on web');
  }

  @override
  void close({bool force = false}) {}
}
