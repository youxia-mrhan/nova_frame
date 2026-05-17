import 'dart:math';

import 'package:nova_frame/core/services/storage/storage_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 用户key，唯一性处理
///
/// - 已登录：调用 [setLoggedInUserId]（会持久化，冷启动可读）。
/// - 游客：首次使用自动生成 UUID 写入 prefs，之后不变，直至卸载或手动 [clearGuestUuid]。
abstract final class UserIdentity {
  UserIdentity._();

  /// 游客UUID
  static const _guestUuidPrefsKey = StorageKeys.userIdentityGuestUuid;

  /// 登录用户ID
  static const _loggedUserIdPrefsKey = StorageKeys.userIdentityLoggedUserId;

  static const int _maxSegmentLength = 64;

  static String? _memoryUserId;
  static String? _resolvedStorageSegment;

  /// 登录成功写入业务用户 id；会清空 [storageKeyUserSegment] 缓存。
  static Future<void> setLoggedInUserId(String userId) async {
    final t = userId.trim();
    if (t.isEmpty) {
      await clearLoggedInUser();
      return;
    }
    _memoryUserId = t;
    _resolvedStorageSegment = null;
    final p = await SharedPreferences.getInstance();
    await p.setString(_loggedUserIdPrefsKey, t);
  }

  /// 退出登录：回到游客维度（仍使用同一设备游客 UUID）。
  static Future<void> clearLoggedInUser() async {
    _memoryUserId = null;
    _resolvedStorageSegment = null;
    final p = await SharedPreferences.getInstance();
    await p.remove(_loggedUserIdPrefsKey);
  }

  /// 仅清缓存（例如调试）；下次 [storageKeyUserSegment] 会重新读 prefs。
  static void invalidateStorageSegmentCache() => _resolvedStorageSegment = null;

  /// 供 [StorageKey.resolve] 使用：`usr_{id}` 或 `gst_{uuid}`，仅含安全字符。
  static Future<String> storageKeyUserSegment() async {
    if (_resolvedStorageSegment != null) return _resolvedStorageSegment!;
    final p = await SharedPreferences.getInstance();
    final logged = _memoryUserId ?? p.getString(_loggedUserIdPrefsKey);
    final String segment;
    if (logged != null && logged.isNotEmpty) {
      segment = 'usr_${_sanitize(logged)}';
    } else {
      var guest = p.getString(_guestUuidPrefsKey);
      if (guest == null || guest.isEmpty) {
        guest = _randomUuidHex32();
        await p.setString(_guestUuidPrefsKey, guest);
      }
      segment = 'gst_${_sanitize(guest)}';
    }
    _resolvedStorageSegment = segment;
    return _resolvedStorageSegment!;
  }

  /// 埋点 / 业务：已登录为真实 id；游客为 `guest:{持久化 uuid}`。
  static Future<String> analyticsUserIdOrGuest() async {
    final p = await SharedPreferences.getInstance();
    final logged = _memoryUserId ?? p.getString(_loggedUserIdPrefsKey);
    if (logged != null && logged.isNotEmpty) return logged;
    var guest = p.getString(_guestUuidPrefsKey);
    if (guest == null || guest.isEmpty) {
      guest = _randomUuidHex32();
      await p.setString(_guestUuidPrefsKey, guest);
    }
    return 'guest:$guest';
  }

  /// 调试或「重置设备游客」：删除游客 UUID（下次会重新生成）。
  static Future<void> clearGuestUuid() async {
    _resolvedStorageSegment = null;
    final p = await SharedPreferences.getInstance();
    await p.remove(_guestUuidPrefsKey);
  }

  static String _sanitize(String raw) {
    final s = raw.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');
    if (s.length <= _maxSegmentLength) return s;
    return s.substring(0, _maxSegmentLength);
  }

  static String _randomUuidHex32() {
    final r = Random.secure();
    const chars = '0123456789abcdef';
    return List.generate(32, (_) => chars[r.nextInt(16)]).join();
  }
}
