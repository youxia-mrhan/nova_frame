import '../../core/services/storage/drift/nova_database.dart';

/// 单条页面会话 + actions → 与上传 / Demo 对齐的 Map 结构。
Map<String, Object?> pageSessionToDebugMap(
  SessionTableData session,
  List<SessionActionTableData> actions,
) {
  return {
    'user_id': session.userId,
    'session_id': session.sessionId,
    'path': session.routePath,
    'entry_route_nav_op': session.entryRouteNavOp,
    'exit_route_nav_op': session.exitRouteNavOp,
    'route_key': session.routeKey,
    'page_label': session.pageLabel,
    'route_type': session.routeType,
    'enter_at_ms': session.enterAtMs,
    'exit_at_ms': session.exitAtMs,
    'duration_ms': session.durationMs,
    'schema_version': session.schemaVersion,
    'actions': [
      for (final a in actions)
        {
          'label': a.label,
          'result': a.result,
          'desc': a.desc,
          'create_time_ms': a.createTimeMs,
        },
    ],
  };
}
