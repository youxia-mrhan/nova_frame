import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nova_frame/example/telemetry_demo/page_session_telemetry_flow_demo_page.dart';
import 'package:nova_frame/example/telemetry_demo/page_session_telemetry_payload.dart';

import '../../core/shared/layouts/nova_page_shell.dart';
import '../../core/navigation/annotation/nova_route.dart';
import '../../core/navigation/protocol/route_navigation.dart';
import '../../core/services/storage/storage.dart';
import '../../core/services/storage/user_identity.dart';
import '../../core/telemetry/session/session_scope.dart';
import '../../core/telemetry/session/session_tracker.dart';
import '../../core/telemetry/telemetry_config.dart';
import '../../core/telemetry/uploader/session_uploader.dart';
import '../../core/foundation/logger/nova_logger.dart';
import '../../core/shared/box/adapt.dart';
import '../../core/shared/util/toast_util.dart';
import '../demo/simple_webview_demo_page.dart';

abstract final class SessTeleRt {
  SessTeleRt._();

  static const String path = '/demo/page_session_telemetry';
  static const String description = '页面停留埋点 Demo（一级）';
}

@NovaRoute(path: SessTeleRt.path, description: SessTeleRt.description)
@RoutePage()
class SessionTrackerDemoPage extends NovaStatefulPageShell {
  const SessionTrackerDemoPage({super.key});

  @override
  State<SessionTrackerDemoPage> createState() => _SessionTrackerDemoPageState();
}

class _SessionTrackerDemoPageState extends NovaStatefulPageShellState<SessionTrackerDemoPage> {
  bool _loadingAll = false;
  int _userIdDisplayKey = 0;
  String? _allSessionsJson;
  int _allSessionsCount = 0;
  final ScrollController _allSessionsScrollController = ScrollController();

  @override
  void dispose() {
    _allSessionsScrollController.dispose();
    super.dispose();
  }

  Future<void> _openFlowDemo() async {
    await context.push(path: SessFlowRt.path);
  }

  Future<void> _refreshAllSessionsJsonFromDb() async {
    final db = await Storage.db();
    final rows = await db.selectAllPageSessionsNewestFirst();
    final list = <Map<String, Object?>>[];
    for (final r in rows) {
      final actions = await db.selectActionsForSession(r.sessionId);
      list.add(pageSessionToDebugMap(r, actions));
    }
    final json = const JsonEncoder.withIndent('  ').convert(list);
    if (!mounted) return;
    NovaLogger.d('[SessionTrackerDemo][all_sessions]\n$json');
    setState(() {
      _allSessionsJson = json;
      _allSessionsCount = list.length;
    });
  }

  Future<void> _outputAllSessions() async {
    setState(() => _loadingAll = true);
    try {
      if (!mounted) return;
      await _refreshAllSessionsJsonFromDb();
      // 返回删除成功的条数 deleted > 0，表示删除成功
      final deleted = await SessionUploader.tryFlushRootStackPipeline();
      if (!mounted) return;
      ToastUtil.show(
        '上传成功，已清空 $deleted 条会话埋点',
        context: context,
        gravity: ToastGravity.BOTTOM,
      );
    } finally {
      if (mounted) setState(() => _loadingAll = false);
    }
  }

  @override
  Widget buildPhone(BuildContext context) {
    final sid = SessionScope.maybeOf(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('页面停留埋点 · 总览')),
      body: ListView(
        padding: EdgeInsets.all(16.dp),
        children: [
          Text('全局开关', style: theme.textTheme.titleMedium),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('页面停留埋点'),
            subtitle: Text(
              TelemetryConfig.enabled ? '已开启：记录会话并上传' : '已关闭：不写入、不上传',
            ),
            value: TelemetryConfig.enabled,
            onChanged: (v) async {
              await TelemetryConfig.setEnabled(v);
              if (mounted) setState(() {});
            },
          ),
          SizedBox(height: 16.dp),
          Text('会话与身份', style: theme.textTheme.titleMedium),
          SizedBox(height: 8.dp),
          _kv('session_id', sid ?? '（无）'),
          SizedBox(height: 8.dp),
          Text('埋点 user_id', style: theme.textTheme.titleSmall),
          SizedBox(height: 4.dp),
          FutureBuilder<String>(
            key: ValueKey<int>(_userIdDisplayKey),
            future: UserIdentity.analyticsUserIdOrGuest(),
            builder: (context, snap) {
              return SelectableText(snap.data ?? '…', style: TextStyle(fontSize: 14.fs));
            },
          ),
          SizedBox(height: 12.dp),
          Text('模拟登录 / 登出', style: theme.textTheme.titleMedium),
          SizedBox(height: 8.dp),
          Wrap(
            spacing: 8.dp,
            runSpacing: 8.dp,
            children: [
              FilledButton.tonal(
                onPressed: () async {
                  await UserIdentity.setLoggedInUserId('demo_user_001');
                  if (mounted) setState(() => _userIdDisplayKey++);
                  SessionTracker.appendAction(label: '模拟登录');
                },
                child: const Text('模拟登录'),
              ),
              FilledButton.tonal(
                onPressed: () async {
                  await UserIdentity.clearLoggedInUser();
                  if (mounted) setState(() => _userIdDisplayKey++);
                  SessionTracker.appendAction(label: '模拟登出');
                },
                child: const Text('模拟登出'),
              ),
            ],
          ),
          SizedBox(height: 24.dp),
          Text('业务流程 Demo', style: theme.textTheme.titleMedium),
          SizedBox(height: 8.dp),
          FilledButton.icon(
            onPressed: _openFlowDemo,
            icon: const Icon(Icons.touch_app_outlined),
            label: const Text('进入二级：弹窗 / 关注 / 收藏'),
          ),
          SizedBox(height: 8.dp),
          FilledButton.icon(
            onPressed: () {
              context.push(
                path: WebViewRt.path,
                query: <String, dynamic>{'url': 'https://juejin.cn', 'label': '隐私协议'},
              );
            },
            icon: const Icon(Icons.touch_app_outlined),
            label: const Text('复用页面区分：隐私协议'),
          ),
          SizedBox(height: 8.dp),
          FilledButton.icon(
            onPressed: () {
              context.push(
                path: WebViewRt.path,
                query: <String, dynamic>{'url': 'https://www.csdn.net', 'label': '用户协议'},
              );
            },
            icon: const Icon(Icons.touch_app_outlined),
            label: const Text('复用页面区分：用户协议'),
          ),
          SizedBox(height: 24.dp),
          Text('全部埋点数据', style: theme.textTheme.titleMedium),
          SizedBox(height: 8.dp),
          FilledButton.icon(
            onPressed: _loadingAll ? null : _outputAllSessions,
            icon: const Icon(Icons.list_alt_outlined),
            label: Text(_loadingAll ? '读取中…' : '输出全部页面埋点，并上传服务端'),
          ),
          if (_allSessionsJson != null) ...[
            SizedBox(height: 12.dp),
            Text('全部会话 JSON（可滚动、可复制）', style: theme.textTheme.titleSmall),
            SizedBox(height: 4.dp),
            Text('共 $_allSessionsCount 条', style: theme.textTheme.bodySmall),
            SizedBox(height: 8.dp),
            SizedBox(
              height: 320.dp,
              width: double.infinity,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(8.rd),
                  border: Border.all(color: theme.colorScheme.outlineVariant),
                ),
                child: Scrollbar(
                  controller: _allSessionsScrollController,
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    controller: _allSessionsScrollController,
                    primary: false,
                    padding: EdgeInsets.all(12.dp),
                    child: SelectableText(_allSessionsJson!, style: TextStyle(fontSize: 8.fs, height: 1.45)),
                  ),
                ),
              ),
            ),
          ],
          SizedBox(height: 24.dp),
        ],
      ),
    );
  }

  static Widget _kv(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.fs)),
        SizedBox(height: 4.dp),
        SelectableText(value, style: TextStyle(fontSize: 14.fs)),
      ],
    );
  }
}
