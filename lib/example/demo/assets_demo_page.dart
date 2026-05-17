import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../core/shared/layouts/nova_page_shell.dart';
import '../../core/navigation/annotation/nova_route.dart';
import '../../core/shared/box/adapt.dart';
import '../../generated/assets.gen.dart';
import '../../generated/fonts.gen.dart';

abstract final class AssetsDemoRt {
  AssetsDemoRt._();

  static const String path = '/demo/assets_gen';
  static const String description = 'FlutterGen Assets Demo';
}

@NovaRoute(path: AssetsDemoRt.path, description: AssetsDemoRt.description)
@RoutePage()
class AssetsDemoPage extends NovaPageShell {
  const AssetsDemoPage({super.key});

  @override
  Widget buildPhone(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FlutterGen Assets Demo')),
      body: ListView(
        padding: EdgeInsets.all(16.dp),
        children: [
          Text('图片', style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: 12.dp),
          Wrap(
            spacing: 12.dp,
            runSpacing: 12.dp,
            children: [
              _ImageCard(
                title: 'aiIcon',
                child: Assets.images.aiIcon.image(width: 64.dp, height: 64.dp),
              ),
              _ImageCard(
                title: 'altIcon',
                child: Assets.images.altIcon.image(width: 64.dp, height: 64.dp),
              ),
            ],
          ),
          SizedBox(height: 20.dp),
          Text('Lottie(JSON)', style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: 12.dp),
          Center(
            child: SizedBox(width: 160.dp, height: 160.dp, child: Assets.json.loading.lottie()),
          ),
          SizedBox(height: 20.dp),
          Text('字体（使用 FontFamily.xxx）', style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: 8.dp),
          Text('默认主题字体', style: Theme.of(context).textTheme.bodyLarge),
          SizedBox(height: 4.dp),
          Text('自定义英文字体：Courier', style: const TextStyle(fontFamily: FontFamily.courier)),
        ],
      ),
    );
  }
}

class _ImageCard extends StatelessWidget {
  const _ImageCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(12.dp),
        child: Column(mainAxisSize: MainAxisSize.min, children: [child, SizedBox(height: 8.dp), Text(title)]),
      ),
    );
  }
}
