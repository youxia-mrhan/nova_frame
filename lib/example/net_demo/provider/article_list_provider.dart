import 'package:flutter/foundation.dart';

import '../../../../app/res/app_strings.dart';
import '../../../core/foundation/reactive/page_load_state.dart';
import '../../../core/foundation/reactive/page_state.dart';
import '../../../core/services/network/interceptors/error_interceptor.dart';
import '../../../core/shared/util/toast_util.dart';
import '../api/temp_api.dart';
import '../cache/article_list_cache.dart';
import '../model/article_list_item_model.dart';

/// 业务层
/// 负责处理数据和业务逻辑，提供给UI层调用
class ArticleListProvider extends ChangeNotifier {
  ArticleListProvider() {
    fetchArticles();
  }

  final NovaPageState<List<ArticleListItemModel?>> articlesPage = NovaPageState(NovaPageLoadState.silentRefresh());

  Future<void> fetchArticles() async {
    final cached = await ArticleListCache.readNonEmptyOrNull();
    if (cached != null) {
      articlesPage.value = NovaPageLoadState.silentRefresh(cached);
    } else {
      articlesPage.value = NovaPageLoadState.loading();
    }

    try {
      final list = await TempApi().getArticleList();
      final data = list ?? const <ArticleListItemModel?>[];
      articlesPage.value = NovaPageLoadState.success(data);
      await ArticleListCache.write(data);
    } catch (e) {
      if (cached != null) {
        articlesPage.value = NovaPageLoadState.silentRefresh(cached);
        ToastUtil.show(e is NetworkException ? (e.errorMsg ?? AppStrings.unknownErr) : AppStrings.unknownErr);
      } else {
        final msg = e is NetworkException ? (e.errorMsg ?? AppStrings.unknownErr) : '$e';
        articlesPage.value = NovaPageLoadState.failure(errorMessage: msg, error: e);
      }
    }
  }

  // @override
  // void dispose() {
  //   super.dispose();
  // }
}
