import '../../../core/services/network/api_client.dart';
import '../../../core/services/network/interceptors/error_interceptor.dart';
import '../model/article_list_item_model.dart';

/// 开源 API
/// https://wanandroid.com/blog/show/2
class TempApi {
  final ApiClient _client = ApiClient();

  /// 这个接口会返回 401 错误，模拟token过期
  /// 这个接口可能需要在代理环境下，才能请求成功
  Future<void> get401Code() async {
    final response = await _client.request('https://httpbin.org/bearer', method: HttpMethod.get);
    if (!response.isSuccess) {
      throw NetworkException(errorMsg: response.message);
    }
  }

  Future<List<ArticleListItemModel?>?> getArticleList() async {
    final response = await _client.request(
      '/popular/wenda/json',
      method: HttpMethod.get,
      // queryParameters: {},
      // data: {},
      // parser: (json) => ArticleListItemModel.fromJson(e) // 非列表数据时，直接解析成对象
      parser: (json) {
        final list = json as List;
        return list.map((e) => ArticleListItemModel.fromJson(e)).toList();
      },
    );

    // 如果想改变，当前请求的域名，但又不想修改全局配置
    // 直接写http、https等协议开头的完整URL即可，Dio会优先使用这个URL，而不是全局配置的baseUrl。
    //
    // final response = await _client.request(
    //   'https:www.baidu.com/article/list/$page/json',
    //   method: HttpMethod.get,
    //   queryParameters: {'cid': cid},
    // );

    if (response.isSuccess) {
      return response.data;
    } else {
      throw NetworkException(errorMsg: response.message);
    }
  }
}
