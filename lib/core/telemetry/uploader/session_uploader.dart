import 'package:nova_frame/core/telemetry/session/session_tracker.dart';

import 'package:nova_frame/core/foundation/logger/nova_logger.dart';
import 'package:nova_frame/core/services/storage/drift/nova_database.dart';
import 'package:nova_frame/core/services/storage/storage.dart';

/// 埋点数据上传 具体实现
abstract final class SessionUploader {
  SessionUploader._();

  static bool _uploading = false;

  static Map<String, Object?> _sessionRowToMap(
    SessionTableData r,
    List<SessionActionTableData> actions, {
    String? uuidOverride,
  }) {
    return <String, Object?>{
      'user_id': r.userId,
      'uuid': uuidOverride ?? r.sessionId,
      'path': r.routePath,
      'entry_route_nav_op': r.entryRouteNavOp,
      'exit_route_nav_op': r.exitRouteNavOp,
      'route_key': r.routeKey,
      'page_label': r.pageLabel,
      'route_type': r.routeType,
      'enter_at_ms': r.enterAtMs,
      'exit_at_ms': r.exitAtMs,
      'duration_ms': r.durationMs,
      'schema_version': r.schemaVersion,
      'app_version': r.appVersion,
      'platform': r.platform,
      'actions': <Map<String, Object?>>[
        for (final a in actions)
          <String, Object?>{'label': a.label, 'result': a.result, 'desc': a.desc, 'create_time_ms': a.createTimeMs},
      ],
    };
  }

  static Future<List<Map<String, Object?>>> _buildPayload(NovaDatabase db, List<SessionTableData> rows) async {
    final out = <Map<String, Object?>>[];
    for (final r in rows) {
      final actions = await db.selectActionsForSession(r.sessionId);
      out.add(_sessionRowToMap(r, actions));
    }
    return out;
  }

  static Future<int> tryFlushRootStackPipeline() async {
    if (_uploading) return 0;
    _uploading = true;
    List<String> idsToSend = const [];
    try {
      final db = await Storage.db();
      final pending = await db.selectPendingPageSessions(limit: 200);
      final snapshot = SessionTracker.openStackSnapshotBottomToTop();

      final openClones =
          <({String oldId, String newId, SessionTableData row, List<SessionActionTableData> actions})>[];
      final oldToNew = <String, String>{};

      for (final pair in snapshot) {
        final loaded = await db.loadSessionWithActions(pair.sessionId);
        if (loaded == null) continue;
        final newId = SessionTracker.allocateSessionId();
        oldToNew[pair.sessionId] = newId;
        openClones.add((oldId: pair.sessionId, newId: newId, row: loaded.session, actions: loaded.actions));
      }

      final payload = <Map<String, Object?>>[];
      idsToSend = pending.map((e) => e.sessionId).toList();
      if (idsToSend.isNotEmpty) {
        await db.markPageSessionsSending(idsToSend);
        payload.addAll(await _buildPayload(db, pending));
      }
      for (final c in openClones) {
        payload.add(_sessionRowToMap(c.row, c.actions, uuidOverride: c.newId));
      }

      if (payload.isEmpty) {
        return 0;
      }

      await _mockUpload(payload);

      final nowMs = Storage.nowMs();
      final restoreRows =
          <({SessionTableData row, String newSessionId, List<SessionActionTableData> actions})>[
            for (final c in openClones) (row: c.row, newSessionId: c.newId, actions: c.actions),
          ];

      SessionTracker.beginFlushReplaceBarrier();
      try {
        await db.replaceAllSessionTrackerWithOpenClones(clones: restoreRows, nowMs: nowMs);
        SessionTracker.applySessionIdRemap(oldToNew);
      } finally {
        SessionTracker.endFlushReplaceBarrier();
      }
      return idsToSend.length + openClones.length;
    } catch (e, st) {
      if (idsToSend.isNotEmpty) {
        final db = await Storage.db();
        await db.markPageSessionsFailed(sessionIds: idsToSend, error: '$e\n$st');
      }
      NovaLogger.d('[SessionUploader] tryFlushRootStackPipeline failed', error: e, stackTrace: st);
      return 0;
    } finally {
      _uploading = false;
    }
  }

  /// 占位：后续替换为真实上传埋点到服务端逻辑。
  static Future<void> _mockUpload(List<Map<String, Object?>> payload) async {
    await Future<void>.delayed(const Duration(milliseconds: 40));
    // NovaLogger.d('[Telemetry] mock upload batch size=${payload.length}');
  }
}
