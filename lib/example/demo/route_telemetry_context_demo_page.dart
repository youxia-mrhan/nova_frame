import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../core/navigation/mixins/route_telemetry_context.dart';
import '../../core/shared/layouts/nova_page_shell.dart';
import '../../core/navigation/annotation/nova_route.dart';
import '../../core/shared/box/adapt.dart';

abstract final class RouteTelemetryContextDemoRt {
  RouteTelemetryContextDemoRt._();
  static const String path = '/demo/route_telemetry_context';
  static const String description = '路由可读信息 Demo';
}

/// [RouteTelemetryContextX] + [RouteTelemetryStateMixin] 演示。
@NovaRoute(path: RouteTelemetryContextDemoRt.path, description: RouteTelemetryContextDemoRt.description)
@RoutePage()
class RouteTelemetryContextDemoPage extends NovaPageShell {
  const RouteTelemetryContextDemoPage({super.key});

  @override
  Widget buildPhone(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('路由可读信息 Demo')),
      body: ListView(
        padding: EdgeInsets.all(16.dp),
        children: [
          Text('说明', style: theme.textTheme.titleMedium),
          SizedBox(height: 8.dp),
          Text(
            '获取当前页面，在路由栈中的可读信息',
            style: theme.textTheme.bodyMedium,
          ),
          SizedBox(height: 24.dp),
          Text('Stateless：仅用 context 扩展', style: theme.textTheme.titleSmall),
          SizedBox(height: 8.dp),
          const _StatelessTelemetryCard(),
          SizedBox(height: 24.dp),
          Text('Stateful：with RouteTelemetryStateMixin', style: theme.textTheme.titleSmall),
          SizedBox(height: 8.dp),
          const _StatefulTelemetryCard(),
        ],
      ),
    );
  }
}

class _StatelessTelemetryCard extends StatelessWidget {
  const _StatelessTelemetryCard();

  @override
  Widget build(BuildContext context) {
    final route = ModalRoute.of(context);
    final routeType = route == null ? '(null)' : route.runtimeType.toString();
    final key = context.routeTelemetryKey ?? '(null)';
    final desc = context.routeTelemetryDescription(notPageRouteFallback: runtimeType.toString());

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.dp),
        child: DefaultTextStyle.merge(
          style: const TextStyle(height: 1.45),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _row('routeTelemetryKey', key),
              _row('routeTelemetryDescription', desc),
              _row('ModalRoute.runtimeType', routeType),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _row(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.dp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.fs)),
          SizedBox(height: 4.dp),
          SelectableText(value, style: TextStyle(fontSize: 14.fs)),
        ],
      ),
    );
  }
}

class _StatefulTelemetryCard extends StatefulWidget {
  const _StatefulTelemetryCard();

  @override
  State<_StatefulTelemetryCard> createState() => _StatefulTelemetryCardState();
}

class _StatefulTelemetryCardState extends State<_StatefulTelemetryCard> with RouteTelemetryStateMixin {
  @override
  Widget build(BuildContext context) {
    final route = ModalRoute.of(context);
    final routeType = route == null ? '(null)' : route.runtimeType.toString();

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.dp),
        child: DefaultTextStyle.merge(
          style: const TextStyle(height: 1.45),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _StatelessTelemetryCard._row('routeTelemetryKey', routeTelemetryKey ?? '(null)'),
              _StatelessTelemetryCard._row('routeTelemetryDescription', routeTelemetryDescription),
              _StatelessTelemetryCard._row('ModalRoute.runtimeType', routeType),
            ],
          ),
        ),
      ),
    );
  }
}
