import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:nova_frame/core/navigation/tracking/route_tracker.dart';

import '../uri/nova_uri.dart';

extension NovaRouteContextX on BuildContext {
  Future<T?> push<T extends Object?>({
    required String path,
    String? description,
    Map<String, dynamic>? query,
    bool includePrefixMatches = false,
    OnNavigationFailure? onFailure,
  }) {
    final normalized = path.startsWith('/') ? path : '/$path';
    NovaRouteTracker.track(path: normalized, description: description ?? normalized);
    final location = NovaUri.buildPushPath(path: normalized, query: query);
    return router.pushPath<T>(location, includePrefixMatches: includePrefixMatches, onFailure: onFailure);
  }

  Future<T?> replace<T extends Object?>({
    required String path,
    String? description,
    Map<String, dynamic>? query,
    bool includePrefixMatches = false,
    OnNavigationFailure? onFailure,
  }) {
    final normalized = path.startsWith('/') ? path : '/$path';
    NovaRouteTracker.track(path: normalized, description: description ?? normalized);
    final location = NovaUri.buildPushPath(path: normalized, query: query);
    return router.replacePath<T>(location, includePrefixMatches: includePrefixMatches, onFailure: onFailure);
  }

  void pop<T extends Object?>([T? result]) => router.pop<T>(result);

  Future<bool> maybePop<T extends Object?>([T? result]) => router.maybePop<T>(result);
}
