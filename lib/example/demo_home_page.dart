import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:nova_frame/example/push_link/fake_push_link_demo_page.dart';
import 'package:nova_frame/example/router_demo/entity/demo_user_entity.dart';
import 'package:nova_frame/example/router_demo/entity_params_adaptive_stateful_demo_page.dart';
import 'package:nova_frame/example/router_demo/entity_params_demo_page.dart';
import 'package:nova_frame/example/router_demo/login/login_shell_route_pages.dart';
import 'package:nova_frame/example/router_demo/primitive_params_adaptive_stateful_demo_page.dart';
import 'package:nova_frame/example/router_demo/primitive_params_demo_page.dart';
import 'package:nova_frame/example/telemetry_demo/page_session_telemetry_demo_page.dart';

import '../core/navigation/link/nova_link_scheme.dart';
import '../core/shared/layouts/nova_page_shell.dart';
import '../core/navigation/annotation/nova_route.dart';
import '../core/navigation/protocol/route_navigation.dart';
import '../core/shared/action/widget/double_tap_exit.dart';
import '../core/shared/action/widget/init_config_box.dart';
import '../core/shared/box/adapt.dart';
import 'demo/adaptive_stateful_demo_page.dart';
import 'demo/api_environment_switch_demo_page.dart';
import 'demo/assets_demo_page.dart';
import 'demo/channel_demo_page.dart';
import 'demo/custom_dialog_demo_page.dart';
import 'demo/device_form_factor_demo_page.dart';
import 'demo/eventbus_demo_page.dart';
import 'demo/load_asset_json_demo_page.dart';
import 'demo/mixins_demo_page.dart';
import 'demo/permission_demo_page.dart';
import 'demo/rate_limit_tap_demo_page.dart';
import 'demo/refresh_load_demo_page.dart';
import 'demo/route_telemetry_context_demo_page.dart';
import 'demo/screenutil_demo_page.dart';
import 'demo/simple_webview_demo_page.dart';
import 'demo/storage_demo_page.dart';
import 'demo/system_ui_styles_demo_page.dart';
import 'demo/theme_demo_page.dart';
import 'demo/toast_demo_page.dart';
import 'demo/vns_sbx_demo_page.dart';
import 'net_demo/page/net_demo_list_page.dart';

abstract final class DemoRouteRt {
  DemoRouteRt._();

  static const String path = '/';
  static const String description = 'Demo 首页';
}

class _DemoEntry {
  const _DemoEntry({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
}

@NovaRoute(path: DemoRouteRt.path, description: DemoRouteRt.description)
@RoutePage()
class DemoHomePage extends NovaPageShell {
  const DemoHomePage({super.key});

  void _pushLoginOverlay(BuildContext context) {
    context.push(path: LoginOverlayRt.path);
  }

  void _pushLoginFullScreen(BuildContext context) {
    context.push(path: LoginFullRt.path);
  }

  List<_DemoEntry> _entries(BuildContext context) {
    return [
      _DemoEntry(
        title: '网络请求封装',
        subtitle: '网络 / 缓存 / Token',
        icon: Icons.cloud_outlined,
        onTap: () => context.push(path: NetDemoListRt.path),
      ),
      _DemoEntry(
        title: 'API 环境切换',
        subtitle: '弹窗选环境 + 重建 Dio',
        icon: Icons.swap_horiz_outlined,
        onTap: () => context.push(path: ApiEnvironmentSwitchDemoRt.path),
      ),
      _DemoEntry(
        title: 'ScreenUtil',
        subtitle: '12.dp / 14.fs / 12.rd',
        icon: Icons.aspect_ratio_outlined,
        onTap: () => context.push(path: ScreenUtilDemoRt.path),
      ),
      _DemoEntry(
        title: '本地存储',
        subtitle: 'pref / drift / secure',
        icon: Icons.storage_outlined,
        onTap: () => context.push(path: StorageDemoRt.path),
      ),
      _DemoEntry(
        title: '权限',
        subtitle: '麦克风 / 相机 / 相册等',
        icon: Icons.admin_panel_settings_outlined,
        onTap: () => context.push(path: PermissionDemoRt.path),
      ),
      _DemoEntry(
        title: 'EventBus',
        subtitle: '广播 + 定向推送',
        icon: Icons.hub_outlined,
        onTap: () => context.push(path: EventBusDemoRt.path),
      ),
      _DemoEntry(
        title: '本地 JSON',
        subtitle: 'rootBundle + decode',
        icon: Icons.data_object_outlined,
        onTap: () => context.push(path: LoadAssetJsonDemoRt.path),
      ),
      _DemoEntry(
        title: 'FlutterGen Assets',
        subtitle: 'images / json / font',
        icon: Icons.image_outlined,
        onTap: () => context.push(path: AssetsDemoRt.path),
      ),
      _DemoEntry(
        title: '主题切换',
        subtitle: 'light / dark / ocean',
        icon: Icons.palette_outlined,
        onTap: () => context.push(path: ThemeDemoRt.path),
      ),
      _DemoEntry(
        title: '设备形态适配',
        subtitle: 'phone / pad / fold',
        icon: Icons.devices_outlined,
        onTap: () => context.push(path: DeviceFormFactorDemoRt.path),
      ),
      _DemoEntry(
        title: 'Stateful Shell',
        subtitle: 'initState + 分支 build',
        icon: Icons.layers_outlined,
        onTap: () => context.push(path: AdaptiveStatefulDemoRt.path),
      ),
      _DemoEntry(
        title: 'Mixins',
        subtitle: '各 mixin 子 Demo',
        icon: Icons.extension_outlined,
        onTap: () => context.push(path: MixinsDemoRt.path),
      ),
      _DemoEntry(
        title: '路由可读信息',
        subtitle: 'TelemetryContext',
        icon: Icons.route_outlined,
        onTap: () => context.push(path: RouteTelemetryContextDemoRt.path),
      ),
      _DemoEntry(
        title: 'Fake Push / 深链',
        subtitle: NovaLinkScheme.origin(),
        icon: Icons.link_outlined,
        onTap: () => context.push(path: FakePushLinkRt.path),
      ),
      _DemoEntry(
        title: '页面停留埋点',
        subtitle: '会话 / Drift 导出',
        icon: Icons.analytics_outlined,
        onTap: () => context.push(path: SessTeleRt.path),
      ),
      _DemoEntry(
        title: 'WebView（简版）',
        subtitle: '进度 / 错误重试',
        icon: Icons.language_outlined,
        onTap: () => context.push(
          path: WebViewRt.path,
          query: <String, dynamic>{'url': 'https://www.baidu.com'},
        ),
      ),
      _DemoEntry(
        title: 'Channel',
        subtitle: 'MethodChannel 抽象',
        icon: Icons.cable_outlined,
        onTap: () => context.push(path: ChannelDemoRt.path),
      ),
      _DemoEntry(
        title: '自定义弹窗',
        subtitle: '缩放 / 滑动动画',
        icon: Icons.open_in_full_outlined,
        onTap: () => context.push(path: CustomDialogDemoRt.path),
      ),
      _DemoEntry(
        title: 'System UI',
        subtitle: '状态栏 / 导航栏',
        icon: Icons.phone_android_outlined,
        onTap: () => context.push(path: SystemUiStylesDemoRt.path),
      ),
      _DemoEntry(
        title: 'Toast',
        subtitle: '居中 / 底部 / 顶部',
        icon: Icons.chat_bubble_outline,
        onTap: () => context.push(path: ToastDemoRt.path),
      ),
      _DemoEntry(
        title: 'RateLimitTap',
        subtitle: '节流 / 防抖',
        icon: Icons.touch_app_outlined,
        onTap: () => context.push(path: RateLimitTapDemoRt.path),
      ),
      _DemoEntry(
        title: '下拉刷新',
        subtitle: 'List / Grid / Custom',
        icon: Icons.refresh_outlined,
        onTap: () => context.push(path: RefreshLoadDemoRt.path),
      ),
      _DemoEntry(
        title: 'Vns / Sbx',
        subtitle: 'Obx / 多路监听',
        icon: Icons.notifications_active_outlined,
        onTap: () => context.push(path: VnsSbxDemoRt.path),
      ),
      _DemoEntry(
        title: '登录（半屏）',
        subtitle: '底部弹起 + 遮罩',
        icon: Icons.login_outlined,
        onTap: () => _pushLoginOverlay(context),
      ),
      _DemoEntry(
        title: '登录（全屏）',
        subtitle: 'slideBottom',
        icon: Icons.fullscreen_outlined,
        onTap: () => _pushLoginFullScreen(context),
      ),
      _DemoEntry(
        title: '路由·基础参数',
        subtitle: 'NovaPageShell',
        icon: Icons.alt_route_outlined,
        onTap: () => context.push(
          path: PrimitiveRt.path,
          query: <String, dynamic>{'title': 'hello', 'count': 1},
        ),
      ),
      _DemoEntry(
        title: '路由·基础·Stateful',
        subtitle: 'NovaStatefulPageShell',
        icon: Icons.alt_route_outlined,
        onTap: () => context.push(
          path: PrimStatefulRt.path,
          query: <String, dynamic>{'title': 'hello', 'count': 1},
        ),
      ),
      _DemoEntry(
        title: '路由·实体参数',
        subtitle: 'payload=json',
        icon: Icons.person_outline,
        onTap: () {
          const userEntity = DemoUserEntity(id: 'u1', name: 'Kit', age: 4);
          context.push(path: EntityRt.path, query: <String, dynamic>{'payload': userEntity.toJson()});
        },
      ),
      _DemoEntry(
        title: '路由·实体·Stateful',
        subtitle: 'payload=json',
        icon: Icons.person_outline,
        onTap: () {
          const userEntity = DemoUserEntity(id: 'u1', name: 'Kit', age: 4);
          context.push(
            path: EntStatefulRt.path,
            query: <String, dynamic>{'payload': userEntity.toJson()},
          );
        },
      ),
    ];
  }

  int _crossAxisCount(double width) {
    if (width >= 900) return 4;
    if (width >= 600) return 3;
    return 2;
  }

  @override
  Widget buildPhone(BuildContext context) {
    final entries = _entries(context);
    return InitConfigBox(
      child: DoubleTapExit(
        child: Scaffold(
          appBar: AppBar(title: const Text('Demo 列表')),
          body: LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = _crossAxisCount(constraints.maxWidth);
              return GridView.builder(
                padding: EdgeInsets.fromLTRB(16.dp, 16.dp, 16.dp, 24.dp),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 12.dp,
                  crossAxisSpacing: 12.dp,
                  childAspectRatio: crossAxisCount >= 3 ? 0.95 : 0.88,
                ),
                itemCount: entries.length,
                itemBuilder: (context, index) => _DemoGridTile(entry: entries[index]),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _DemoGridTile extends StatelessWidget {
  const _DemoGridTile({required this.entry});

  final _DemoEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerHighest,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: entry.onTap,
        child: Padding(
          padding: EdgeInsets.all(12.dp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(entry.icon, size: 28.dp, color: colorScheme.primary),
              SizedBox(height: 10.dp),
              Text(
                entry.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 4.dp),
              Expanded(
                child: Text(
                  entry.subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.25,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
