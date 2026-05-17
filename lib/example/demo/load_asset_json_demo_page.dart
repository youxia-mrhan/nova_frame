import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../core/shared/layouts/nova_page_shell.dart';
import '../../core/navigation/annotation/nova_route.dart';
import '../../core/shared/box/adapt.dart';
import '../../core/shared/util/load_asset_json_util.dart';
import '../../generated/assets.gen.dart';

abstract final class LoadAssetJsonDemoRt {
  LoadAssetJsonDemoRt._();

  static const String path = '/demo/load_asset_json';
  static const String description = '加载本地 JSON Demo';
}

@NovaRoute(path: LoadAssetJsonDemoRt.path, description: LoadAssetJsonDemoRt.description)
@RoutePage()
class LoadAssetJsonDemoPage extends NovaStatefulPageShell {
  const LoadAssetJsonDemoPage({super.key});

  @override
  State<LoadAssetJsonDemoPage> createState() => _LoadAssetJsonDemoPageState();
}

class _LoadAssetJsonDemoPageState extends NovaStatefulPageShellState<LoadAssetJsonDemoPage> {
  dynamic _data;
  String? _error;
  bool _loading = false;

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final res = await LoadAssetJsonUtil.loadJsonFromAssets(assetPath: Assets.json.demo);
      if (mounted) {
        setState(() {
          _data = res;
          _error = res == null ? '读取失败：返回 null（请确认 assets 已在 pubspec.yaml 中声明）' : null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _error = '$e');
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget buildPhone(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('加载本地 JSON Demo')),
      body: ListView(
        padding: EdgeInsets.all(16.dp),
        children: [
          if (_error != null) ...[
            Text(_error!, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.red)),
            SizedBox(height: 12.dp),
            FilledButton.tonal(
              onPressed: _loading ? null : _load,
              child: Text(_loading ? '读取中…' : '重新读取 assets/json/demo.json'),
            ),
          ] else
            Text(
              const JsonEncoder.withIndent('  ').convert(_data),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'Courier'),
            ),
        ],
      ),
    );
  }
}
