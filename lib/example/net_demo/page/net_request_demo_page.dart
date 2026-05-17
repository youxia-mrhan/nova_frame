import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../../core/shared/layouts/nova_page_shell.dart';
import '../../../core/navigation/annotation/nova_route.dart';
import '../../../core/foundation/reactive/provided_consumer.dart';
import '../../../core/foundation/reactive/page_state.dart';
import '../model/article_list_item_model.dart';
import '../provider/net_demo_provider.dart';

abstract final class NetRequestDemoRt {
  NetRequestDemoRt._();

  static const String path = '/net_demo/net_request_demo';
  static const String description = '网络请求demo';
}

@NovaRoute(path: NetRequestDemoRt.path, description: NetRequestDemoRt.description)
@RoutePage()
class NetRequestDemoPage extends NovaPageShell {
  const NetRequestDemoPage({super.key});

  @override
  Widget buildPhone(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('网络请求demo')),
      body: NovaProvidedConsumer<NetDemoProvider>(
          create: (_) => NetDemoProvider(),
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
