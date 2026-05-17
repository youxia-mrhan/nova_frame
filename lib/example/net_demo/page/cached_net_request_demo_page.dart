import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../core/shared/layouts/nova_page_shell.dart';
import '../../../core/navigation/annotation/nova_route.dart';
import '../../../core/foundation/reactive/provided_consumer.dart';
import '../../../core/foundation/reactive/page_state.dart';
import '../model/article_list_item_model.dart';
import '../provider/article_list_provider.dart';

abstract final class CachedNetRequestDemoRt {
  CachedNetRequestDemoRt._();

  static const String path = '/net_demo/cached_net_request_demo';
  static const String description = '缓存网络请求数据demo';
}

@NovaRoute(path: CachedNetRequestDemoRt.path, description: CachedNetRequestDemoRt.description)
@RoutePage()
class CachedNetRequestDemoPage extends NovaPageShell {
  const CachedNetRequestDemoPage({super.key});

  @override
  Widget buildPhone(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('缓存网络请求数据demo')),
      body: NovaProvidedConsumer<ArticleListProvider>(
          create: (_) => ArticleListProvider(),
          builder: (_, model, _) {
            return NovaPageView<List<ArticleListItemModel?>>(
                autoDispose: true, // 自动销毁监听的值，不用手动dispose，默认true
                ls: model.articlesPage,
                onRetry: model.fetchArticles,
                successBuilder: (context, data) {
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final item = data[index];
                      return ListTile(title: Text(item?.title ?? ''), subtitle: const Text('文章简介...'), onTap: () {});
                    },
                  );
                }
            );
          }
      ),
    );
  }
}
