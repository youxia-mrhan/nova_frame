import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../telemetry/models/session_constants.dart';

part 'nova_database.g.dart';

/// 通过Drift框架Api，定义的本地数据库，映射表结构
///
/// 存储 接口数据/json 的表结构
class ApiCacheTable extends Table {
  TextColumn get key => text()();
  TextColumn get json => text()();
  IntColumn get updatedAtMs => integer()();
  IntColumn get expireAtMs => integer().nullable()();

  @override
  Set<Column> get primaryKey => {key};
}

/// 进入页面停留埋点表结构
class SessionTable extends Table {

  // Table里面的tableName，必须写字符串，不可以使用 SessionTableNames.sessions; 这种引用
  // 因为drift生成代码时，是通过反射获取表结构的，如果使用引用
  // 运行 dart run build_runner build 可能会报错
  @override
  String get tableName => 'page_sessions';

  TextColumn get sessionId => text()();
  TextColumn get userId => text().nullable()();
  TextColumn get pageLabel => text()();
  TextColumn get routeType => text()();
  TextColumn get routeKey => text().nullable()();
  TextColumn get routePath => text().withDefault(const Constant(''))();
  TextColumn get entryRouteNavOp => text().withDefault(const Constant('push'))();
  TextColumn get exitRouteNavOp => text().nullable()();
  IntColumn get enterAtMs => integer()();
  IntColumn get exitAtMs => integer().nullable()();
  IntColumn get durationMs => integer().nullable()();
  IntColumn get schemaVersion => integer().withDefault(const Constant(1))();
  TextColumn get appVersion => text().nullable()();
  TextColumn get platform => text().nullable()();
  IntColumn get syncStatus => integer().withDefault(const Constant(0))();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();
  IntColumn get createdAtMs => integer()();
  IntColumn get updatedAtMs => integer()();

  @override
  Set<Column> get primaryKey => {sessionId};
}

/// 记录页面行为的表结构
/// 调用appendAction，就是操作这张表
class SessionActionTable extends Table {
  @override
  String get tableName => 'page_session_actions';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get sessionId =>
      text().references(SessionTable, #sessionId, onDelete: KeyAction.cascade)();
  IntColumn get actionIndex => integer()();
  TextColumn get label => text()();
  TextColumn get result => text()();
  TextColumn get desc => text()();
  IntColumn get createTimeMs => integer()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {sessionId, actionIndex},
      ];
}

@DriftDatabase(tables: [ApiCacheTable, SessionTable, SessionActionTable])
class NovaDatabase extends _$NovaDatabase {
  NovaDatabase() : super(_openConnection());

  @override
  int get schemaVersion => kSessionDriftSchemaVersion;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        // onUpgrade 会在打开数据库连接时 执行，且满足下面条件才会触发：
        // 1、数据库文件 已经存在（不是首次创建）
        // 2、用户本地记录的旧版本(from) 小于当前代码的 schemaVersion（to）
        onUpgrade: (Migrator m, int from, int to) async {
          // 只要 from < to，就清空埋点表并重建
          if (from < to) {
            await m.deleteTable(SessionTableNames.actions);
            await m.deleteTable(SessionTableNames.sessions);
            await m.createTable(sessionTable);
            await m.createTable(sessionActionTable);
          }
        },
      );

  Future<void> upsertCache({
    required String key,
    required String json,
    required int updatedAtMs,
    int? expireAtMs,
  }) async {
    await into(apiCacheTable).insertOnConflictUpdate(
      ApiCacheTableCompanion.insert(
        key: key,
        json: json,
        updatedAtMs: updatedAtMs,
        expireAtMs: Value(expireAtMs),
      ),
    );
  }

  Future<String?> readCacheJson(String key, {required int nowMs}) async {
    final row = await (select(apiCacheTable)..where((t) => t.key.equals(key))).getSingleOrNull();
    if (row == null) return null;
    if (row.expireAtMs != null && row.expireAtMs! <= nowMs) return null;
    return row.json;
  }

  Future<void> deleteCache(String key) async {
    await (delete(apiCacheTable)..where((t) => t.key.equals(key))).go();
  }

  Future<int> clearExpired({required int nowMs}) async {
    return (delete(apiCacheTable)..where((t) => t.expireAtMs.isSmallerOrEqualValue(nowMs))).go();
  }

  Future<int> clearAllCache() async {
    return delete(apiCacheTable).go();
  }

  // --- 页面会话埋点 ---

  Future<void> insertPageSession({
    required String sessionId,
    String? userId,
    required String pageLabel,
    required String routeType,
    String? routeKey,
    required String routePath,
    required String entryRouteNavOp,
    required int enterAtMs,
    required int schemaVersion,
    String? appVersion,
    String? platform,
  }) async {
    final now = enterAtMs;
    await into(sessionTable).insert(
      SessionTableCompanion.insert(
        sessionId: sessionId,
        userId: Value(userId),
        pageLabel: pageLabel,
        routeType: routeType,
        routeKey: Value(routeKey),
        routePath: Value(routePath),
        entryRouteNavOp: Value(entryRouteNavOp),
        enterAtMs: enterAtMs,
        schemaVersion: Value(schemaVersion),
        appVersion: Value(appVersion),
        platform: Value(platform),
        createdAtMs: now,
        updatedAtMs: now,
      ),
    );
  }

  Future<void> closePageSession({
    required String sessionId,
    required int exitAtMs,
    required int durationMs,
    required String exitRouteNavOp,
  }) async {
    await (update(sessionTable)..where((t) => t.sessionId.equals(sessionId))).write(
      SessionTableCompanion(
        exitAtMs: Value(exitAtMs),
        durationMs: Value(durationMs),
        exitRouteNavOp: Value(exitRouteNavOp),
        updatedAtMs: Value(exitAtMs),
      ),
    );
  }

  Future<int> nextActionIndex(String sessionId) async {
    final q = selectOnly(sessionActionTable)
      ..addColumns([sessionActionTable.actionIndex.max()])
      ..where(sessionActionTable.sessionId.equals(sessionId));
    final max = await q.map((row) => row.read(sessionActionTable.actionIndex.max())).getSingleOrNull();
    return (max ?? -1) + 1;
  }

  Future<void> insertPageSessionAction({
    required String sessionId,
    required int actionIndex,
    required String label,
    required String result,
    required String desc,
    required int createTimeMs,
  }) async {
    await into(sessionActionTable).insert(
      SessionActionTableCompanion.insert(
        sessionId: sessionId,
        actionIndex: actionIndex,
        label: label,
        result: result,
        desc: desc,
        createTimeMs: createTimeMs,
      ),
    );
    await (update(sessionTable)..where((t) => t.sessionId.equals(sessionId))).write(
      SessionTableCompanion(updatedAtMs: Value(createTimeMs)),
    );
  }

  Future<({SessionTableData session, List<SessionActionTableData> actions})?> loadSessionWithActions(
    String sessionId,
  ) async {
    final session = await (select(sessionTable)..where((t) => t.sessionId.equals(sessionId))).getSingleOrNull();
    if (session == null) return null;
    final actions = await selectActionsForSession(sessionId);
    return (session: session, actions: actions);
  }

  Future<void> restoreOpenPageSessionClone({
    required SessionTableData src,
    required String newSessionId,
    required List<SessionActionTableData> actions,
    required int nowMs,
  }) async {
    await into(sessionTable).insert(
      SessionTableCompanion.insert(
        sessionId: newSessionId,
        userId: Value(src.userId),
        pageLabel: src.pageLabel,
        routeType: src.routeType,
        routeKey: Value(src.routeKey),
        routePath: Value(src.routePath),
        entryRouteNavOp: Value(src.entryRouteNavOp),
        enterAtMs: src.enterAtMs,
        exitAtMs: src.exitAtMs != null ? Value(src.exitAtMs) : const Value.absent(),
        durationMs: src.durationMs != null ? Value(src.durationMs) : const Value.absent(),
        exitRouteNavOp: src.exitRouteNavOp != null ? Value(src.exitRouteNavOp) : const Value.absent(),
        schemaVersion: Value(src.schemaVersion),
        appVersion: Value(src.appVersion),
        platform: Value(src.platform),
        syncStatus: const Value(0),
        retryCount: const Value(0),
        lastError: const Value(null),
        createdAtMs: nowMs,
        updatedAtMs: nowMs,
      ),
    );
    for (final a in actions) {
      await into(sessionActionTable).insert(
        SessionActionTableCompanion.insert(
          sessionId: newSessionId,
          actionIndex: a.actionIndex,
          label: a.label,
          result: a.result,
          desc: a.desc,
          createTimeMs: a.createTimeMs,
        ),
      );
    }
  }

  Future<List<SessionTableData>> selectPendingPageSessions({int limit = 50}) {
    return (select(sessionTable)
          ..where((t) => t.syncStatus.equals(0) & t.exitAtMs.isNotNull())
          ..orderBy([(t) => OrderingTerm.asc(t.createdAtMs)])
          ..limit(limit))
        .get();
  }

  Future<void> markPageSessionsSending(Iterable<String> sessionIds) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await (update(sessionTable)..where((t) => t.sessionId.isIn(sessionIds.toList()))).write(
      SessionTableCompanion(
        syncStatus: const Value(1),
        updatedAtMs: Value(now),
      ),
    );
  }

  Future<void> markPageSessionsFailed({
    required Iterable<String> sessionIds,
    required String error,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    for (final id in sessionIds) {
      final row = await (select(sessionTable)..where((t) => t.sessionId.equals(id))).getSingleOrNull();
      if (row == null) continue;
      await (update(sessionTable)..where((t) => t.sessionId.equals(id))).write(
        SessionTableCompanion(
          syncStatus: const Value(0),
          retryCount: Value(row.retryCount + 1),
          lastError: Value(error),
          updatedAtMs: Value(now),
        ),
      );
    }
  }

  Future<void> deletePageSessionsByIds(Iterable<String> sessionIds) async {
    await (delete(sessionTable)..where((t) => t.sessionId.isIn(sessionIds.toList()))).go();
  }

  /// 上传成功后清空全部埋点数据（会话 + actions）。
  /// - 返回：删除的会话条数（sessions）。
  Future<int> deleteAllSessionTracker() async {
    return transaction(() async {
      await delete(sessionActionTable).go();
      final deletedSessions = await delete(sessionTable).go();
      return deletedSessions;
    });
  }

  /// 上传成功后，再把仍打开中的页面会话按新 id 存入埋点数据库（会话 + actions）
  ///
  /// 为了避免，删除所有埋点数据后，也不影响当前页面继续appendAction
  ///   在上传数据之前，先把当前页面和之前的页面埋点数据，复制一份（SessionId会被修改），
  ///   删除数据后，再将复制的数据的SessionId还原回来
  ///
  /// 场景：
  /// app切入后台：
  ///
  /// A -> B -> C-> D -> E
  /// 比如回到C页面，在上传所有埋点数据前，复制一份C、B、A页面的埋点数据，
  /// 上传成功后删除所有埋点数据，将复制的数据，重新加入埋点数据中
  ///
  /// 初次进入app：
  ///
  /// 上传埋点数据，也会备份当前页面埋点数据，上传完删除后，重新加入埋点数据中
  Future<void> replaceAllSessionTrackerWithOpenClones({
    required List<({
      SessionTableData row,
      String newSessionId,
      List<SessionActionTableData> actions,
    })>
        clones,
    required int nowMs,
  }) async {
    await transaction(() async {
      await delete(sessionActionTable).go();
      await delete(sessionTable).go();
      for (final c in clones) {
        await restoreOpenPageSessionClone(
          src: c.row,
          newSessionId: c.newSessionId,
          actions: c.actions,
          nowMs: nowMs,
        );
      }
    });
  }

  Future<int> pruneOldPageSessions({
    required int maxRows,
    required int olderThanMs,
  }) async {
    final total = await select(sessionTable).get();
    if (total.length <= maxRows) return 0;
    final toDelete = total
        .where((r) => r.createdAtMs < olderThanMs)
        .map((r) => r.sessionId)
        .take(total.length - maxRows)
        .toList();
    if (toDelete.isEmpty) return 0;
    await deletePageSessionsByIds(toDelete);
    return toDelete.length;
  }

  Future<List<SessionActionTableData>> selectActionsForSession(String sessionId) {
    return (select(sessionActionTable)
          ..where((t) => t.sessionId.equals(sessionId))
          ..orderBy([(t) => OrderingTerm.asc(t.actionIndex)]))
        .get();
  }

  /// Demo / 调试：按进入时间倒序返回全部会话（含未 exit）。
  Future<List<SessionTableData>> selectAllPageSessionsNewestFirst() {
    return (select(sessionTable)..orderBy([(t) => OrderingTerm.desc(t.enterAtMs)])).get();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'kit_store.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
