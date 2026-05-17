import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:nova_frame/example/net_demo/page/token_refresh_demo_page.dart';

import '../../../core/shared/layouts/nova_page_shell.dart';
import '../../../core/navigation/annotation/nova_route.dart';
import '../../../core/navigation/protocol/route_navigation.dart';
import '../../../core/shared/box/adapt.dart';
import 'cached_net_request_demo_page.dart';
import 'net_request_demo_page.dart';

abstract final class NetDemoListRt {
  NetDemoListRt._();

  static const String path = '/net_demo/list';
  static const String description = '网络 Demo 入口';
}

@NovaRoute(path: NetDemoListRt.path, description: NetDemoListRt.description)
@RoutePage()
class NetDemoListPage extends NovaPageShell {
  const NetDemoListPage({super.key});

  @override
  Widget buildPhone(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('网络 Demo')),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.dp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 8.dp),
              ElevatedButton(
                onPressed: () => context.push(path: NetRequestDemoRt.path),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 14.dp),
                  child: const Text('A · 网络请求demo'),
                ),
              ),
              SizedBox(height: 16.dp),
              ElevatedButton(
                onPressed: () => context.push(path: CachedNetRequestDemoRt.path),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 14.dp),
                  child: const Text('B · 缓存网络请求数据demo'),
                ),
              ),
              SizedBox(height: 16.dp),
              ElevatedButton(
                onPressed: () => context.push(path: TokenRefreshDemoRt.path),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 14.dp),
                  child: const Text('C · 无感刷新token Demo'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
