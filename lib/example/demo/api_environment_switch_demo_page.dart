import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../core/services/network/api_client.dart';
import '../../core/services/network/config/api_config.dart';
import '../../core/shared/layouts/nova_page_shell.dart';
import '../../core/navigation/annotation/nova_route.dart';
import '../../core/navigation/nova_router.dart';
import '../../core/shared/box/adapt.dart';
import '../../core/shared/dialog/bottom_sheet_dialog.dart';

abstract final class ApiEnvironmentSwitchDemoRt {
  ApiEnvironmentSwitchDemoRt._();

  static const String path = '/demo/api_environment_switch';
  static const String description = '切换 API 环境（持久化 + 重建 Dio）';
}

String _envTitle(ApiEnvironment e) {
  return switch (e) {
    ApiEnvironment.dev => '开发 dev',
    ApiEnvironment.test => '测试 test',
    ApiEnvironment.prod => '生产 prod',
  };
}

@NovaRoute(path: ApiEnvironmentSwitchDemoRt.path, description: ApiEnvironmentSwitchDemoRt.description)
@RoutePage()
class ApiEnvironmentSwitchDemoPage extends NovaStatefulPageShell {
  const ApiEnvironmentSwitchDemoPage({super.key});

  @override
  State<ApiEnvironmentSwitchDemoPage> createState() => _ApiEnvironmentSwitchDemoPageState();
}

class _ApiEnvironmentSwitchDemoPageState extends NovaStatefulPageShellState<ApiEnvironmentSwitchDemoPage> {
  Future<void> _onSelect(ApiEnvironment env) async {
    if (env == ApiConfig.currentEnvironment) {
      if (mounted) await novaRouter.maybePop();
      return;
    }
    await ApiClient.shared.switchEnvironment(env);
    if (!mounted) return;
    await novaRouter.maybePop();
    setState(() {});
  }

  void _openSwitchSheet() {
    final theme = Theme.of(context);
    BottomSheetDialog.show<void>(
      context: context,
      height: const BottomSheetDialogHeight.screenFraction(0.42),
      padding: EdgeInsets.fromLTRB(8.dp, 12.dp, 8.dp, 8.dp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(12.dp, 0, 12.dp, 8.dp),
            child: Text('选择环境', style: theme.textTheme.titleMedium),
          ),
          Expanded(
            child: ListView(
              children: [
                for (final e in ApiEnvironment.values)
                  ListTile(
                    title: Text(_envTitle(e)),
                    subtitle: Text(
                      ApiConfig.hostsForEnvironment(e).apiUrl,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: e == ApiConfig.currentEnvironment
                        ? Icon(Icons.check, color: theme.colorScheme.primary)
                        : null,
                    onTap: () => _onSelect(e),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildPhone(BuildContext context) {
    final theme = Theme.of(context);
    final apiUrl = ApiConfig().apiHosts.apiUrl;
    return Scaffold(
      appBar: AppBar(title: const Text('切换 API 环境')),
      body: ListView(
        padding: EdgeInsets.all(20.dp),
        children: [
          Text('当前环境', style: theme.textTheme.labelLarge),
          SizedBox(height: 4.dp),
          Text(ApiConfig.currentEnvironment.name, style: theme.textTheme.titleMedium),
          SizedBox(height: 16.dp),
          Text('当前 apiUrl（Dio baseUrl）', style: theme.textTheme.labelLarge),
          SizedBox(height: 4.dp),
          SelectableText(apiUrl, style: theme.textTheme.bodyLarge),
          SizedBox(height: 20.dp),
          FilledButton(onPressed: _openSwitchSheet, child: const Text('切换环境')),
          SizedBox(height: 20.dp),
          Card(
            color: theme.colorScheme.surfaceContainerHighest,
            child: Padding(
              padding: EdgeInsets.all(12.dp),
              child: Text(
                '选择后会写入本地 SharedPreferences，并调用 ApiClient.switchEnvironment 重建 Dio。',
                style: theme.textTheme.bodySmall?.copyWith(height: 1.4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
