import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';

/// 包装 [IOHttpClientAdapter]，抑制 Dart SDK 底层因服务端 Cookie 日期格式
/// 不规范抛出的 `HttpException: Invalid cookie date` 异常。
///
/// 该异常发生在 Dart `_HttpClientResponse.cookies` 中，是一条分离的异步链，
/// 不影响请求/响应流程，但会输出未处理异常日志造成干扰。
class CookieSafeAdapter implements HttpClientAdapter {
  final IOHttpClientAdapter _inner;

  CookieSafeAdapter({CreateHttpClient? createHttpClient})
    : _inner = IOHttpClientAdapter(createHttpClient: createHttpClient);

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) {
    final completer = Completer<ResponseBody>();

    runZonedGuarded(
      () async {
        try {
          final result = await _inner.fetch(
            options,
            requestStream,
            cancelFuture,
          );
          if (!completer.isCompleted) completer.complete(result);
        } catch (e) {
          if (!completer.isCompleted) completer.completeError(e);
        }
      },
      (Object error, StackTrace stack) {
        // Dart SDK 底层解析 Set-Cookie 时日期格式不兼容，抛出未处理异常
        if (error is HttpException &&
            error.message.contains('Invalid cookie date')) {
          // 静默忽略，不影响业务
          return;
        }
        if (!completer.isCompleted) {
          completer.completeError(error, stack);
        }
      },
    );

    return completer.future;
  }

  @override
  void close({bool force = false}) => _inner.close(force: force);
}
