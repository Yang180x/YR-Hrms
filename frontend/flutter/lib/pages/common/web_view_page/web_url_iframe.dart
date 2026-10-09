import 'dart:ui_web' as ui_web;

import 'package:flutter/widgets.dart';
import 'package:web/web.dart' as web;

/// Web 端通用 iframe — 直接内嵌目标网页或本地 asset
///
/// 等价 webview_flutter_web 的 iframe 能力（HtmlElementView + HTMLIFrameElement），
/// 但由本项目自封装，无实验性外部依赖；仅 Web 平台使用（kIsWeb + 条件导入），
/// 原生平台请用 webview_flutter 的 WebViewWidget。
///
/// 两个加载源二选一：
/// - [url]：内嵌外部网页（依赖目标网站允许 iframe，X-Frame-Options/CSP 禁止时空白）
/// - [assetPath]：内嵌本地 asset（如天禹滑块 `assets/tianyu.html`，Flutter Web 相对路径加载）
class WebUrlIframe extends StatefulWidget {
  /// 要内嵌加载的外部 URL（与 [assetPath] 二选一）
  final String? url;

  /// 要内嵌加载的本地 asset 路径（如 `assets/tianyu.html`；与 [url] 二选一）
  final String? assetPath;

  const WebUrlIframe({super.key, this.url, this.assetPath})
    : assert(
        url != null || assetPath != null,
        'WebUrlIframe 需提供 url 或 assetPath',
      ),
      assert(
        !(url != null && assetPath != null),
        'WebUrlIframe 的 url 与 assetPath 二选一',
      );

  @override
  State<WebUrlIframe> createState() => _WebUrlIframeState();
}

class _WebUrlIframeState extends State<WebUrlIframe> {
  late final String _viewType;
  static int _counter = 0;

  @override
  void initState() {
    super.initState();
    // 每次注册独立 viewType（源各异），工厂返回 100% 尺寸的 iframe
    _viewType = 'web-url-iframe-${_counter++}';
    ui_web.platformViewRegistry.registerViewFactory(
      _viewType,
      (int viewId) => web.HTMLIFrameElement()
        ..src = widget.url ?? widget.assetPath!
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.border = 'none',
    );
  }

  @override
  Widget build(BuildContext context) => HtmlElementView(viewType: _viewType);
}
