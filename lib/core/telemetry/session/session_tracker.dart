import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:nova_frame/core/telemetry/models/nav_operation.dart';
import 'package:nova_frame/core/telemetry/models/session_constants.dart';
import 'package:nova_frame/core/telemetry/navigation/nav_telemetry_labels.dart';
import 'package:nova_frame/core/telemetry/telemetry_config.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:nova_frame/core/foundation/reactive/value_state.dart';
import 'package:nova_frame/core/services/storage/storage.dart';
import 'package:nova_frame/core/services/storage/user_identity.dart';

/// 页面停留埋点
/// 调用 [appendAction] 记录行为，写入 Drift数据库
abstract final class SessionTracker {
  SessionTracker._();

  static final NovaNotifier<String?> sessionIdNotifier = NovaNotifier<String?>(null);

  static final List<String> _sessionStack = <String>[];

  static final List<int> _identityStack = <int>[];
  static final Map<int, String> _routeIdentityToSessionId = <int, String>{};


  static Completer<void>? _flushReplaceBarrier;

  static String? _cachedAppVersion;

  static String? get currentSessionId => _sessionStack.isEmpty ? null : _sessionStack.last;

  static String? sessionIdForRoute(Route<dynamic>? route) {
    if (route is! PageRoute<dynamic>) return null;
    return _routeIdentityToSessionId[identityHashCode(route)];
  }

  static void _setNotifier() {
    sessionIdNotifier.value = currentSessionId;
  }

  static String _newSessionId() {
    final r = Random();
    return 'ps_${DateTime.now().microsecondsSinceEpoch}_${r.nextInt(0x7fffffff)}';
  }

  static String allocateSessionId() => _newSessionId();

  static List<({int routeIdentity, String sessionId})> openStackSnapshotBottomToTop() {
    assert(
      _sessionStack.length == _identityStack.length,
      'session stack out of sync: ${_sessionStack.length} vs ${_identityStack.length}',
    );
    return <({int routeIdentity, String sessionId})>[
      for (var i = 0; i < _sessionStack.length; i++)
        (routeIdentity: _identityStack[i], sessionId: _sessionStack[i]),
    ];
  }

  static void beginFlushReplaceBarrier() {
    assert(_flushReplaceBarrier == null, 'nested flush replace barrier');
    _flushReplaceBarrier = Completer<void>();
  }

  static void endFlushReplaceBarrier() {
    _flushReplaceBarrier?.complete();
    _flushReplaceBarrier = null;
  }

  static Future<void> _awaitFlushReplaceBarrierIfHeld() async {
    while (true) {
      final c = _flushReplaceBarrier;
      if (c == null) return;
      await c.future;
    }
  }

  static void applySessionIdRemap(Map<String, String> oldToNew) {
    for (var i = 0; i < _sessionStack.length; i++) {
      final sid = _sessionStack[i];
      final rep = oldToNew[sid];
      if (rep != null) {
        _sessionStack[i] = rep;
      }
    }
    for (final k in _routeIdentityToSessionId.keys.toList()) {
      final sid = _routeIdentityToSessionId[k]!;
      final rep = oldToNew[sid];
      if (rep != null) {
        _routeIdentityToSessionId[k] = rep;
      }
    }
    _setNotifier();
  }

  static Future<void> handlePush(PageRoute<dynamic> route, {String entryRouteNavOp = NavOperation.push}) async {
    if (!TelemetryConfig.enabled) return;
    final sessionId = _newSessionId();
    final now = Storage.nowMs();
    final routeKey = route.settings.name;
    final routePath = route.settings.name ?? '';
    final pageLabel = NavTelemetryLabels.formatPageRoute(route);
    final routeType = route.runtimeType.toString();
    final identity = identityHashCode(route);

    _routeIdentityToSessionId[identity] = sessionId;
    _sessionStack.add(sessionId);
    _identityStack.add(identity);
    _setNotifier();

    final packageInfo = await PackageInfo.fromPlatform();
    _cachedAppVersion ??= packageInfo.version;

    final platform = defaultTargetPlatform.name;
    final userId = await UserIdentity.analyticsUserIdOrGuest();

    final db = await Storage.db();
    await db.insertPageSession(
      sessionId: sessionId,
      userId: userId,
      pageLabel: pageLabel,
      routeType: routeType,
      routeKey: routeKey,
      routePath: routePath,
      entryRouteNavOp: entryRouteNavOp,
      enterAtMs: now,
      schemaVersion: kSessionDriftSchemaVersion,
      appVersion: _cachedAppVersion,
      platform: platform,
    );
  }

  static Future<void> handlePop(PageRoute<dynamic> route, {String exitRouteNavOp = NavOperation.pop}) async {
    if (!TelemetryConfig.enabled) return;
    final identity = identityHashCode(route);
    final sessionId = _routeIdentityToSessionId.remove(identity);
    if (sessionId == null) return;

    final i = _sessionStack.indexOf(sessionId);
    if (i >= 0) {
      _sessionStack.removeAt(i);
      if (i < _identityStack.length) {
        _identityStack.removeAt(i);
      }
    }
    _setNotifier();

    final now = Storage.nowMs();
    final db = await Storage.db();
    final row = await (db.select(db.sessionTable)..where((t) => t.sessionId.equals(sessionId))).getSingleOrNull();
    if (row == null) return;
    final duration = now - row.enterAtMs;
    await db.closePageSession(
      sessionId: sessionId,
      exitAtMs: now,
      durationMs: duration,
      exitRouteNavOp: exitRouteNavOp,
    );
  }

  /// 记录当前页面中，发生的行为
  static Future<void> appendAction({required String label, String? result, String? desc}) async {
    if (!TelemetryConfig.enabled) return;
    await _awaitFlushReplaceBarrierIfHeld();
    final sid = currentSessionId;
    if (sid == null) return;
    final db = await Storage.db();
    final idx = await db.nextActionIndex(sid);
    final now = Storage.nowMs();
    await db.insertPageSessionAction(
      sessionId: sid,
      actionIndex: idx,
      label: label,
      result: result ?? '',
      desc: desc ?? '',
      createTimeMs: now,
    );
  }
}
