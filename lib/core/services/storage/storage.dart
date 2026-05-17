import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'drift/nova_database.dart';
import 'user_identity.dart';

/// 本地存储 key格式：`{业务Key}__登录用户/游客用户{加密字符串}`
/// 目的：
/// - 避免升级 app 后，旧版本写入的本地数据结构变化导致崩溃（版本隔离）
class StorageKey {
  const StorageKey(this.rawKey);

  final String rawKey;

  Future<String> resolve() async {
    final uidSeg = await UserIdentity.storageKeyUserSegment();
    return '${rawKey}__uid$uidSeg';
  }
}

/// 本地存储统一入口：业务侧只依赖这 4 个方法。
///
/// - shared_preferences：存储配置（轻量 KV）
/// - drift(SQLite)：存储接口数据（例如首页 TabView 的列表缓存）
/// - flutter_secure_storage：存储敏感数据（例如登录 token）
/// - flutter_cache_manager：音视频缓存（文件缓存）
class Storage {
  Storage._();

  static SharedPreferences? _prefs;
  static NovaDatabase? _db;
  static Future<NovaDatabase>? _dbFuture;
  static FlutterSecureStorage? _secure;
  static CacheManager? _cache;

  /// 统一时间戳：毫秒
  static int nowMs() => DateTime.now().millisecondsSinceEpoch;

  /// -------------------------
  /// shared_preferences（配置/状态）
  /// -------------------------

  /// 示例：
  /// ```dart
  /// final key = StorageKey(StorageKeys.demoCounterV1);
  /// await Storage.prefSetInt(key, 1);
  /// final v = await Storage.prefGetInt(key);
  /// ```

  /// shared_preferences：配置存储（轻量 KV）
  static Future<SharedPreferences> prefs() async {
    return _prefs ??= await SharedPreferences.getInstance();
  }

  // --- shared_preferences：配置读写（增/删/改/查） ---

  static Future<String?> prefGetString(StorageKey key) async {
    final k = await key.resolve();
    return (await prefs()).getString(k);
  }

  static Future<int?> prefGetInt(StorageKey key) async {
    final k = await key.resolve();
    return (await prefs()).getInt(k);
  }

  static Future<double?> prefGetDouble(StorageKey key) async {
    final k = await key.resolve();
    return (await prefs()).getDouble(k);
  }

  static Future<bool?> prefGetBool(StorageKey key) async {
    final k = await key.resolve();
    return (await prefs()).getBool(k);
  }

  static Future<void> prefSetString(StorageKey key, String value) async {
    final k = await key.resolve();
    await (await prefs()).setString(k, value);
  }

  static Future<void> prefSetInt(StorageKey key, int value) async {
    final k = await key.resolve();
    await (await prefs()).setInt(k, value);
  }

  static Future<void> prefSetDouble(StorageKey key, double value) async {
    final k = await key.resolve();
    await (await prefs()).setDouble(k, value);
  }

  static Future<void> prefSetBool(StorageKey key, bool value) async {
    final k = await key.resolve();
    await (await prefs()).setBool(k, value);
  }

  static Future<void> prefRemove(StorageKey key) async {
    final k = await key.resolve();
    await (await prefs()).remove(k);
  }

  /// -------------------------
  /// drift(SQLite)（接口数据缓存）
  /// -------------------------

  static Future<NovaDatabase> db() async {
    if (_db != null) return _db!;
    return _dbFuture ??= _initDb();
  }

  static Future<NovaDatabase> _initDb() async {
    try {
      return _db = NovaDatabase();
    } catch (_) {
      // 初始化失败时允许后续重试，避免 Future 缓存成永久失败态。
      _dbFuture = null;
      rethrow;
    }
  }

  // --- drift：接口数据缓存（增/删/改/查） ---
  ///
  /// 示例：
  /// ```dart
  /// final key = StorageKey(StorageKeys.apiHomeFeedV1);
  /// await Storage.apiCachePut(key, json: '{"hello":"drift"}', ttlSeconds: 60);
  /// final json = await Storage.apiCacheGet(key);
  /// ```

  /// 写入接口缓存（json 字符串）。可选 TTL（秒）。
  /// ttlSeconds：数据过期时间，单位秒。null 表示永不过期。
  static Future<void> apiCachePut(StorageKey key, {required String json, int? ttlSeconds}) async {
    final k = await key.resolve();
    final now = nowMs();
    final expireAt = ttlSeconds == null ? null : now + ttlSeconds * 1000;
    await (await db()).upsertCache(key: k, json: json, updatedAtMs: now, expireAtMs: expireAt);
  }

  /// 读取接口缓存（json 字符串）。如果已过期返回 null。
  static Future<String?> apiCacheGet(StorageKey key) async {
    final k = await key.resolve();
    return (await db()).readCacheJson(k, nowMs: nowMs());
  }

  static Future<void> apiCacheDelete(StorageKey key) async {
    final k = await key.resolve();
    await (await db()).deleteCache(k);
  }

  /// 清理过期缓存，返回清理条数。
  static Future<int> apiCacheClearExpired() async {
    return (await db()).clearExpired(nowMs: nowMs());
  }

  static Future<int> apiCacheClearAll() async {
    return (await db()).clearAllCache();
  }

  /// flutter_secure_storage：敏感信息（token / refreshToken 等）
  static FlutterSecureStorage secure() {
    return _secure ??= const FlutterSecureStorage();
  }

  // --- flutter_secure_storage：敏感信息（增/删/改/查） ---

  /// 示例：
  /// ```dart
  /// final tokenKey = StorageKey(StorageKeys.authTokenV1);
  /// await Storage.secureWrite(tokenKey, 'xxx');
  /// final token = await Storage.secureRead(tokenKey);
  /// ```
  static Future<void> secureWrite(StorageKey key, String value) async {
    final k = await key.resolve();
    await secure().write(key: k, value: value);
  }

  static Future<String?> secureRead(StorageKey key) async {
    final k = await key.resolve();
    return secure().read(key: k);
  }

  static Future<void> secureDelete(StorageKey key) async {
    final k = await key.resolve();
    await secure().delete(key: k);
  }

  static Future<void> secureDeleteAll() async {
    await secure().deleteAll();
  }

  /// flutter_cache_manager：文件缓存（图片/音频/视频）
  static CacheManager cache() {
    return _cache ??= DefaultCacheManager();
  }

  // --- flutter_cache_manager：文件缓存（增/删/改/查） ---

  /// 示例：
  /// ```dart
  /// const url = 'https://example.com/video.mp4';
  /// // 不传 cacheKey：默认按 url 作为缓存标识
  /// await Storage.cacheDownload(url);
  /// final file = await Storage.cacheGetByUrl(url);
  ///
  /// // 你也可以显式传 cacheKey（会按版本化 key 隔离旧缓存）
  /// final cacheKey = StorageKey(StorageKeys.xxx); // 在 [StorageKeys] 中新增业务 media 常量
  /// await Storage.cacheDownload(url, cacheKey: cacheKey);
  /// final file2 = await Storage.cacheGetByKey(cacheKey);
  /// ```

  /// 预下载并写入缓存，返回本地文件（可用于音视频预加载）。
  /// 说明：
  /// - `url` 仍作为文件来源标识
  /// - 如果你显式传了 `cacheKey`，则会被版本化，避免旧协议缓存导致问题
  static Future<FileInfo> cacheDownload(String url, {StorageKey? cacheKey}) async {
    final key = cacheKey == null ? null : await cacheKey.resolve();
    return cache().downloadFile(url, key: key);
  }

  /// 从缓存中读取文件信息（不存在返回 null），按 url 读取。
  static Future<FileInfo?> cacheGetByUrl(String url) async {
    return cache().getFileFromCache(url);
  }

  /// 从缓存中读取文件信息（不存在返回 null），按版本化 key 读取。
  static Future<FileInfo?> cacheGetByKey(StorageKey cacheKey) async {
    final key = await cacheKey.resolve();
    return cache().getFileFromCache(key);
  }

  /// 删除指定缓存文件（按 url）。
  static Future<void> cacheRemoveByUrl(String url) async {
    await cache().removeFile(url);
  }

  /// 删除指定缓存文件（按版本化 key）。
  static Future<void> cacheRemoveByKey(StorageKey cacheKey) async {
    final key = await cacheKey.resolve();
    await cache().removeFile(key);
  }

  /// 清空全部文件缓存。
  static Future<void> cacheClearAll() async {
    await cache().emptyCache();
  }
}
