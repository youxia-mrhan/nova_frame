import 'dart:io' show Platform;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../foundation/logger/nova_logger.dart';
import '../../services/storage/storage.dart';
import '../../services/storage/storage_keys.dart';

/// 权限工具类：统一封装 [permission_handler]，处理 iOS / Android 各版本差异。
///
/// 相册权限（photos）：
///   Android：API 33+ 申请 READ_MEDIA_IMAGES；API 32 及以下回退 storage（READ_EXTERNAL_STORAGE）。
///   Android：API 34+ 若用户选「选择照片」，系统会在授权流程中展示选图界面（非业务选图）。
///   iOS：系统相册授权弹窗（PHPhotoLibrary）。
///
/// 存储权限（storage）：
///   Android：API 33+ 依次申请图片、视频、音频媒体权限；API 32 及以下申请 storage。
///   iOS：无独立「存储」运行时权限，视为已授予。
///
/// 通知权限（notification）：
///   Android：API 33+ 申请 POST_NOTIFICATIONS；API 32 及以下无运行时权限，视为已授予。
///   iOS：系统通知授权弹窗（UNUserNotificationCenter）。
///
/// 定位-使用期间（locationWhenInUse）：
///   Android：直接申请 ACCESS_FINE/COARSE_LOCATION。
///   iOS：直接申请「使用 App 期间」定位。
///
/// 定位-始终（locationAlways）：
///   Android：API 29+ 须先具备「使用期间」定位，再申请后台定位。
///   iOS：在「使用期间」授权后可再申请「始终」。
///
/// 相机 / 麦克风（camera / microphone）：
///   Android：直接申请对应运行时权限。
///   iOS：直接申请，依赖 Info.plist 说明文案。
class PermissionUtil {
  static const List<Permission> _androidMediaStoragePermissions = [
    Permission.photos,
    Permission.videos,
    Permission.audio,
  ];

  static int? _cachedAndroidSdkInt;

  static Future<int?> _androidSdkInt() async {
    if (kIsWeb || !Platform.isAndroid) return null;
    _cachedAndroidSdkInt ??= (await DeviceInfoPlugin().androidInfo).version.sdkInt;
    return _cachedAndroidSdkInt;
  }

  static Future<bool> _isAndroidApi33Plus() async {
    final sdk = await _androidSdkInt();
    return sdk != null && sdk >= 33;
  }

  static Future<bool> _isAndroidApi29Plus() async {
    final sdk = await _androidSdkInt();
    return sdk != null && sdk >= 29;
  }

  /// 将业务侧 [Permission] 解析为当前平台/版本下实际要检查或申请的权限列表。
  ///
  /// 返回空列表表示无需弹窗（例如 iOS 存储、Android 12 以下通知）。
  static Future<List<Permission>> resolveEffectivePermissions(Permission permission) async {
    if (kIsWeb) return [permission];

    if (Platform.isIOS) {
      return _resolveIosEffectivePermissions(permission);
    }

    if (Platform.isAndroid) {
      return _resolveAndroidEffectivePermissions(permission);
    }

    return [permission];
  }

  static List<Permission> _resolveIosEffectivePermissions(Permission permission) {
    switch (permission) {
      // 存储权限：
      //   Android：（见 _resolveAndroidEffectivePermissions）
      //   iOS：无独立运行时权限，返回空列表视为已授予。
      case Permission.storage:
        return const [];
      default:
        return [permission];
    }
  }

  static Future<List<Permission>> _resolveAndroidEffectivePermissions(
    Permission permission,
  ) async {
    final api33Plus = await _isAndroidApi33Plus();

    switch (permission) {
      // 存储权限：
      //   Android：API 33+ 图片+视频+音频；API 32 及以下 storage。
      //   iOS：无独立运行时权限，视为已授予。
      case Permission.storage:
        return api33Plus ? _androidMediaStoragePermissions : [Permission.storage];
      // 相册权限：
      //   Android：API 33+ photos；API 32 及以下回退 storage。
      //   iOS：photos。
      case Permission.photos:
        return api33Plus ? [Permission.photos] : [Permission.storage];
      // 通知权限：
      //   Android：API 33+ notification；API 32 及以下视为已授予。
      //   iOS：notification。
      case Permission.notification:
        return api33Plus ? [Permission.notification] : const [];
      default:
        return [permission];
    }
  }

  static PermissionStatus _mergeStatuses(Iterable<PermissionStatus> statuses) {
    final list = statuses.toList();
    if (list.isEmpty) return PermissionStatus.granted;
    if (list.every((s) => s.isGranted)) return PermissionStatus.granted;
    if (list.any((s) => s.isPermanentlyDenied)) {
      return PermissionStatus.permanentlyDenied;
    }
    if (list.any((s) => s.isLimited)) return PermissionStatus.limited;
    if (list.any((s) => s.isRestricted)) return PermissionStatus.restricted;
    return PermissionStatus.denied;
  }

  static Future<PermissionStatus> _statusOfEffectivePermissions(
    List<Permission> effective,
  ) async {
    if (effective.isEmpty) return PermissionStatus.granted;
    final statuses = await Future.wait(effective.map((p) => p.status));
    return _mergeStatuses(statuses);
  }

  static Future<PermissionStatus> _requestEffectivePermissions(
    Permission permission,
    List<Permission> effective,
  ) async {
    if (effective.isEmpty) return PermissionStatus.granted;

    // 定位-始终权限：
    //   Android：API 29+ 先申请「使用期间」再申请 always。
    //   iOS：由 permission_handler 按系统流程处理。
    if (Platform.isAndroid &&
        permission == Permission.locationAlways &&
        await _isAndroidApi29Plus()) {
      final whenInUseStatus = await Permission.locationWhenInUse.status;
      if (!whenInUseStatus.isGranted && !whenInUseStatus.isLimited) {
        await Permission.locationWhenInUse.request();
      }
    }

    if (effective.length == 1) {
      return effective.single.request();
    }

    final result = await effective.request();
    return _mergeStatuses(result.values);
  }

  static Future<PermissionStatus> _resolvePermissionStatus(Permission permission) async {
    final effective = await resolveEffectivePermissions(permission);
    return _statusOfEffectivePermissions(effective);
  }

  static Future<PermissionStatus> _performRequest(Permission permission) async {
    final effective = await resolveEffectivePermissions(permission);
    return _requestEffectivePermissions(permission, effective);
  }

  /// 请求权限并处理回调
  ///
  /// [permission] 要请求的权限
  /// [onResult] 权限请求结果回调
  /// [autoOpenSettings] 当权限被永久拒绝时是否自动打开设置页面
  ///                     如果为 null，则首次被永久拒绝时不打开，后续才打开
  ///                     如果明确指定 true/false，则按指定值执行
  static Future<void> requestPermission({
    required Permission permission,
    Function(PermissionStatus)? onResult,
    bool? autoOpenSettings,
  }) async {
    try {
      PermissionStatus currentStatus = await _resolvePermissionStatus(permission);

      NovaLogger.d('PermissionUtil: ${permission.toString()} 状态 - $currentStatus');

      if (currentStatus.isPermanentlyDenied) {
        NovaLogger.d('PermissionUtil: 权限已被永久拒绝');

        final shouldOpen = await _shouldOpenSettings(permission, autoOpenSettings);
        if (shouldOpen) {
          NovaLogger.d('PermissionUtil: 权限之前已被永久拒绝过，引导用户到设置页面');
          await openSystemSettings();
        } else {
          await _markPermissionPermanentlyDenied(permission);
          NovaLogger.d('PermissionUtil: 权限首次被永久拒绝，已记录状态');
        }

        onResult?.call(currentStatus);
        return;
      }

      final status = await _performRequest(permission);

      NovaLogger.d('PermissionUtil: 权限请求完成，状态 - $status');

      if (status.isGranted || status.isLimited) {
        await clearPermanentlyDeniedRecord(permission);
      }

      onResult?.call(status);

      if (status.isPermanentlyDenied) {
        final shouldOpen = await _shouldOpenSettings(permission, autoOpenSettings);
        if (shouldOpen) {
          NovaLogger.d('PermissionUtil: 权限请求后被永久拒绝，之前已记录过，引导用户到设置页面');
          await openSystemSettings();
        } else {
          await _markPermissionPermanentlyDenied(permission);
          NovaLogger.d('PermissionUtil: 权限首次被永久拒绝，已记录状态');
        }
      }
    } catch (e) {
      NovaLogger.d('PermissionUtil: 请求权限失败 - $e');
      try {
        final status = await _resolvePermissionStatus(permission);
        onResult?.call(status);
      } catch (_) {
        onResult?.call(PermissionStatus.denied);
      }
    }
  }

  /// 仅查询权限状态（不弹窗）
  static Future<PermissionStatus> checkPermissionStatus(Permission permission) async {
    try {
      return await _resolvePermissionStatus(permission);
    } catch (e) {
      NovaLogger.d('PermissionUtil: 查询权限状态失败 - $e');
      return PermissionStatus.denied;
    }
  }

  static Future<bool> _shouldOpenSettings(Permission permission, bool? autoOpenSettings) async {
    if (autoOpenSettings != null) {
      return autoOpenSettings;
    }
    return _hasPermissionBeenPermanentlyDenied(permission);
  }

  static String _getPermanentlyDeniedKey(Permission permission) {
    return '${StorageKeys.permissionPermanentlyDeniedPrefixV1}${permission.toString()}';
  }

  static Future<bool> _hasPermissionBeenPermanentlyDenied(Permission permission) async {
    try {
      final key = StorageKey(_getPermanentlyDeniedKey(permission));
      return (await Storage.prefGetBool(key)) ?? false;
    } catch (e) {
      NovaLogger.d('PermissionUtil: 检查权限永久拒绝记录失败 - $e');
      return false;
    }
  }

  static Future<void> _markPermissionPermanentlyDenied(Permission permission) async {
    try {
      final key = StorageKey(_getPermanentlyDeniedKey(permission));
      await Storage.prefSetBool(key, true);
    } catch (e) {
      NovaLogger.d('PermissionUtil: 记录权限永久拒绝状态失败 - $e');
    }
  }

  /// 清除权限永久拒绝记录（当权限被重新授予时调用）
  static Future<void> clearPermanentlyDeniedRecord(Permission permission) async {
    try {
      final key = StorageKey(_getPermanentlyDeniedKey(permission));
      await Storage.prefRemove(key);
      NovaLogger.d('PermissionUtil: 已清除权限永久拒绝记录 - ${permission.toString()}');
    } catch (e) {
      NovaLogger.d('PermissionUtil: 清除权限永久拒绝记录失败 - $e');
    }
  }

  static Future<bool> isPermissionGranted(Permission permission) async {
    final status = await checkPermissionStatus(permission);
    return status.isGranted || status.isLimited;
  }

  static Future<bool> isPermissionPermanentlyDenied(Permission permission) async {
    final status = await checkPermissionStatus(permission);
    return status.isPermanentlyDenied;
  }

  static Future<bool> openSystemSettings() async {
    try {
      return await openAppSettings();
    } catch (e) {
      NovaLogger.d('PermissionUtil: 打开设置页面失败 - $e');
      return false;
    }
  }

  /// 批量请求多个权限（每个权限均走平台/版本兼容解析）
  static Future<Map<Permission, PermissionStatus>> requestPermissions({
    required List<Permission> permissions,
    Function(Map<Permission, PermissionStatus>)? onResult,
  }) async {
    try {
      final result = <Permission, PermissionStatus>{};
      for (final permission in permissions) {
        result[permission] = await _performRequest(permission);
      }
      onResult?.call(result);
      return result;
    } catch (e) {
      NovaLogger.d('PermissionUtil: 批量请求权限失败 - $e');
      final deniedStatuses = {
        for (final permission in permissions) permission: PermissionStatus.denied,
      };
      onResult?.call(deniedStatuses);
      return deniedStatuses;
    }
  }

  static String getPermissionStatusDescription(PermissionStatus status) {
    if (status.isGranted) return '已授予';
    if (status.isDenied) return '已拒绝';
    if (status.isPermanentlyDenied) return '已永久拒绝';
    if (status.isLimited) return '受限';
    if (status.isRestricted) return '受限制';
    return '未知状态';
  }

  static Future<bool> shouldShowRequestDialog(Permission permission) async {
    final status = await checkPermissionStatus(permission);
    return status.isDenied;
  }
}
