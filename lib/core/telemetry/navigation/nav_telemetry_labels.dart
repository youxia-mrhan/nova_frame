import 'package:flutter/widgets.dart';

import 'package:nova_frame/core/navigation/nova_route_labels.dart';

final class RouteTelemetryBinding {
  const RouteTelemetryBinding({required this.label});

  final String label;
}

class NavTelemetryLabels {
  NavTelemetryLabels._();

  static RouteSettings settingsWithLabel(String label) {
    return RouteSettings(arguments: RouteTelemetryBinding(label: label));
  }

  /// 获取埋点文案
  static String formatPageRoute(PageRoute<dynamic> route) {
    final key = route.settings.name;
    final args = route.settings.arguments;
    if (args is RouteTelemetryBinding) {
      return args.label;
    }
    final registered = NovaRouteLabelRegistry.labelForRouteName(key);
    if (registered != null) return registered;
    if (key != null && key.isNotEmpty) return key;
    return route.runtimeType.toString();
  }
}
