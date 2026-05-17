import 'package:flutter/widgets.dart';

import '../../telemetry/navigation/nav_telemetry_labels.dart';


/// 获取当前页面，在路由栈中的可读信息
/// StatelessWidget 使用
/// `context.routeTelemetryDescription(notPageRouteFallback: widget.runtimeType.toString())`
extension RouteTelemetryContextX on BuildContext {
  String? get routeTelemetryKey => ModalRoute.of(this)?.settings.name;

  String routeTelemetryDescription({String notPageRouteFallback = '-'}) {
    final route = ModalRoute.of(this);
    if (route is PageRoute<dynamic>) {
      return NavTelemetryLabels.formatPageRoute(route);
    }
    return routeTelemetryKey ?? notPageRouteFallback;
  }
}

/// StatefulWidget 使用
mixin RouteTelemetryStateMixin<T extends StatefulWidget> on State<T> {
  String? get routeTelemetryKey => context.routeTelemetryKey;

  String get routeTelemetryDescription =>
      context.routeTelemetryDescription(notPageRouteFallback: widget.runtimeType.toString());
}
