// Sqlite数据库(Drift负责映射表字段工具)
// 两种存储方式：
//
// 方式一：存储json字符串，这种存储方式和shared_preferences类似，
//        修改json结构后，只需要修改StorageKey即可，比如const key = StorageKey(StorageKeys.apiHomeFeedV2);
// FilledButton(
//   onPressed: () async {
//     const key = StorageKey(StorageKeys.apiHomeFeedV1);
//     final now = DateTime.now().toIso8601String();
//     await Storage.apiCachePut(
//       key,
//       json: '{"hello":"drift","time":"$now"}',
//       ttlSeconds: 10,
//     );
//     final json = await Storage.apiCacheGet(key);
//     _toast('drift: get(${key.rawKey}) = ${json ?? "null(过期或不存在)"}');
//   },
//   child: const Text('drift：写入并读取'),
// ),
// 方式二：创建表，定义字段，这种存储方式，修改表结构后，需要修改表的schema版本号，const int kPageSessionSchemaVersion = 2;
//        创建表的具体代码：lib/services/storage/drift/nova_database.dart
//
// 具体升级策略：lib/services/storage/drift/nova_database.dart
//   @override
//   MigrationStrategy get migration => MigrationStrategy(
//         onCreate: (Migrator m) async {
//           await m.createAll();
//         },
//         // onUpgrade 会在打开数据库连接时 执行，且满足下面条件才会触发：
//         // 1、数据库文件 已经存在（不是首次创建）
//         // 2、用户本地记录的旧版本(from) 小于当前代码的 schemaVersion（to）
//         onUpgrade: (Migrator m, int from, int to) async {
//           // 只要 from < to，就清空埋点表并重建
//           if(from < to) {
//             await m.deleteTable(SessionTableNames.actions);
//             await m.deleteTable(SessionTableNames.sessions);
//             await m.createTable(pageSessionsTable);
//             await m.createTable(pageSessionActionsTable);
//           }
//         },
//       );
//
// 方式选择：
// 首先是json这种数据结构
// 1、需要按照条件进行操作，比如增/删/改/查/排序等等，推荐建表；
// 2、只是读取，不怎么频繁修改的数据，使用存储json字符串的方式；
const int kSessionDriftSchemaVersion = 1;

/// 页面 Session 埋点相关 Drift 表名（须与 [SessionTable]、[SessionActionTable] 中 `tableName` 字面量一致，供 migration 等使用）。
abstract final class SessionTableNames {
  SessionTableNames._();

  static const String sessions = 'page_sessions';
  static const String actions = 'page_session_actions';
}

/// [SessionTable.syncStatus]
abstract final class SessionSyncStatus {
  /// 已离开页面，等待上传（或失败后待重试）
  static const int pending = 0;

  /// 已选中，当前批次正在上传，防止并发重复
  static const int sending = 1;
}