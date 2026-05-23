import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../example/demo/adaptive_stateful_demo_page.dart';
import '../../example/demo/api_environment_switch_demo_page.dart';
import '../../example/demo/assets_demo_page.dart';
import '../../example/demo/channel_demo_page.dart';
import '../../example/demo/custom_dialog_demo_page.dart';
import '../../example/demo/device_form_factor_demo_page.dart';
import '../../example/demo/eventbus_demo_page.dart';
import '../../example/demo/load_asset_json_demo_page.dart';
import '../../example/demo/mixins_demo_page.dart';
import '../../example/demo/permission_demo_page.dart';
import '../../example/demo/rate_limit_tap_demo_page.dart';
import '../../example/demo/refresh_load_demo_page.dart';
import '../../example/demo/route_telemetry_context_demo_page.dart';
import '../../example/demo/screenutil_demo_page.dart';
import '../../example/demo/simple_webview_demo_page.dart';
import '../../example/demo/storage_demo_page.dart';
import '../../example/demo/system_ui_styles_demo_page.dart';
import '../../example/demo/theme_demo_page.dart';
import '../../example/demo/toast_demo_page.dart';
import '../../example/demo/vns_sbx_demo_page.dart';
import '../../example/demo_home_page.dart';
import '../../example/net_demo/page/cached_net_request_demo_page.dart';
import '../../example/net_demo/page/net_demo_list_page.dart';
import '../../example/net_demo/page/net_request_demo_page.dart';
import '../../example/net_demo/page/token_refresh_demo_page.dart';
import '../../example/push_link/fake_push_link_demo_page.dart';
import '../../example/push_link/fake_push_link_entity_params_page.dart';
import '../../example/push_link/fake_push_link_primitive_params_page.dart';
import '../../example/router_demo/entity_params_adaptive_stateful_demo_page.dart';
import '../../example/router_demo/entity_params_demo_page.dart';
import '../../example/router_demo/login/login_demo_page.dart';
import '../../example/router_demo/login/login_shell_route_pages.dart';
import '../../example/router_demo/primitive_params_adaptive_stateful_demo_page.dart';
import '../../example/router_demo/primitive_params_demo_page.dart';
import '../../example/telemetry_demo/page_session_telemetry_demo_page.dart';
import '../../example/telemetry_demo/page_session_telemetry_flow_demo_page.dart';
import 'link/nova_link_scheme.dart';
import 'nova_navigator_context.dart';

part 'nova_router.gr.dart';

/// 使用 auto_route 路由框架，必须重写深链解析逻辑：
/// 否则当URL 进入时，auto_route 默认会把它当成新的路径来处理，导致路由栈被重建，直接回到首页，再进入目标页面
Future<DeepLink> novaDeepLinkBuilder(PlatformDeepLink platform) async {
  final uri = platform.uri;

  /// 热启动
  if (!NovaLinkScheme.matchesAppLinkUri(uri)) {
    return platform;
  }

  /// 冷启动
  if (platform.initial) {
    /// 决定首屏
    return DeepLink.defaultPath;
  }

  /// DeepLink.none：auto_route 不会再解析uri
  /// 直接用link已经解析好的uri，进入指定页面
  return DeepLink.none;
}

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class NovaRouter extends RootStackRouter {
  NovaRouter({super.navigatorKey});

  /// 定义页面命名规则配置
  ///   @AutoRouterConfig(replaceInRouteName: 'Page,Route')
  ///
  /// 然后创建页面命名：都要：XXX+Page，拼接`Page`后缀，比如 DemoHomePage
  ///
  /// 执行 dart run build_runner build 命令后
  /// 才会生成对应的路由类，`DemoHomeRoute`，就是将 Page替换为Route

  @override
  List<AutoRoute> get routes => [
    AutoRoute(path: DemoRouteRt.path, page: DemoHomeRoute.page, initial: true),
    AutoRoute(path: NetDemoListRt.path, page: NetDemoListRoute.page),
    AutoRoute(path: NetRequestDemoRt.path, page: NetRequestDemoRoute.page),
    AutoRoute(path: CachedNetRequestDemoRt.path, page: CachedNetRequestDemoRoute.page),
    AutoRoute(path: TokenRefreshDemoRt.path, page: TokenRefreshDemoRoute.page),
    AutoRoute(path: ApiEnvironmentSwitchDemoRt.path, page: ApiEnvironmentSwitchDemoRoute.page),
    AutoRoute(path: ScreenUtilDemoRt.path, page: ScreenUtilDemoRoute.page),
    AutoRoute(path: StorageDemoRt.path, page: StorageDemoRoute.page),
    AutoRoute(path: PermissionDemoRt.path, page: PermissionDemoRoute.page),
    AutoRoute(path: EventBusDemoRt.path, page: EventBusDemoRoute.page),
    AutoRoute(path: LoadAssetJsonDemoRt.path, page: LoadAssetJsonDemoRoute.page),
    AutoRoute(path: AssetsDemoRt.path, page: AssetsDemoRoute.page),
    AutoRoute(path: ThemeDemoRt.path, page: ThemeDemoRoute.page),
    AutoRoute(path: DeviceFormFactorDemoRt.path, page: DeviceFormFactorDemoRoute.page),
    AutoRoute(path: AdaptiveStatefulDemoRt.path, page: AdaptiveStatefulDemoRoute.page),
    AutoRoute(path: MixinsDemoRt.path, page: MixinsDemoRoute.page),
    AutoRoute(path: MixinKeyboardDemoRt.path, page: KeyboardDemoRoute.page),
    AutoRoute(path: MixinAppLifecycleDemoRt.path, page: AppLifecycleDemoRoute.page),
    AutoRoute(path: MixinRouteAwareDemoRt.path, page: RouteAwareDemoRoute.page),
    AutoRoute(path: RouteTelemetryContextDemoRt.path, page: RouteTelemetryContextDemoRoute.page),
    AutoRoute(path: ChannelDemoRt.path, page: ChannelDemoRoute.page),
    AutoRoute(path: CustomDialogDemoRt.path, page: CustomDialogDemoRoute.page),
    AutoRoute(path: SystemUiStylesDemoRt.path, page: SystemUiStylesDemoRoute.page),
    AutoRoute(path: SystemUiStylesPreviewDemoRt.path, page: SystemUiStylesPreviewDemoRoute.page),
    AutoRoute(path: ToastDemoRt.path, page: ToastDemoRoute.page),
    AutoRoute(path: RateLimitTapDemoRt.path, page: RateLimitTapDemoRoute.page),
    AutoRoute(path: RefreshLoadDemoRt.path, page: RefreshLoadDemoRoute.page),
    AutoRoute(path: RefreshLoadListDemoRt.path, page: RefreshLoadListDemoRoute.page),
    AutoRoute(path: RefreshLoadGridDemoRt.path, page: RefreshLoadGridDemoRoute.page),
    AutoRoute(path: RefreshLoadCustomScrollDemoRt.path, page: RefreshLoadCustomScrollDemoRoute.page),
    AutoRoute(path: VnsSbxDemoRt.path, page: VnsSbxDemoRoute.page),
    AutoRoute(path: VnsSbxBasicDemoRt.path, page: VnsSbxBasicDemoRoute.page),
    AutoRoute(path: VnsSbxMultiDemoRt.path, page: VnsSbxMultiDemoRoute.page),
    AutoRoute(path: PrimitiveRt.path, page: PrimitiveParamsDemoRoute.page),
    AutoRoute(path: PrimStatefulRt.path, page: PrimitiveParamsAdaptiveStatefulDemoRoute.page),
    AutoRoute(path: EntityRt.path, page: EntityParamsDemoRoute.page),
    AutoRoute(path: EntStatefulRt.path, page: EntityParamsAdaptiveStatefulDemoRoute.page),
    CustomRoute(
      path: LoginFullRt.path,
      page: LoginFullScreenShellRoute.page,
      transitionsBuilder: TransitionsBuilders.slideBottom,
      duration: const Duration(milliseconds: 200),
      reverseDuration: const Duration(milliseconds: 200),
      opaque: true,
      barrierDismissible: false,
    ),
    CustomRoute(
      path: LoginOverlayRt.path,
      page: LoginOverlayShellRoute.page,
      transitionsBuilder: TransitionsBuilders.slideBottom,
      duration: const Duration(milliseconds: 200),
      reverseDuration: const Duration(milliseconds: 200),
      opaque: false,
      barrierColor: const Color(0x66000000),
      barrierDismissible: false,
    ),
    AutoRoute(path: LoginDemoRt.path, page: LoginDemoRoute.page),
    AutoRoute(path: SessTeleRt.path, page: SessionTrackerDemoRoute.page),
    AutoRoute(path: SessFlowRt.path, page: SessionTrackerFlowDemoRoute.page),
    AutoRoute(path: FakePushLinkRt.path, page: FakePushLinkDemoRoute.page),
    AutoRoute(path: FakePushLinkPrimitiveRt.path, page: FakePushLinkPrimitiveParamsRoute.page),
    AutoRoute(path: FakePushLinkEntityRt.path, page: FakePushLinkEntityParamsRoute.page),
    AutoRoute(path: WebViewRt.path, page: SimpleWebViewDemoRoute.page),
  ];
}

final NovaRouter novaRouter = NovaRouter(navigatorKey: NovaNavigatorContext.navigatorKey);
