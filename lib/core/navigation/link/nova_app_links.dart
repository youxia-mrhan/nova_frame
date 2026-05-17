import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/logger/nova_logger.dart';
import '../nova_router.dart';
import '../uri/nova_uri.dart';
import 'nova_link_scheme.dart';

abstract final class NovaAppLinks {
  NovaAppLinks._();

  static final AppLinks _appLinks = AppLinks();
  static StreamSubscription<Uri?>? _sub;

  static Future<void> init() async {
    Uri? initial;
    try {
      initial = await _appLinks.getInitialLink();
    } catch (e, st) {
      NovaLogger.d('[NovaAppLinks] getInitialLink error', error: e, stackTrace: st);
    }

    final Uri? echoSkipTarget = initial != null && NovaLinkScheme.matchesAppLinkUri(initial) ? initial : null;
    var skipStreamEchoOfInitial = echoSkipTarget != null;

    await _sub?.cancel();
    _sub = _appLinks.uriLinkStream.listen((uri) {
      if (skipStreamEchoOfInitial && echoSkipTarget != null && uri.toString() == echoSkipTarget.toString()) {
        skipStreamEchoOfInitial = false;
        NovaLogger.d('[NovaAppLinks] skip uriLinkStream echo of getInitialLink: $uri');
        return;
      }
      _scheduleHandle(uri, cold: false);
    }, onError: (Object e) => NovaLogger.d('[NovaAppLinks] stream error: $e'));

    _scheduleHandle(initial, cold: true);
  }

  static void _scheduleHandle(Uri? uri, {required bool cold}) {
    if (uri == null) return;
    if (!NovaLinkScheme.matchesAppLinkUri(uri)) return;

    if (cold) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        WidgetsBinding.instance.addPostFrameCallback((Duration _) => _pushFromLinkUri(uri));
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) => _pushFromLinkUri(uri));
    }
  }

  /// 从 link 的 URI 取出 [path][param]
  static void _pushFromLinkUri(Uri uri) {
    final nav = novaRouter.navigatorKey.currentState;
    if (nav == null || !nav.mounted) {
      NovaLogger.d('[NovaAppLinks] navigator not ready, drop: $uri');
      return;
    }

    final pathParam = uri.queryParameters['path'];
    if (pathParam == null || pathParam.isEmpty) {
      NovaLogger.d('[NovaAppLinks] no path query, drop: $uri');
      return;
    }

    final innerPath = Uri.decodeComponent(pathParam);
    final normalized = innerPath.startsWith('/') ? innerPath : '/$innerPath';

    final query = <String, dynamic>{};
    for (final MapEntry(:key, :value) in uri.queryParameters.entries) {
      if (key == 'path') continue;
      query[key] = value;
    }

    final location = NovaUri.buildPushPath(path: normalized, query: query.isEmpty ? null : query);
    NovaLogger.d('[NovaAppLinks] incoming uri: $uri');
    NovaLogger.d('[NovaAppLinks] queryParameters: ${uri.queryParameters}');
    NovaLogger.d('[NovaAppLinks] normalized path: $normalized');
    NovaLogger.d('[NovaAppLinks] query map (no path): $query');
    NovaLogger.d('[NovaAppLinks] pushPath location: $location');
    novaRouter.pushPath<void>(location);
  }
}
