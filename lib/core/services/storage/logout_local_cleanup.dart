import 'package:nova_frame/core/services/storage/storage.dart';
import 'package:nova_frame/core/services/storage/user_identity.dart';

import '../network/config/auth_config.dart';

/// 用户退出登录时调用：清理缓存。
abstract final class LogoutLocalCleanup {
  LogoutLocalCleanup._();

  static Future<void> clearAll() async {
    await ApiTokenVault.clear();
    await UserIdentity.clearLoggedInUser();
    await Storage.apiCacheClearAll();
    await Storage.cacheClearAll();
  }
}
