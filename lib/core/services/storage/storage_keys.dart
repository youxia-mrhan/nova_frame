/// 声明全局业务的本地存储key
abstract final class StorageKeys {
  StorageKeys._();

  // ---------------------------------------------------------------------------
  // 用户身份
  // ---------------------------------------------------------------------------

  static const String userIdentityGuestUuid = 'kit.user_identity.guest_uuid';
  static const String userIdentityLoggedUserId = 'kit.user_identity.logged_user_id';

  // ---------------------------------------------------------------------------
  // 其他业务
  // ---------------------------------------------------------------------------

  static const String demoCounterV1 = 'kit.demo.counter_v1';

  /// 切换环境标记
  static const String apiEnvironmentV1 = 'kit.api.environment_v1';

  static const String apiHomeFeedV1 = 'kit.api.home_feed_v1';
  static const String authTokenV1 = 'kit.auth.token_v1';

  /// 与 [Permission.toString] 拼接，供永久拒绝标记使用
  static const String permissionPermanentlyDeniedPrefixV1 = 'kit.permission.permanently_denied_v1.';
}
