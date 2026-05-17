import '../../storage/storage.dart';
import '../../storage/storage_keys.dart';

/// API 环境配置
enum ApiEnvironment { dev, test, prod }

class ApiHosts {
  String baseUrl;

  /// api前缀
  /// 开发过程中，经常通过不同api前缀，连接不同环境，和后端联调会用到
  String? apiPrefix;

  String get apiUrl => (apiPrefix != null && apiPrefix != '') ? '$baseUrl/$apiPrefix' : baseUrl;

  ApiHosts({required this.baseUrl, this.apiPrefix});
}

class ApiConfig {
  ApiConfig._() : _apiHosts = hostsForEnvironment(_currentEnvironment);

  static final ApiConfig _instance = ApiConfig._();

  static final StorageKey _environmentPrefsKey = StorageKey(StorageKeys.apiEnvironmentV1);

  factory ApiConfig() => _instance;

  ApiHosts _apiHosts;

  ApiHosts get apiHosts => _apiHosts;

  /// 抓包工具的代理地址:端口
  static String? caughtAddress;

  static ApiEnvironment _currentEnvironment = ApiEnvironment.prod;

  /// 获取当前环境
  static ApiEnvironment get currentEnvironment => _currentEnvironment;

  /// 设置当前环境
  static set currentEnvironment(ApiEnvironment env) {
    _currentEnvironment = env;
    _instance._apiHosts = hostsForEnvironment(env);
  }

  /// 冷启动从 [SharedPreferences] 恢复
  /// 无记录或非法值则保持默认 [ApiEnvironment.prod]
  static Future<void> loadPersistedOrDefault() async {
    final idx = await Storage.prefGetInt(_environmentPrefsKey);
    if (idx == null) return;
    if (idx < 0 || idx >= ApiEnvironment.values.length) return;
    _currentEnvironment = ApiEnvironment.values[idx];
    _instance._apiHosts = hostsForEnvironment(_currentEnvironment);
  }

  /// 根据环境获取对应的 baseUrl
  static ApiHosts hostsForEnvironment(ApiEnvironment env) {
    switch (env) {
      case ApiEnvironment.dev:
        return ApiHosts(baseUrl: 'https://httpbin.org', apiPrefix: null);
      case ApiEnvironment.test:
        return ApiHosts(baseUrl: 'https://jsonplaceholder.typicode.com', apiPrefix: null);
      case ApiEnvironment.prod:
        return ApiHosts(baseUrl: 'https://wanandroid.com', apiPrefix: null);
    }
  }

  /// 超时配置
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
  static const int sendTimeout = 30000;
}
