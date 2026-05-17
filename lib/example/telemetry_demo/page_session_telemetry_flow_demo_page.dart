import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:nova_frame/example/telemetry_demo/page_session_telemetry_payload.dart';

import '../../core/shared/layouts/nova_page_shell.dart';
import '../../core/navigation/annotation/nova_route.dart';
import '../../core/navigation/nova_router.dart';
import '../../core/services/storage/storage.dart';
import '../../core/telemetry/session/session_scope.dart';
import '../../core/telemetry/session/session_tracker.dart';
import '../../core/foundation/logger/nova_logger.dart';
import '../../core/shared/box/adapt.dart';
import '../../core/shared/dialog/custom_dialog_util.dart';
import '../../core/shared/dialog/design_aspect_center_dialog.dart';

abstract final class _FlowCopy {
  _FlowCopy._();

  static const String submitTitle = '提交确认';
  static const String submitDesc = '模拟提交前确认。确认或取消会各写一条 action。';
}

abstract final class SessFlowRt {
  SessFlowRt._();

  static const String path = '/demo/page_session_telemetry_flow';
  static const String description = '页面停留埋点 Demo（二级·业务流程）';
}

@NovaRoute(path: SessFlowRt.path, description: SessFlowRt.description)
@RoutePage()
class SessionTrackerFlowDemoPage extends NovaStatefulPageShell {
  const SessionTrackerFlowDemoPage({super.key});

  @override
  State<SessionTrackerFlowDemoPage> createState() => _SessionTrackerFlowDemoPageState();
}

class _SessionTrackerFlowDemoPageState extends NovaStatefulPageShellState<SessionTrackerFlowDemoPage> {
  final List<String> _logLines = <String>[];
  bool _loadingMap = false;
  String? _currentSessionJson;
  String? _followSelection;
  String? _favoriteSelection;
  final ScrollController _currentSessionScrollController = ScrollController();

  @override
  void dispose() {
    _currentSessionScrollController.dispose();
    super.dispose();
  }

  void _recordLog(String msg) {
    if (!mounted) return;
    setState(() {
      _logLines.insert(0, '${Storage.nowMs()}  $msg');
      if (_logLines.length > 100) _logLines.removeLast();
    });
    NovaLogger.d('[PageSessionFlow] $msg');
  }

  Future<void> _append(String label, String result, String desc) async {
    await SessionTracker.appendAction(label: label, result: result, desc: desc);
    _recordLog('$label → $result');
  }

  Future<void> _showSubmitDialog() async {
    final choice = await DesignAspectCenterDialog.show<String>(
      context: context,
      designWidth: 280.dp,
      designHeight: 200.dp,
      animationType: CustomDialogAnimationType.scale,
      barrierDismissible: true,
      borderRadius: 12.rd,
      child: Builder(
        builder: (ctx) => Padding(
          padding: EdgeInsets.all(20.dp),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(_FlowCopy.submitTitle, style: Theme.of(ctx).textTheme.titleLarge),
              SizedBox(height: 12.dp),
              Text(_FlowCopy.submitDesc, style: Theme.of(ctx).textTheme.bodyMedium),
              SizedBox(height: 20.dp),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          novaRouter.pop('取消');
                        },
                        child: Text('取消'),
                      ),
                    ),
                    SizedBox(width: 8.dp),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          novaRouter.pop('确认');
                        },
                        child: Text('确认'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (!mounted || choice == null) return;
    await _append('提交确认弹窗', choice, '用户在提交确认弹窗选择了「$choice」');
  }

  Future<void> _setFollow(String value) async {
    setState(() => _followSelection = value);
    await _append('关注', value, '用户选择关注状态：$value');
  }

  Future<void> _setFavorite(String value) async {
    setState(() => _favoriteSelection = value);
    await _append('收藏', value, '用户选择收藏状态：$value');
  }

  Future<String> _buildCurrentSessionJson() async {
    final sid = SessionTracker.sessionIdForRoute(ModalRoute.of(context));
    if (sid == null) {
      return const JsonEncoder.withIndent('  ').convert(<String, Object?>{'error': '未取到 session_id（当前 Route 未绑定会话）'});
    }
    final db = await Storage.db();
    final session = await (db.select(db.sessionTable)..where((t) => t.sessionId.equals(sid))).getSingleOrNull();
    final actions = await db.selectActionsForSession(sid);
    if (session == null) {
      return const JsonEncoder.withIndent(
        '  ',
      ).convert(<String, Object?>{'error': '本地库无该 session 行', 'session_id': sid});
    }
    return const JsonEncoder.withIndent('  ').convert(pageSessionToDebugMap(session, actions));
  }

  Future<void> _outputCurrentMap() async {
    setState(() => _loadingMap = true);
    try {
      final json = await _buildCurrentSessionJson();
      if (!mounted) return;
      _recordLog('输出当前页 Map（${json.length} 字符）');
      setState(() => _currentSessionJson = json);
    } finally {
      if (mounted) setState(() => _loadingMap = false);
    }
  }

  @override
  Widget buildPhone(BuildContext context) {
    final sid = SessionScope.maybeOf(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('页面停留埋点 · 业务流程')),
      body: ListView(
        padding: EdgeInsets.all(16.dp),
        children: [
          Text('当前会话', style: theme.textTheme.titleSmall),
          SizedBox(height: 4.dp),
          SelectableText(sid ?? '（无）', style: TextStyle(fontSize: 13.fs)),
          SizedBox(height: 20.dp),
          Text('业务流程', style: theme.textTheme.titleMedium),
          SizedBox(height: 8.dp),
          FilledButton.icon(
            onPressed: _showSubmitDialog,
            icon: const Icon(Icons.edit_note_outlined),
            label: const Text('提交弹窗'),
          ),
          SizedBox(height: 16.dp),
          Text('关注', style: theme.textTheme.titleSmall),
          SizedBox(height: 8.dp),
          Wrap(
            spacing: 8.dp,
            runSpacing: 8.dp,
            children: [
              ChoiceChip(
                label: const Text('已关注'),
                selected: _followSelection == '已关注',
                onSelected: (v) {
                  if (v) _setFollow('已关注');
                },
              ),
              ChoiceChip(
                label: const Text('未关注'),
                selected: _followSelection == '未关注',
                onSelected: (v) {
                  if (v) _setFollow('未关注');
                },
              ),
            ],
          ),
          SizedBox(height: 16.dp),
          Text('收藏', style: theme.textTheme.titleSmall),
          SizedBox(height: 8.dp),
          Wrap(
            spacing: 8.dp,
            runSpacing: 8.dp,
            children: [
              ChoiceChip(
                label: const Text('已收藏'),
                selected: _favoriteSelection == '已收藏',
                onSelected: (v) {
                  if (v) _setFavorite('已收藏');
                },
              ),
              ChoiceChip(
                label: const Text('未收藏'),
                selected: _favoriteSelection == '未收藏',
                onSelected: (v) {
                  if (v) _setFavorite('未收藏');
                },
              ),
            ],
          ),
          SizedBox(height: 20.dp),
          Text('调试输出', style: theme.textTheme.titleMedium),
          SizedBox(height: 8.dp),
          FilledButton.tonal(
            onPressed: _loadingMap ? null : _outputCurrentMap,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.data_object_outlined, size: 20.dp),
                SizedBox(width: 8.dp),
                Text(_loadingMap ? '生成中…' : '输出当前页 Map（JSON）'),
              ],
            ),
          ),
          if (_currentSessionJson != null) ...[
            SizedBox(height: 12.dp),
            Text('当前页会话 JSON（可滚动、可复制）', style: theme.textTheme.titleSmall),
            SizedBox(height: 8.dp),
            SizedBox(
              height: 280.dp,
              width: double.infinity,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(8.rd),
                  border: Border.all(color: theme.colorScheme.outlineVariant),
                ),
                child: Scrollbar(
                  controller: _currentSessionScrollController,
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    controller: _currentSessionScrollController,
                    primary: false,
                    padding: EdgeInsets.all(12.dp),
                    child: SelectableText(_currentSessionJson!, style: TextStyle(fontSize: 8.fs, height: 1.45)),
                  ),
                ),
              ),
            ),
          ],
          SizedBox(height: 20.dp),
          Text('埋点字段说明', style: theme.textTheme.titleMedium),
          SizedBox(height: 8.dp),
          const _FieldDocsSection(),
          SizedBox(height: 20.dp),
        ],
      ),
    );
  }
}

class _FieldDocsSection extends StatelessWidget {
  const _FieldDocsSection();

  @override
  Widget build(BuildContext context) {
    final body = Theme.of(context).textTheme.bodySmall;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ExpansionTile(
          title: const Text('会话（page_sessions）'),
          childrenPadding: EdgeInsets.fromLTRB(16.dp, 0, 16.dp, 12.dp),
          children: [
            Text(
              'session_id：一次进入至离开的唯一会话。\n'
              'user_id：埋点身份（登录 id 或 guest）。\n'
              'path：当前页路由 path（与 RouteSettings.name 等一致来源）。\n'
              'route_key：路由 settings.name（可为空）。\n'
              'page_label：可读页名（路由观测格式化）。\n'
              'route_type：PageRoute 类型字符串。\n'
              'entry_route_nav_op：会话创建时的路由动作（push / replace，来自 RouteObserver）。\n'
              'exit_route_nav_op：会话结束时的路由动作（pop / remove / replace），离栈后写入。\n'
              'enter_at_ms / exit_at_ms / duration_ms：进入、离开与停留。\n'
              'schema_version：与 Drift 迁移版本一致，见 lib/telemetry/models/session_constants.dart 中 kSessionDriftSchemaVersion（改表 +1）。',
              style: body,
            ),
          ],
        ),
        ExpansionTile(
          title: const Text('行为（page_session_actions）'),
          childrenPadding: EdgeInsets.fromLTRB(16.dp, 0, 16.dp, 12.dp),
          children: [
            Text(
              'session_id：归属会话。\n'
              'action_index：同会话内顺序。\n'
              'label：业务动作名（如「提交确认弹窗」「关注」）。\n'
              'result：动作结果（如「确认」「已关注」）。\n'
              'desc：补充说明。\n'
              'create_time_ms：写入时间。',
              style: body,
            ),
          ],
        ),
      ],
    );
  }
}
