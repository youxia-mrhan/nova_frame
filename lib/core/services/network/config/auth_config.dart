import 'package:dio/dio.dart' as dio_pkg;

import '../../storage/storage.dart';
import '../../storage/storage_keys.dart';

/// 登录token本地配置
abstract final class ApiTokenVault {
  ApiTokenVault._();

  static final StorageKey _accessKey = StorageKey(StorageKeys.authTokenV1);

  static Future<String?> readAccess() => Storage.secureRead(_accessKey);

  static Future<void> writeAccess(String token) => Storage.secureWrite(_accessKey, token);

  static Future<void> clear() => Storage.secureDelete(_accessKey);
}

/// 存储因为登录token过期，而请求失败的接口配置
/// 登录成功后，重新请求
final class ReAuthQueue {
  final List<PendingAuthRequest> _pending = [];

  void add(dio_pkg.RequestOptions request, dio_pkg.ErrorInterceptorHandler handler) {
    _pending.add(PendingAuthRequest(request, handler));
  }

  bool get isEmpty => _pending.isEmpty;

  bool get isNotEmpty => _pending.isNotEmpty;

  List<PendingAuthRequest> drain() {
    if (_pending.isEmpty) return const [];
    final copy = List<PendingAuthRequest>.from(_pending);
    _pending.clear();
    return copy;
  }

  void clear() => _pending.clear();
}

final class PendingAuthRequest {
  PendingAuthRequest(this.request, this.handler);

  final dio_pkg.RequestOptions request;
  final dio_pkg.ErrorInterceptorHandler handler;
}
