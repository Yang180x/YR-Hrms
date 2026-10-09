import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart' hide PlatformUtil;
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../common/index.dart';
import 'web_url_iframe_stub.dart'
    if (dart.library.js_interop) 'web_url_iframe.dart';

/// 下载文件扩展名列表
const _downloadExtensions = <String>[
  '.apk',
  '.zip',
  '.rar',
  '.7z',
  '.tar',
  '.gz',
  '.doc',
  '.docx',
  '.xls',
  '.xlsx',
  '.ppt',
  '.pptx',
  '.pdf',
  '.mp3',
  '.mp4',
  '.avi',
  '.mov',
  '.wmv',
  '.exe',
  '.msi',
];

/// 外部协议列表（非 http/https，需通过外部应用打开）
const _externalProtocols = <String>[
  'tel',
  'mailto',
  'sms',
  'smsto',
  'mms',
  'mmsto',
  'facetime',
  'whatsapp',
  'market',
  'intent',
  'weixin',
  'alipays',
];

/// 通用 WebView 页面
/// 对应 Android WebActivity
///
/// 除通用网页（协议/帮助/版本更新等）外，也承载 CA 协议等特殊场景：
/// - [onCustomScheme]：拦截自定义 scheme（如 `qiyun://signcert/callback`）→ 返回处理结果并 pop
/// - [ignoreSslError]：忽略 SSL 证书错误（国产 DV 证书在部分设备不被信任 → CA 协议空白时置 true）
/// - [headerBackgroundColor]/[headerTitleColor]：定制头部色（CA 协议白底黑字）
class WebViewScreenPage extends StatefulWidget {
  final String url;
  final String title;

  /// 自定义 scheme 拦截回调：URL 命中时返回要 pop 的结果（非 null → prevent + pop(result)）；
  /// 返回 null 表示不处理，走默认导航逻辑。
  final String? Function(String url)? onCustomScheme;

  /// 是否忽略 SSL 证书错误（默认 false）。CA 协议等第三方域名证书不被信任时置 true。
  final bool ignoreSslError;

  /// 头部背景色（默认品牌蓝 primary）
  final Color headerBackgroundColor;

  /// 头部标题色（默认白，配合蓝底）
  final Color headerTitleColor;

  const WebViewScreenPage({
    super.key,
    required this.url,
    this.title = '',
    this.onCustomScheme,
    this.ignoreSslError = false,
    this.headerBackgroundColor = DesignColors.primary,
    this.headerTitleColor = Colors.white,
  });

  @override
  State<WebViewScreenPage> createState() => _WebViewScreenPageState();
}

class _WebViewScreenPageState extends State<WebViewScreenPage> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _canGoBack = false;

  @override
  void initState() {
    super.initState();
    // Web 端：用自封装 WebUrlIframe（HtmlElementView iframe）渲染目标网页，
    // 不创建 WebViewController（webview_flutter 无 Web 平台实现）。
    if (kIsWeb) return;
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            setState(() => _isLoading = true);
          },
          onPageFinished: (_) {
            setState(() => _isLoading = false);
            _refreshCanGoBack();
          },
          // CA 协议空白修复：国产 cnTrus(DV) 证书在 AOSP/部分设备不被信任 →
          // WebView SSL 握手失败(net_error -201) → 空白。忽略 SSL 错误继续加载
          // （仅当调用方显式 ignoreSslError: true，如 CA 协议「放心签」固定域名）。
          onSslAuthError: widget.ignoreSslError
              ? (error) => error.proceed()
              : null,
          onNavigationRequest: _onNavigationRequest,
        ),
      );

    // Android 平台默认已启用：DOM Storage、useWideViewPort、overviewMode
    // （详见 AndroidWebViewController 构造函数）
    // 此处显式启用缩放和缓存配置
    _initPlatformSettings();
  }

  /// 配置平台相关设置：缓存策略与自适应
  Future<void> _initPlatformSettings() async {
    // 启用双指缩放（对应 Android setBuiltInZoomControls + setDisplayZoomControls(false)）
    await _controller.enableZoom(true);
  }

  /// 导航请求拦截：处理自定义 scheme / 外部协议 / 下载链接
  NavigationDecision _onNavigationRequest(NavigationRequest request) {
    final uri = Uri.tryParse(request.url);
    if (uri == null) return NavigationDecision.navigate;

    final scheme = uri.scheme.toLowerCase();

    // 0. 自定义 scheme 拦截（如 CA 协议 qiyun://signcert/callback → pop 返回 verifyId）
    if (widget.onCustomScheme != null) {
      final result = widget.onCustomScheme!(request.url);
      if (result != null) {
        Navigator.of(context).pop(result); // 返回处理结果并关闭 WebView
        return NavigationDecision.prevent;
      }
    }

    final path = uri.path.toLowerCase();

    // 1. 外部协议 → 使用 url_launcher 跳转
    if (_externalProtocols.contains(scheme)) {
      _launchExternal(request.url);
      return NavigationDecision.prevent;
    }

    // 2. 非 http/https 协议 → 尝试外部打开
    if (scheme != 'http' &&
        scheme != 'https' &&
        scheme != 'about' &&
        scheme != 'data') {
      _launchExternal(request.url);
      return NavigationDecision.prevent;
    }

    // 3. 检测下载文件扩展名
    if (_downloadExtensions.any((ext) => path.endsWith(ext))) {
      _launchExternal(request.url);
      return NavigationDecision.prevent;
    }

    return NavigationDecision.navigate;
  }

  /// 使用 url_launcher 打开外部链接
  Future<void> _launchExternal(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && mounted) {
      EasyLoading.showToast('无法打开链接：$url');
    }
  }

  /// 刷新返回状态
  Future<void> _refreshCanGoBack() async {
    final canGoBack = await _controller.canGoBack();
    if (mounted && canGoBack != _canGoBack) {
      setState(() => _canGoBack = canGoBack);
    }
  }

  /// 回退：优先 WebView 内部回退，否则关闭页面
  Future<void> _goBackOrPop() async {
    if (kIsWeb) {
      if (mounted) Navigator.of(context).pop();
      return;
    }
    if (await _controller.canGoBack()) {
      await _controller.goBack();
      await _refreshCanGoBack();
    } else {
      if (mounted) Navigator.of(context).pop();
    }
  }

  /// 统一头部（TDesign AppTdNavBar）：
  /// - Web：默认返回按钮（showBack: true，Navigator.maybePop）
  /// - 原生：自定义「返回上一页/关闭」双态 leading（跟随 WebView 内部历史）
  AppTdNavBar _buildNavBar() => AppTdNavBar(
    title: widget.title,
    background: widget.headerBackgroundColor,
    titleColor: widget.headerTitleColor,
    showBottomLine: false,
    showBack: kIsWeb,
    leftBarItems: kIsWeb
        ? null
        : [
            TDNavBarItem(
              iconWidget: IconButton(
                icon: Icon(_canGoBack ? Icons.arrow_back : Icons.close),
                tooltip: _canGoBack ? '返回上一页' : '关闭',
                onPressed: _goBackOrPop,
              ),
            ),
          ],
  );

  @override
  Widget build(BuildContext context) {
    // Web 端：自封装 WebUrlIframe 内嵌渲染目标网页（替代 AppWebFallback「浏览器打开」提示）；
    // 若目标网站禁止 iframe（X-Frame-Options/CSP）会白屏，属内嵌方案固有限制。
    if (kIsWeb) {
      return Scaffold(
        appBar: _buildNavBar(),
        body: WebUrlIframe(url: widget.url),
      );
    }
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        await _goBackOrPop();
      },
      child: Scaffold(
        // 对齐 WebActivity —— 品牌蓝头部 + 返回/关闭 + 标题
        appBar: _buildNavBar(),
        body: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_isLoading)
              const Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: LinearProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
