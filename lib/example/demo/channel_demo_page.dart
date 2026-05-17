import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../core/services/native/platform/method_channel_native_platform_api.dart';
import '../../core/shared/layouts/nova_page_shell.dart';
import '../../core/navigation/annotation/nova_route.dart';
import '../../core/shared/box/adapt.dart';

abstract final class ChannelDemoRt {
  ChannelDemoRt._();
  static const String path = '/demo/channel';
  static const String description = 'Channel Demo';
}

@NovaRoute(path: ChannelDemoRt.path, description: ChannelDemoRt.description)
@RoutePage()
class ChannelDemoPage extends NovaStatefulPageShell {
  const ChannelDemoPage({super.key});

  @override
  State<ChannelDemoPage> createState() => _ChannelDemoPageState();
}

class _ChannelDemoPageState extends NovaStatefulPageShellState<ChannelDemoPage> {
  final _api = MethodChannelNativePlatformApi();

  String _text = '-';

  Future<void> _load() async {
    setState(() => _text = 'loading...');
    final r = await _api.getPlatformVersion();
    setState(() {
      _text = r.ok ? r.data! : 'error: ${r.error}';
    });
  }

  @override
  Widget buildPhone(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Channel Demo')),
      body: Padding(
        padding: EdgeInsets.all(16.dp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('说明：Flutter 端只声明接口，由原生端实现'),
            SizedBox(height: 12.dp),
            FilledButton(onPressed: _load, child: const Text('getPlatformVersion')),
            SizedBox(height: 12.dp),
            Text(_text),
          ],
        ),
      ),
    );
  }
}
