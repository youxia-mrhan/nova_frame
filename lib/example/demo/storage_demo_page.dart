import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../core/shared/layouts/nova_page_shell.dart';
import '../../core/navigation/annotation/nova_route.dart';
import '../../core/services/storage/storage.dart';
import '../../core/services/storage/storage_keys.dart';
import '../../core/foundation/logger/nova_logger.dart';
import '../../core/shared/box/adapt.dart';
import '../../core/shared/util/toast_util.dart';

abstract final class StorageDemoRt {
  StorageDemoRt._();

  static const String path = '/demo/storage';
  static const String description = '本地存储 Demo';
}

@NovaRoute(path: StorageDemoRt.path, description: StorageDemoRt.description)
@RoutePage()
class StorageDemoPage extends NovaStatefulPageShell {
  const StorageDemoPage({super.key});

  @override
  State<StorageDemoPage> createState() => _StorageDemoPageState();
}

class _StorageDemoPageState extends NovaStatefulPageShellState<StorageDemoPage> {
  void _toast(String msg) {
    NovaLogger.d(msg);
    if (!mounted) return;
    ToastUtil.show(msg, context: context, gravity: ToastGravity.BOTTOM);
  }

  @override
  Widget buildPhone(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('本地存储 Demo')),
      body: ListView(
        padding: EdgeInsets.all(16.dp),
        children: [
          FilledButton(
            onPressed: () async {
              const key = StorageKey(StorageKeys.demoCounterV1);
              final current = await Storage.prefGetInt(key) ?? 0;
              final next = current + 1;
              await Storage.prefSetInt(key, next);
              final readBack = await Storage.prefGetInt(key);
              _toast('shared_preferences: ${key.rawKey} = $readBack');
            },
            child: const Text('shared_preferences：+1 并读取'),
          ),
          SizedBox(height: 12.dp),
          FilledButton(
            onPressed: () async {
              const key = StorageKey(StorageKeys.apiHomeFeedV1);
              final now = DateTime.now().toIso8601String();
              await Storage.apiCachePut(key, json: '{"hello":"drift","time":"$now"}', ttlSeconds: 10);
              final json = await Storage.apiCacheGet(key);
              _toast('drift: get(${key.rawKey}) = ${json ?? "null(过期或不存在)"}');
            },
            child: const Text('drift：写入并读取'),
          ),
          SizedBox(height: 12.dp),
          FilledButton(
            onPressed: () async {
              const key = StorageKey(StorageKeys.authTokenV1);
              final value = 'token_${DateTime.now().millisecondsSinceEpoch}';
              await Storage.secureWrite(key, value);
              final readBack = await Storage.secureRead(key);
              _toast('secure_storage: ${key.rawKey} = ${readBack ?? "null"}');
            },
            child: const Text('secure_storage：写入并读取'),
          ),
          SizedBox(height: 12.dp),
          FilledButton(
            onPressed: () async {
              const url = 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf';
              try {
                final info = await Storage.cacheDownload(url);
                final cached = await Storage.cacheGetByUrl(url);
                _toast('cache_manager: downloaded=${info.file.path.split("/").last}, cached=${cached != null}');
              } catch (e) {
                _toast('cache_manager: 下载失败 $e');
              }
            },
            child: const Text('cache_manager：下载并读取缓存'),
          ),
        ],
      ),
    );
  }
}
