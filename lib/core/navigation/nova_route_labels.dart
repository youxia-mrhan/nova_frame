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
import 'nova_router.dart';

/// 新增路由时：都要在此表增加一行（键用 `XxxRoute.name`，值用 `*Rt.description`）。
/// 和 [nova_router.dart] 里面对应
/// 埋点page_label字段，会从这里取值
abstract final class NovaRouteLabelRegistry {
  NovaRouteLabelRegistry._();

  static final Map<String, String> _byRouteName = {
    DemoHomeRoute.name: DemoRouteRt.description,
    NetDemoListRoute.name: NetDemoListRt.description,
    NetRequestDemoRoute.name: NetRequestDemoRt.description,
    CachedNetRequestDemoRoute.name: CachedNetRequestDemoRt.description,
    TokenRefreshDemoRoute.name: TokenRefreshDemoRt.description,
    ApiEnvironmentSwitchDemoRoute.name: ApiEnvironmentSwitchDemoRt.description,
    ScreenUtilDemoRoute.name: ScreenUtilDemoRt.description,
    StorageDemoRoute.name: StorageDemoRt.description,
    PermissionDemoRoute.name: PermissionDemoRt.description,
    EventBusDemoRoute.name: EventBusDemoRt.description,
    LoadAssetJsonDemoRoute.name: LoadAssetJsonDemoRt.description,
    AssetsDemoRoute.name: AssetsDemoRt.description,
    ThemeDemoRoute.name: ThemeDemoRt.description,
    DeviceFormFactorDemoRoute.name: DeviceFormFactorDemoRt.description,
    AdaptiveStatefulDemoRoute.name: AdaptiveStatefulDemoRt.description,
    MixinsDemoRoute.name: MixinsDemoRt.description,
    KeyboardDemoRoute.name: MixinKeyboardDemoRt.description,
    AppLifecycleDemoRoute.name: MixinAppLifecycleDemoRt.description,
    RouteAwareDemoRoute.name: MixinRouteAwareDemoRt.description,
    RouteTelemetryContextDemoRoute.name: RouteTelemetryContextDemoRt.description,
    ChannelDemoRoute.name: ChannelDemoRt.description,
    CustomDialogDemoRoute.name: CustomDialogDemoRt.description,
    SystemUiStylesDemoRoute.name: SystemUiStylesDemoRt.description,
    SystemUiStylesPreviewDemoRoute.name: SystemUiStylesPreviewDemoRt.description,
    ToastDemoRoute.name: ToastDemoRt.description,
    RateLimitTapDemoRoute.name: RateLimitTapDemoRt.description,
    RefreshLoadDemoRoute.name: RefreshLoadDemoRt.description,
    RefreshLoadListDemoRoute.name: RefreshLoadListDemoRt.description,
    RefreshLoadGridDemoRoute.name: RefreshLoadGridDemoRt.description,
    RefreshLoadCustomScrollDemoRoute.name: RefreshLoadCustomScrollDemoRt.description,
    VnsSbxDemoRoute.name: VnsSbxDemoRt.description,
    VnsSbxBasicDemoRoute.name: VnsSbxBasicDemoRt.description,
    VnsSbxMultiDemoRoute.name: VnsSbxMultiDemoRt.description,
    PrimitiveParamsDemoRoute.name: PrimitiveRt.description,
    PrimitiveParamsAdaptiveStatefulDemoRoute.name: PrimStatefulRt.description,
    EntityParamsDemoRoute.name: EntityRt.description,
    EntityParamsAdaptiveStatefulDemoRoute.name: EntStatefulRt.description,
    LoginFullScreenShellRoute.name: LoginFullRt.description,
    LoginOverlayShellRoute.name: LoginOverlayRt.description,
    LoginDemoRoute.name: LoginDemoRt.description,
    SessionTrackerDemoRoute.name: SessTeleRt.description,
    SessionTrackerFlowDemoRoute.name: SessFlowRt.description,
    FakePushLinkDemoRoute.name: FakePushLinkRt.description,
    FakePushLinkPrimitiveParamsRoute.name: FakePushLinkPrimitiveRt.description,
    FakePushLinkEntityParamsRoute.name: FakePushLinkEntityRt.description,
    SimpleWebViewDemoRoute.name: WebViewRt.description,
  };

  static String? labelForRouteName(String? routeName) {
    if (routeName == null || routeName.isEmpty) return null;
    return _byRouteName[routeName];
  }
}
