// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'nova_router.dart';

/// generated route for
/// [AdaptiveStatefulDemoPage]
class AdaptiveStatefulDemoRoute extends PageRouteInfo<void> {
  const AdaptiveStatefulDemoRoute({List<PageRouteInfo>? children})
    : super(AdaptiveStatefulDemoRoute.name, initialChildren: children);

  static const String name = 'AdaptiveStatefulDemoRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AdaptiveStatefulDemoPage();
    },
  );
}

/// generated route for
/// [ApiEnvironmentSwitchDemoPage]
class ApiEnvironmentSwitchDemoRoute extends PageRouteInfo<void> {
  const ApiEnvironmentSwitchDemoRoute({List<PageRouteInfo>? children})
    : super(ApiEnvironmentSwitchDemoRoute.name, initialChildren: children);

  static const String name = 'ApiEnvironmentSwitchDemoRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ApiEnvironmentSwitchDemoPage();
    },
  );
}

/// generated route for
/// [AppLifecycleDemoPage]
class AppLifecycleDemoRoute extends PageRouteInfo<void> {
  const AppLifecycleDemoRoute({List<PageRouteInfo>? children})
    : super(AppLifecycleDemoRoute.name, initialChildren: children);

  static const String name = 'AppLifecycleDemoRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AppLifecycleDemoPage();
    },
  );
}

/// generated route for
/// [AssetsDemoPage]
class AssetsDemoRoute extends PageRouteInfo<void> {
  const AssetsDemoRoute({List<PageRouteInfo>? children})
    : super(AssetsDemoRoute.name, initialChildren: children);

  static const String name = 'AssetsDemoRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AssetsDemoPage();
    },
  );
}

/// generated route for
/// [CachedNetRequestDemoPage]
class CachedNetRequestDemoRoute extends PageRouteInfo<void> {
  const CachedNetRequestDemoRoute({List<PageRouteInfo>? children})
    : super(CachedNetRequestDemoRoute.name, initialChildren: children);

  static const String name = 'CachedNetRequestDemoRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CachedNetRequestDemoPage();
    },
  );
}

/// generated route for
/// [ChannelDemoPage]
class ChannelDemoRoute extends PageRouteInfo<void> {
  const ChannelDemoRoute({List<PageRouteInfo>? children})
    : super(ChannelDemoRoute.name, initialChildren: children);

  static const String name = 'ChannelDemoRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ChannelDemoPage();
    },
  );
}

/// generated route for
/// [CustomDialogDemoPage]
class CustomDialogDemoRoute extends PageRouteInfo<void> {
  const CustomDialogDemoRoute({List<PageRouteInfo>? children})
    : super(CustomDialogDemoRoute.name, initialChildren: children);

  static const String name = 'CustomDialogDemoRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CustomDialogDemoPage();
    },
  );
}

/// generated route for
/// [DemoHomePage]
class DemoHomeRoute extends PageRouteInfo<void> {
  const DemoHomeRoute({List<PageRouteInfo>? children})
    : super(DemoHomeRoute.name, initialChildren: children);

  static const String name = 'DemoHomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DemoHomePage();
    },
  );
}

/// generated route for
/// [DeviceFormFactorDemoPage]
class DeviceFormFactorDemoRoute extends PageRouteInfo<void> {
  const DeviceFormFactorDemoRoute({List<PageRouteInfo>? children})
    : super(DeviceFormFactorDemoRoute.name, initialChildren: children);

  static const String name = 'DeviceFormFactorDemoRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DeviceFormFactorDemoPage();
    },
  );
}

/// generated route for
/// [EntityParamsAdaptiveStatefulDemoPage]
class EntityParamsAdaptiveStatefulDemoRoute
    extends PageRouteInfo<EntityParamsAdaptiveStatefulDemoRouteArgs> {
  EntityParamsAdaptiveStatefulDemoRoute({
    Key? key,
    String? payload,
    List<PageRouteInfo>? children,
  }) : super(
         EntityParamsAdaptiveStatefulDemoRoute.name,
         args: EntityParamsAdaptiveStatefulDemoRouteArgs(
           key: key,
           payload: payload,
         ),
         rawQueryParams: {'payload': payload},
         initialChildren: children,
       );

  static const String name = 'EntityParamsAdaptiveStatefulDemoRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final queryParams = data.queryParams;
      final args = data.argsAs<EntityParamsAdaptiveStatefulDemoRouteArgs>(
        orElse: () => EntityParamsAdaptiveStatefulDemoRouteArgs(
          payload: queryParams.optString('payload'),
        ),
      );
      return EntityParamsAdaptiveStatefulDemoPage(
        key: args.key,
        payload: args.payload,
      );
    },
  );
}

class EntityParamsAdaptiveStatefulDemoRouteArgs {
  const EntityParamsAdaptiveStatefulDemoRouteArgs({this.key, this.payload});

  final Key? key;

  final String? payload;

  @override
  String toString() {
    return 'EntityParamsAdaptiveStatefulDemoRouteArgs{key: $key, payload: $payload}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! EntityParamsAdaptiveStatefulDemoRouteArgs) return false;
    return key == other.key && payload == other.payload;
  }

  @override
  int get hashCode => key.hashCode ^ payload.hashCode;
}

/// generated route for
/// [EntityParamsDemoPage]
class EntityParamsDemoRoute extends PageRouteInfo<EntityParamsDemoRouteArgs> {
  EntityParamsDemoRoute({
    Key? key,
    String? payload,
    List<PageRouteInfo>? children,
  }) : super(
         EntityParamsDemoRoute.name,
         args: EntityParamsDemoRouteArgs(key: key, payload: payload),
         rawQueryParams: {'payload': payload},
         initialChildren: children,
       );

  static const String name = 'EntityParamsDemoRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final queryParams = data.queryParams;
      final args = data.argsAs<EntityParamsDemoRouteArgs>(
        orElse: () => EntityParamsDemoRouteArgs(
          payload: queryParams.optString('payload'),
        ),
      );
      return EntityParamsDemoPage(key: args.key, payload: args.payload);
    },
  );
}

class EntityParamsDemoRouteArgs {
  const EntityParamsDemoRouteArgs({this.key, this.payload});

  final Key? key;

  final String? payload;

  @override
  String toString() {
    return 'EntityParamsDemoRouteArgs{key: $key, payload: $payload}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! EntityParamsDemoRouteArgs) return false;
    return key == other.key && payload == other.payload;
  }

  @override
  int get hashCode => key.hashCode ^ payload.hashCode;
}

/// generated route for
/// [EventBusDemoPage]
class EventBusDemoRoute extends PageRouteInfo<void> {
  const EventBusDemoRoute({List<PageRouteInfo>? children})
    : super(EventBusDemoRoute.name, initialChildren: children);

  static const String name = 'EventBusDemoRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const EventBusDemoPage();
    },
  );
}

/// generated route for
/// [FakePushLinkDemoPage]
class FakePushLinkDemoRoute extends PageRouteInfo<void> {
  const FakePushLinkDemoRoute({List<PageRouteInfo>? children})
    : super(FakePushLinkDemoRoute.name, initialChildren: children);

  static const String name = 'FakePushLinkDemoRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FakePushLinkDemoPage();
    },
  );
}

/// generated route for
/// [FakePushLinkEntityParamsPage]
class FakePushLinkEntityParamsRoute
    extends PageRouteInfo<FakePushLinkEntityParamsRouteArgs> {
  FakePushLinkEntityParamsRoute({
    Key? key,
    String? payload,
    List<PageRouteInfo>? children,
  }) : super(
         FakePushLinkEntityParamsRoute.name,
         args: FakePushLinkEntityParamsRouteArgs(key: key, payload: payload),
         rawQueryParams: {'payload': payload},
         initialChildren: children,
       );

  static const String name = 'FakePushLinkEntityParamsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final queryParams = data.queryParams;
      final args = data.argsAs<FakePushLinkEntityParamsRouteArgs>(
        orElse: () => FakePushLinkEntityParamsRouteArgs(
          payload: queryParams.optString('payload'),
        ),
      );
      return FakePushLinkEntityParamsPage(key: args.key, payload: args.payload);
    },
  );
}

class FakePushLinkEntityParamsRouteArgs {
  const FakePushLinkEntityParamsRouteArgs({this.key, this.payload});

  final Key? key;

  final String? payload;

  @override
  String toString() {
    return 'FakePushLinkEntityParamsRouteArgs{key: $key, payload: $payload}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! FakePushLinkEntityParamsRouteArgs) return false;
    return key == other.key && payload == other.payload;
  }

  @override
  int get hashCode => key.hashCode ^ payload.hashCode;
}

/// generated route for
/// [FakePushLinkPrimitiveParamsPage]
class FakePushLinkPrimitiveParamsRoute
    extends PageRouteInfo<FakePushLinkPrimitiveParamsRouteArgs> {
  FakePushLinkPrimitiveParamsRoute({
    Key? key,
    String? title,
    int? count,
    List<PageRouteInfo>? children,
  }) : super(
         FakePushLinkPrimitiveParamsRoute.name,
         args: FakePushLinkPrimitiveParamsRouteArgs(
           key: key,
           title: title,
           count: count,
         ),
         rawQueryParams: {'title': title, 'count': count},
         initialChildren: children,
       );

  static const String name = 'FakePushLinkPrimitiveParamsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final queryParams = data.queryParams;
      final args = data.argsAs<FakePushLinkPrimitiveParamsRouteArgs>(
        orElse: () => FakePushLinkPrimitiveParamsRouteArgs(
          title: queryParams.optString('title'),
          count: queryParams.optInt('count'),
        ),
      );
      return FakePushLinkPrimitiveParamsPage(
        key: args.key,
        title: args.title,
        count: args.count,
      );
    },
  );
}

class FakePushLinkPrimitiveParamsRouteArgs {
  const FakePushLinkPrimitiveParamsRouteArgs({
    this.key,
    this.title,
    this.count,
  });

  final Key? key;

  final String? title;

  final int? count;

  @override
  String toString() {
    return 'FakePushLinkPrimitiveParamsRouteArgs{key: $key, title: $title, count: $count}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! FakePushLinkPrimitiveParamsRouteArgs) return false;
    return key == other.key && title == other.title && count == other.count;
  }

  @override
  int get hashCode => key.hashCode ^ title.hashCode ^ count.hashCode;
}

/// generated route for
/// [KeyboardDemoPage]
class KeyboardDemoRoute extends PageRouteInfo<void> {
  const KeyboardDemoRoute({List<PageRouteInfo>? children})
    : super(KeyboardDemoRoute.name, initialChildren: children);

  static const String name = 'KeyboardDemoRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const KeyboardDemoPage();
    },
  );
}

/// generated route for
/// [LoadAssetJsonDemoPage]
class LoadAssetJsonDemoRoute extends PageRouteInfo<void> {
  const LoadAssetJsonDemoRoute({List<PageRouteInfo>? children})
    : super(LoadAssetJsonDemoRoute.name, initialChildren: children);

  static const String name = 'LoadAssetJsonDemoRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LoadAssetJsonDemoPage();
    },
  );
}

/// generated route for
/// [LoginDemoPage]
class LoginDemoRoute extends PageRouteInfo<LoginDemoRouteArgs> {
  LoginDemoRoute({Key? key, String? styleKey, List<PageRouteInfo>? children})
    : super(
        LoginDemoRoute.name,
        args: LoginDemoRouteArgs(key: key, styleKey: styleKey),
        rawQueryParams: {'style': styleKey},
        initialChildren: children,
      );

  static const String name = 'LoginDemoRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final queryParams = data.queryParams;
      final args = data.argsAs<LoginDemoRouteArgs>(
        orElse: () =>
            LoginDemoRouteArgs(styleKey: queryParams.optString('style')),
      );
      return LoginDemoPage(key: args.key, styleKey: args.styleKey);
    },
  );
}

class LoginDemoRouteArgs {
  const LoginDemoRouteArgs({this.key, this.styleKey});

  final Key? key;

  final String? styleKey;

  @override
  String toString() {
    return 'LoginDemoRouteArgs{key: $key, styleKey: $styleKey}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! LoginDemoRouteArgs) return false;
    return key == other.key && styleKey == other.styleKey;
  }

  @override
  int get hashCode => key.hashCode ^ styleKey.hashCode;
}

/// generated route for
/// [LoginFullScreenShellPage]
class LoginFullScreenShellRoute extends PageRouteInfo<void> {
  const LoginFullScreenShellRoute({List<PageRouteInfo>? children})
    : super(LoginFullScreenShellRoute.name, initialChildren: children);

  static const String name = 'LoginFullScreenShellRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LoginFullScreenShellPage();
    },
  );
}

/// generated route for
/// [LoginOverlayShellPage]
class LoginOverlayShellRoute extends PageRouteInfo<void> {
  const LoginOverlayShellRoute({List<PageRouteInfo>? children})
    : super(LoginOverlayShellRoute.name, initialChildren: children);

  static const String name = 'LoginOverlayShellRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LoginOverlayShellPage();
    },
  );
}

/// generated route for
/// [MixinsDemoPage]
class MixinsDemoRoute extends PageRouteInfo<void> {
  const MixinsDemoRoute({List<PageRouteInfo>? children})
    : super(MixinsDemoRoute.name, initialChildren: children);

  static const String name = 'MixinsDemoRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MixinsDemoPage();
    },
  );
}

/// generated route for
/// [NetDemoListPage]
class NetDemoListRoute extends PageRouteInfo<void> {
  const NetDemoListRoute({List<PageRouteInfo>? children})
    : super(NetDemoListRoute.name, initialChildren: children);

  static const String name = 'NetDemoListRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const NetDemoListPage();
    },
  );
}

/// generated route for
/// [NetRequestDemoPage]
class NetRequestDemoRoute extends PageRouteInfo<void> {
  const NetRequestDemoRoute({List<PageRouteInfo>? children})
    : super(NetRequestDemoRoute.name, initialChildren: children);

  static const String name = 'NetRequestDemoRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const NetRequestDemoPage();
    },
  );
}

/// generated route for
/// [PermissionDemoPage]
class PermissionDemoRoute extends PageRouteInfo<void> {
  const PermissionDemoRoute({List<PageRouteInfo>? children})
    : super(PermissionDemoRoute.name, initialChildren: children);

  static const String name = 'PermissionDemoRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PermissionDemoPage();
    },
  );
}

/// generated route for
/// [PrimitiveParamsAdaptiveStatefulDemoPage]
class PrimitiveParamsAdaptiveStatefulDemoRoute
    extends PageRouteInfo<PrimitiveParamsAdaptiveStatefulDemoRouteArgs> {
  PrimitiveParamsAdaptiveStatefulDemoRoute({
    Key? key,
    String? title,
    int? count,
    List<PageRouteInfo>? children,
  }) : super(
         PrimitiveParamsAdaptiveStatefulDemoRoute.name,
         args: PrimitiveParamsAdaptiveStatefulDemoRouteArgs(
           key: key,
           title: title,
           count: count,
         ),
         rawQueryParams: {'title': title, 'count': count},
         initialChildren: children,
       );

  static const String name = 'PrimitiveParamsAdaptiveStatefulDemoRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final queryParams = data.queryParams;
      final args = data.argsAs<PrimitiveParamsAdaptiveStatefulDemoRouteArgs>(
        orElse: () => PrimitiveParamsAdaptiveStatefulDemoRouteArgs(
          title: queryParams.optString('title'),
          count: queryParams.optInt('count'),
        ),
      );
      return PrimitiveParamsAdaptiveStatefulDemoPage(
        key: args.key,
        title: args.title,
        count: args.count,
      );
    },
  );
}

class PrimitiveParamsAdaptiveStatefulDemoRouteArgs {
  const PrimitiveParamsAdaptiveStatefulDemoRouteArgs({
    this.key,
    this.title,
    this.count,
  });

  final Key? key;

  final String? title;

  final int? count;

  @override
  String toString() {
    return 'PrimitiveParamsAdaptiveStatefulDemoRouteArgs{key: $key, title: $title, count: $count}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PrimitiveParamsAdaptiveStatefulDemoRouteArgs) return false;
    return key == other.key && title == other.title && count == other.count;
  }

  @override
  int get hashCode => key.hashCode ^ title.hashCode ^ count.hashCode;
}

/// generated route for
/// [PrimitiveParamsDemoPage]
class PrimitiveParamsDemoRoute
    extends PageRouteInfo<PrimitiveParamsDemoRouteArgs> {
  PrimitiveParamsDemoRoute({
    Key? key,
    String? title,
    int? count,
    List<PageRouteInfo>? children,
  }) : super(
         PrimitiveParamsDemoRoute.name,
         args: PrimitiveParamsDemoRouteArgs(
           key: key,
           title: title,
           count: count,
         ),
         rawQueryParams: {'title': title, 'count': count},
         initialChildren: children,
       );

  static const String name = 'PrimitiveParamsDemoRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final queryParams = data.queryParams;
      final args = data.argsAs<PrimitiveParamsDemoRouteArgs>(
        orElse: () => PrimitiveParamsDemoRouteArgs(
          title: queryParams.optString('title'),
          count: queryParams.optInt('count'),
        ),
      );
      return PrimitiveParamsDemoPage(
        key: args.key,
        title: args.title,
        count: args.count,
      );
    },
  );
}

class PrimitiveParamsDemoRouteArgs {
  const PrimitiveParamsDemoRouteArgs({this.key, this.title, this.count});

  final Key? key;

  final String? title;

  final int? count;

  @override
  String toString() {
    return 'PrimitiveParamsDemoRouteArgs{key: $key, title: $title, count: $count}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PrimitiveParamsDemoRouteArgs) return false;
    return key == other.key && title == other.title && count == other.count;
  }

  @override
  int get hashCode => key.hashCode ^ title.hashCode ^ count.hashCode;
}

/// generated route for
/// [RateLimitTapDemoPage]
class RateLimitTapDemoRoute extends PageRouteInfo<void> {
  const RateLimitTapDemoRoute({List<PageRouteInfo>? children})
    : super(RateLimitTapDemoRoute.name, initialChildren: children);

  static const String name = 'RateLimitTapDemoRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const RateLimitTapDemoPage();
    },
  );
}

/// generated route for
/// [RefreshLoadCustomScrollDemoPage]
class RefreshLoadCustomScrollDemoRoute extends PageRouteInfo<void> {
  const RefreshLoadCustomScrollDemoRoute({List<PageRouteInfo>? children})
    : super(RefreshLoadCustomScrollDemoRoute.name, initialChildren: children);

  static const String name = 'RefreshLoadCustomScrollDemoRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const RefreshLoadCustomScrollDemoPage();
    },
  );
}

/// generated route for
/// [RefreshLoadDemoPage]
class RefreshLoadDemoRoute extends PageRouteInfo<void> {
  const RefreshLoadDemoRoute({List<PageRouteInfo>? children})
    : super(RefreshLoadDemoRoute.name, initialChildren: children);

  static const String name = 'RefreshLoadDemoRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const RefreshLoadDemoPage();
    },
  );
}

/// generated route for
/// [RefreshLoadGridDemoPage]
class RefreshLoadGridDemoRoute extends PageRouteInfo<void> {
  const RefreshLoadGridDemoRoute({List<PageRouteInfo>? children})
    : super(RefreshLoadGridDemoRoute.name, initialChildren: children);

  static const String name = 'RefreshLoadGridDemoRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const RefreshLoadGridDemoPage();
    },
  );
}

/// generated route for
/// [RefreshLoadListDemoPage]
class RefreshLoadListDemoRoute extends PageRouteInfo<void> {
  const RefreshLoadListDemoRoute({List<PageRouteInfo>? children})
    : super(RefreshLoadListDemoRoute.name, initialChildren: children);

  static const String name = 'RefreshLoadListDemoRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const RefreshLoadListDemoPage();
    },
  );
}

/// generated route for
/// [RouteAwareDemoPage]
class RouteAwareDemoRoute extends PageRouteInfo<void> {
  const RouteAwareDemoRoute({List<PageRouteInfo>? children})
    : super(RouteAwareDemoRoute.name, initialChildren: children);

  static const String name = 'RouteAwareDemoRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const RouteAwareDemoPage();
    },
  );
}

/// generated route for
/// [RouteTelemetryContextDemoPage]
class RouteTelemetryContextDemoRoute extends PageRouteInfo<void> {
  const RouteTelemetryContextDemoRoute({List<PageRouteInfo>? children})
    : super(RouteTelemetryContextDemoRoute.name, initialChildren: children);

  static const String name = 'RouteTelemetryContextDemoRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const RouteTelemetryContextDemoPage();
    },
  );
}

/// generated route for
/// [ScreenUtilDemoPage]
class ScreenUtilDemoRoute extends PageRouteInfo<void> {
  const ScreenUtilDemoRoute({List<PageRouteInfo>? children})
    : super(ScreenUtilDemoRoute.name, initialChildren: children);

  static const String name = 'ScreenUtilDemoRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ScreenUtilDemoPage();
    },
  );
}

/// generated route for
/// [SessionTrackerDemoPage]
class SessionTrackerDemoRoute extends PageRouteInfo<void> {
  const SessionTrackerDemoRoute({List<PageRouteInfo>? children})
    : super(SessionTrackerDemoRoute.name, initialChildren: children);

  static const String name = 'SessionTrackerDemoRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SessionTrackerDemoPage();
    },
  );
}

/// generated route for
/// [SessionTrackerFlowDemoPage]
class SessionTrackerFlowDemoRoute extends PageRouteInfo<void> {
  const SessionTrackerFlowDemoRoute({List<PageRouteInfo>? children})
    : super(SessionTrackerFlowDemoRoute.name, initialChildren: children);

  static const String name = 'SessionTrackerFlowDemoRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SessionTrackerFlowDemoPage();
    },
  );
}

/// generated route for
/// [SimpleWebViewDemoPage]
class SimpleWebViewDemoRoute extends PageRouteInfo<SimpleWebViewDemoRouteArgs> {
  SimpleWebViewDemoRoute({
    Key? key,
    String? url,
    String? label,
    List<PageRouteInfo>? children,
  }) : super(
         SimpleWebViewDemoRoute.name,
         args: SimpleWebViewDemoRouteArgs(key: key, url: url, label: label),
         rawQueryParams: {'url': url, 'label': label},
         initialChildren: children,
       );

  static const String name = 'SimpleWebViewDemoRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final queryParams = data.queryParams;
      final args = data.argsAs<SimpleWebViewDemoRouteArgs>(
        orElse: () => SimpleWebViewDemoRouteArgs(
          url: queryParams.optString('url'),
          label: queryParams.optString('label'),
        ),
      );
      return SimpleWebViewDemoPage(
        key: args.key,
        url: args.url,
        label: args.label,
      );
    },
  );
}

class SimpleWebViewDemoRouteArgs {
  const SimpleWebViewDemoRouteArgs({this.key, this.url, this.label});

  final Key? key;

  final String? url;

  final String? label;

  @override
  String toString() {
    return 'SimpleWebViewDemoRouteArgs{key: $key, url: $url, label: $label}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SimpleWebViewDemoRouteArgs) return false;
    return key == other.key && url == other.url && label == other.label;
  }

  @override
  int get hashCode => key.hashCode ^ url.hashCode ^ label.hashCode;
}

/// generated route for
/// [StorageDemoPage]
class StorageDemoRoute extends PageRouteInfo<void> {
  const StorageDemoRoute({List<PageRouteInfo>? children})
    : super(StorageDemoRoute.name, initialChildren: children);

  static const String name = 'StorageDemoRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const StorageDemoPage();
    },
  );
}

/// generated route for
/// [SystemUiStylesDemoPage]
class SystemUiStylesDemoRoute extends PageRouteInfo<void> {
  const SystemUiStylesDemoRoute({List<PageRouteInfo>? children})
    : super(SystemUiStylesDemoRoute.name, initialChildren: children);

  static const String name = 'SystemUiStylesDemoRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SystemUiStylesDemoPage();
    },
  );
}

/// generated route for
/// [SystemUiStylesPreviewDemoPage]
class SystemUiStylesPreviewDemoRoute
    extends PageRouteInfo<SystemUiStylesPreviewDemoRouteArgs> {
  SystemUiStylesPreviewDemoRoute({
    Key? key,
    String? title,
    String? sb,
    String? nb,
    int? customStatusBarColorValue,
    String? customStatusBarIconBrightnessKey,
    int? customNavigationBarColorValue,
    String? customNavigationBarIconBrightnessKey,
    List<PageRouteInfo>? children,
  }) : super(
         SystemUiStylesPreviewDemoRoute.name,
         args: SystemUiStylesPreviewDemoRouteArgs(
           key: key,
           title: title,
           sb: sb,
           nb: nb,
           customStatusBarColorValue: customStatusBarColorValue,
           customStatusBarIconBrightnessKey: customStatusBarIconBrightnessKey,
           customNavigationBarColorValue: customNavigationBarColorValue,
           customNavigationBarIconBrightnessKey:
               customNavigationBarIconBrightnessKey,
         ),
         rawQueryParams: {
           'title': title,
           'sb': sb,
           'nb': nb,
           'csc': customStatusBarColorValue,
           'csib': customStatusBarIconBrightnessKey,
           'cnc': customNavigationBarColorValue,
           'cnib': customNavigationBarIconBrightnessKey,
         },
         initialChildren: children,
       );

  static const String name = 'SystemUiStylesPreviewDemoRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final queryParams = data.queryParams;
      final args = data.argsAs<SystemUiStylesPreviewDemoRouteArgs>(
        orElse: () => SystemUiStylesPreviewDemoRouteArgs(
          title: queryParams.optString('title'),
          sb: queryParams.optString('sb'),
          nb: queryParams.optString('nb'),
          customStatusBarColorValue: queryParams.optInt('csc'),
          customStatusBarIconBrightnessKey: queryParams.optString('csib'),
          customNavigationBarColorValue: queryParams.optInt('cnc'),
          customNavigationBarIconBrightnessKey: queryParams.optString('cnib'),
        ),
      );
      return SystemUiStylesPreviewDemoPage(
        key: args.key,
        title: args.title,
        sb: args.sb,
        nb: args.nb,
        customStatusBarColorValue: args.customStatusBarColorValue,
        customStatusBarIconBrightnessKey: args.customStatusBarIconBrightnessKey,
        customNavigationBarColorValue: args.customNavigationBarColorValue,
        customNavigationBarIconBrightnessKey:
            args.customNavigationBarIconBrightnessKey,
      );
    },
  );
}

class SystemUiStylesPreviewDemoRouteArgs {
  const SystemUiStylesPreviewDemoRouteArgs({
    this.key,
    this.title,
    this.sb,
    this.nb,
    this.customStatusBarColorValue,
    this.customStatusBarIconBrightnessKey,
    this.customNavigationBarColorValue,
    this.customNavigationBarIconBrightnessKey,
  });

  final Key? key;

  final String? title;

  final String? sb;

  final String? nb;

  final int? customStatusBarColorValue;

  final String? customStatusBarIconBrightnessKey;

  final int? customNavigationBarColorValue;

  final String? customNavigationBarIconBrightnessKey;

  @override
  String toString() {
    return 'SystemUiStylesPreviewDemoRouteArgs{key: $key, title: $title, sb: $sb, nb: $nb, customStatusBarColorValue: $customStatusBarColorValue, customStatusBarIconBrightnessKey: $customStatusBarIconBrightnessKey, customNavigationBarColorValue: $customNavigationBarColorValue, customNavigationBarIconBrightnessKey: $customNavigationBarIconBrightnessKey}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SystemUiStylesPreviewDemoRouteArgs) return false;
    return key == other.key &&
        title == other.title &&
        sb == other.sb &&
        nb == other.nb &&
        customStatusBarColorValue == other.customStatusBarColorValue &&
        customStatusBarIconBrightnessKey ==
            other.customStatusBarIconBrightnessKey &&
        customNavigationBarColorValue == other.customNavigationBarColorValue &&
        customNavigationBarIconBrightnessKey ==
            other.customNavigationBarIconBrightnessKey;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      title.hashCode ^
      sb.hashCode ^
      nb.hashCode ^
      customStatusBarColorValue.hashCode ^
      customStatusBarIconBrightnessKey.hashCode ^
      customNavigationBarColorValue.hashCode ^
      customNavigationBarIconBrightnessKey.hashCode;
}

/// generated route for
/// [ThemeDemoPage]
class ThemeDemoRoute extends PageRouteInfo<void> {
  const ThemeDemoRoute({List<PageRouteInfo>? children})
    : super(ThemeDemoRoute.name, initialChildren: children);

  static const String name = 'ThemeDemoRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ThemeDemoPage();
    },
  );
}

/// generated route for
/// [ToastDemoPage]
class ToastDemoRoute extends PageRouteInfo<void> {
  const ToastDemoRoute({List<PageRouteInfo>? children})
    : super(ToastDemoRoute.name, initialChildren: children);

  static const String name = 'ToastDemoRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ToastDemoPage();
    },
  );
}

/// generated route for
/// [TokenRefreshDemoPage]
class TokenRefreshDemoRoute extends PageRouteInfo<void> {
  const TokenRefreshDemoRoute({List<PageRouteInfo>? children})
    : super(TokenRefreshDemoRoute.name, initialChildren: children);

  static const String name = 'TokenRefreshDemoRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const TokenRefreshDemoPage();
    },
  );
}

/// generated route for
/// [VnsSbxBasicDemoPage]
class VnsSbxBasicDemoRoute extends PageRouteInfo<void> {
  const VnsSbxBasicDemoRoute({List<PageRouteInfo>? children})
    : super(VnsSbxBasicDemoRoute.name, initialChildren: children);

  static const String name = 'VnsSbxBasicDemoRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const VnsSbxBasicDemoPage();
    },
  );
}

/// generated route for
/// [VnsSbxDemoPage]
class VnsSbxDemoRoute extends PageRouteInfo<void> {
  const VnsSbxDemoRoute({List<PageRouteInfo>? children})
    : super(VnsSbxDemoRoute.name, initialChildren: children);

  static const String name = 'VnsSbxDemoRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const VnsSbxDemoPage();
    },
  );
}

/// generated route for
/// [VnsSbxMultiDemoPage]
class VnsSbxMultiDemoRoute extends PageRouteInfo<void> {
  const VnsSbxMultiDemoRoute({List<PageRouteInfo>? children})
    : super(VnsSbxMultiDemoRoute.name, initialChildren: children);

  static const String name = 'VnsSbxMultiDemoRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const VnsSbxMultiDemoPage();
    },
  );
}
