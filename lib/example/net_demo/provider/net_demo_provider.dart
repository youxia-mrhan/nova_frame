import 'package:flutter/material.dart';

import '../../../../app/res/app_strings.dart';
import '../../../core/foundation/reactive/page_load_state.dart';
import '../../../core/foundation/reactive/page_state.dart';
import '../../../core/services/network/interceptors/error_interceptor.dart';
import '../api/temp_api.dart';
import '../model/article_list_item_model.dart';

/// 业务层
/// 负责处理数据和业务逻辑，提供给UI层调用
class NetDemoProvider extends ChangeNotifier {
  NetDemoProvider() {
    fetchArticles();
  }

  final NovaPageState<List<ArticleListItemModel?>> articlesPage = NovaPageState();

  Future<void> fetchArticles() async {
    articlesPage.value = NovaPageLoadState.loading();
    try {
      final list = await TempApi().getArticleList();
      articlesPage.value = NovaPageLoadState.success(list ?? const []);
    } catch (e) {
      final msg = e is NetworkException ? (e.errorMsg ?? AppStrings.unknownErr) : '$e';
      articlesPage.value = NovaPageLoadState.failure(errorMessage: msg, error: e);
    }
  }

  // @override
  // void dispose() {
  //   super.dispose();
  // }
}
