import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../shared/layouts/nova_page_shell.dart';
import '../../navigation/nova_router.dart';

/// WebView 基类：只提供“核心能力”，UI 由子类完全重写。
///
/// 核心能力包括：
/// - WebViewController 初始化与加载
/// - 重定向链 / main frame 门禁，避免 loading/进度条闪烁
/// - loading / progress / error 状态维护
/// - 返回处理（优先 WebView.goBack，否则 pop）
abstract class BaseWebViewPage extends NovaStatefulPageShell {
  const BaseWebViewPage({super.key, super.fillStatusBarBackground});

  /// 初始 URL
  Uri get initialUri;

  /// JS 模式（默认 unrestricted）
  JavaScriptMode get javaScriptMode => JavaScriptMode.unrestricted;

  /// 可选 JS 通道
  List<JavaScriptChannel> get javaScriptChannels => const [];

  /// WebView 背景色（默认透明）
  Color get backgroundColor => Colors.transparent;
}

abstract class BaseWebViewPageState<T extends BaseWebViewPage> extends NovaStatefulPageShellState<T> {
  late final WebViewController webViewController;

  bool loading = true;
  int progress = 0;
  String? errorText;

  int _lastProgress = 0;
  String _latestMainFrameUrl = '';
  int _navSeq = 0;

  @override
  void initState() {
    super.initState();

    _latestMainFrameUrl = widget.initialUri.toString();

    webViewController = WebViewController()
      ..setJavaScriptMode(widget.javaScriptMode)
      ..setBackgroundColor(widget.backgroundColor)
      ..setNavigationDelegate(_createNavigationDelegate())
      ..loadRequest(widget.initialUri);

    for (final ch in widget.javaScriptChannels) {
      webViewController.addJavaScriptChannel(ch.name, onMessageReceived: ch.onMessageReceived);
    }
  }

  NavigationDelegate _createNavigationDelegate() {
    return NavigationDelegate(
      onNavigationRequest: (request) {
        // 只对主 frame 导航展示 loading，避免 iframe/子资源导致 UI 反复闪烁。
        if (!request.isMainFrame) return NavigationDecision.navigate;

        _latestMainFrameUrl = request.url;
        _navSeq += 1;
        final seq = _navSeq;
        if (!mounted) return NavigationDecision.navigate;
        setState(() {
          loading = true;
          errorText = null;
          progress = 0;
          _lastProgress = 0;
        });
        _scheduleFinishGate(seq);
        return NavigationDecision.navigate;
      },
      onPageStarted: (url) {
        if (!mounted) return;
        // 重定向链中会多次触发 started，只接受“最新主 frame URL”的 started。
        if (url != _latestMainFrameUrl) return;
        setState(() => loading = true);
      },
      onProgress: (p) {
        if (!mounted) return;
        // 避免频繁 setState 导致 WebView/布局抖动
        if ((p - _lastProgress).abs() < 2 && p != 100) return;
        _lastProgress = p;
        setState(() => progress = p);
      },
      onPageFinished: (url) {
        if (!mounted) return;
        // 不用 url 做门禁：重定向/内部跳转时 url 可能不一致，导致永远不关闭 loading。
        // 用导航序号 gate：只有“最后一次 main frame 导航”的 finish 才能关闭 loading。
        final seq = _navSeq;
        _scheduleFinishGate(seq);
      },
      onWebResourceError: (e) {
        if (!mounted) return;
        setState(() {
          loading = false;
          errorText = '${e.errorCode} ${e.description}';
        });
      },
    );
  }

  void _scheduleFinishGate(int seq) {
    // 给重定向链/紧邻导航一点时间，避免出现 finish -> 立刻新导航 -> 再次 loading 的闪烁。
    Future<void>.delayed(const Duration(milliseconds: 200)).then((_) {
      if (!mounted) return;
      if (_navSeq != seq) return;
      setState(() {
        loading = false;
        if (progress < 100) progress = 100;
      });
    });
  }

  Future<void> reload() async {
    await webViewController.reload();
  }

  Future<void> goBackOrPop() async {
    if (!mounted) return;
    final canGoBack = await webViewController.canGoBack();
    if (!mounted) return;
    if (canGoBack) {
      await webViewController.goBack();
      return;
    }
    novaRouter.pop();
  }

  /// 子类可直接用的 PopScope handler。
  void onPopInvokedWithResult(bool didPop, Object? result) {
    if (didPop) return;
    goBackOrPop();
  }
}

class JavaScriptChannel {
  const JavaScriptChannel({
    required this.name,
    required this.onMessageReceived,
  });

  final String name;
  final void Function(JavaScriptMessage message) onMessageReceived;
}

