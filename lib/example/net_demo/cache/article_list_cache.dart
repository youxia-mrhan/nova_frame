import 'dart:convert';

import '../../../core/services/storage/storage.dart';
import '../model/article_list_item_model.dart';

/// 缓存 /popular/wenda/json 接口数据
/// 使用场景一般在，首页的几个TabView接口数据都可以缓存，提升用户体验
abstract final class ArticleListCache {
  ArticleListCache._();

  /// 如果接口数据结构发生变化，记得修改这个 key，避免解析旧数据失败
  /// 比如 popular_wenda_json_v2
  static final StorageKey _key = StorageKey('popular_wenda_json_v1');

  /// 返回非空列表，如果缓存 不存在 或 解析失败则返回 null
  static Future<List<ArticleListItemModel?>?> readNonEmptyOrNull() async {
    try {
      final raw = await Storage.apiCacheGet(_key);
      if (raw == null || raw.isEmpty) return null;
      final list = _decode(raw);
      if (list == null || list.isEmpty) return null;
      return list;
    } catch (_) {
      return null;
    }
  }

  /// 写入缓存
  static Future<void> write(List<ArticleListItemModel?> data) {
    return Storage.apiCachePut(_key, json: _encode(data));
  }

  /// 转成json字符串
  static String _encode(List<ArticleListItemModel?> list) {
    return jsonEncode(list.map((e) => e?.toJson()).toList());
  }

  /// json字符串 转回 实体
  static List<ArticleListItemModel?>? _decode(String raw) {
    final decoded = jsonDecode(raw);
    if (decoded is! List) return null;
    return decoded
        .map((e) => e == null ? null : ArticleListItemModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }
}
