import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../core/navigation/annotation/nova_route.dart';
import '../../core/shared/box/adapt.dart';
import '../../core/shared/webview/base_webview_page.dart';

abstract final class WebViewRt {
  WebViewRt._();
  static const String path = '/demo/webview_simple';
  static const String description = 'WebView（简版）Demo';
}

@NovaRoute(path: WebViewRt.path, description: WebViewRt.description)
@RoutePage()
class SimpleWebViewDemoPage extends BaseWebViewPage {
  const SimpleWebViewDemoPage({
    super.key,
    @QueryParam('url') this.url,
    @QueryParam('label') this.label,
  });

  final String? url;

  /// 用于区分复用页面的可读名（例如：隐私协议/用户协议）。
  final String? label;

  @override
  Uri get initialUri => Uri.parse(url ?? 'about:blank');

  @override
  State<SimpleWebViewDemoPage> createState() => _SimpleWebViewDemoPageState();
}

class _SimpleWebViewDemoPageState extends BaseWebViewPageState<SimpleWebViewDemoPage> {
  @override
  Widget buildPhone(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: onPopInvokedWithResult,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('WebView（简版）Demo'),
          actions: [
            IconButton(
              tooltip: '后退',
              onPressed: () async {
                if (await webViewController.canGoBack()) {
                  await webViewController.goBack();
                }
              },
              icon: const Icon(Icons.arrow_back),
            ),
            IconButton(
              tooltip: '前进',
              onPressed: () async {
                if (await webViewController.canGoForward()) {
                  await webViewController.goForward();
                }
              },
              icon: const Icon(Icons.arrow_forward),
            ),
            IconButton(
              tooltip: '刷新',
              onPressed: reload,
              icon: const Icon(Icons.refresh),
            ),
          ],
          // 固定高度，避免 bottom 插拔导致 body 上下跳动
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(2.dp),
            child: AnimatedOpacity(
              opacity: loading ? 1 : 0,
              duration: const Duration(milliseconds: 160),
              child: LinearProgressIndicator(value: progress / 100),
            ),
          ),
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: webViewController),
            if (loading) const Center(child: CircularProgressIndicator()),
            if (errorText != null)
              Center(
                child: Padding(
                  padding: EdgeInsets.all(16.dp),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error_outline, size: 48.dp),
                      SizedBox(height: 12.dp),
                      Text(errorText!, textAlign: TextAlign.center),
                      SizedBox(height: 12.dp),
                      FilledButton(
                        onPressed: reload,
                        child: const Text('重试'),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

