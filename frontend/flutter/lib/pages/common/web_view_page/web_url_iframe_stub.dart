import 'package:flutter/widgets.dart';

/// 非 Web 平台 stub：URL iframe 仅 Web 平台使用（kIsWeb 分支），
/// 原生平台走 webview_flutter 的 WebViewWidget。
/// 条件导入（`if (dart.library.js_interop)`）时被 Web 版替代。
class WebUrlIframe extends StatelessWidget {
  /// 要内嵌加载的外部 URL（与 [assetPath] 二选一）
  final String? url;

  /// 要内嵌加载的本地 asset 路径（与 [url] 二选一）
  final String? assetPath;

  const WebUrlIframe({super.key, this.url, this.assetPath})
    : assert(url != null || assetPath != null),
      assert(!(url != null && assetPath != null));

  @override
  Widget build(BuildContext context) =>
      throw UnsupportedError('WebUrlIframe 仅 Web 平台支持');
}
