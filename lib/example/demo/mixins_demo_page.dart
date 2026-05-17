import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../core/shared/layouts/nova_page_shell.dart';
import '../../../app/page/mixins/app_lifecycle_mixin.dart';
import '../../../app/page/mixins/keyboard_visibility_mixin.dart';
import '../../../app/page/mixins/route_aware_mixin.dart';
import '../../core/navigation/annotation/nova_route.dart';
import '../../core/navigation/protocol/route_navigation.dart';
import '../../core/shared/box/adapt.dart';

abstract final class MixinsDemoRt {
  MixinsDemoRt._();
  static const String path = '/demo/mixins';
  static const String description = '常用 Mixins Demo';
}

@NovaRoute(path: MixinsDemoRt.path, description: MixinsDemoRt.description)
@RoutePage()
class MixinsDemoPage extends NovaPageShell {
  const MixinsDemoPage({super.key});

  @override
  Widget buildPhone(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('常用 Mixins Demo')),
      body: ListView(
        padding: EdgeInsets.all(16.dp),
        children: [
          _Item(
            title: '键盘弹起/收起监听',
            subtitle: 'KeyboardVisibilityMixin：TextField 聚焦触发',
            onTap: () => context.push(path: MixinKeyboardDemoRt.path),
          ),
          _Item(
            title: 'App 前后台监听',
            subtitle: 'AppLifecycleMixin：inactive/paused/resumed 等',
            onTap: () => context.push(path: MixinAppLifecycleDemoRt.path),
          ),
          _Item(
            title: 'RouteAware 页面路由监听',
            subtitle: 'RouteAwareMixin：didPush/didPop/didPushNext/didPopNext',
            onTap: () => context.push(path: MixinRouteAwareDemoRt.path),
          ),
        ],
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: 12.dp),
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(16.rd),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(16.dp),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: 6.dp),
                      Text(subtitle, style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

abstract final class MixinKeyboardDemoRt {
  MixinKeyboardDemoRt._();
  static const String path = '/demo/mixin_keyboard';
  static const String description = 'Mixins Demo · 键盘可见性';
}

@NovaRoute(path: MixinKeyboardDemoRt.path, description: MixinKeyboardDemoRt.description)
@RoutePage()
class KeyboardDemoPage extends NovaStatefulPageShell {
  const KeyboardDemoPage({super.key});

  @override
  State<KeyboardDemoPage> createState() => _KeyboardDemoPageState();
}

class _KeyboardDemoPageState extends NovaStatefulPageShellState<KeyboardDemoPage> with KeyboardVisibilityMixin {
  final _controller = TextEditingController();
  final _events = <String>[];

  @override
  void onKeyboardVisibilityChanged(bool visible) {
    setState(() {
      _events.insert(0, '${DateTime.now().toIso8601String()}  keyboardVisible=$visible');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget buildPhone(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('键盘监听 Demo')),
      body: Padding(
        padding: EdgeInsets.all(16.dp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('当前键盘状态：$keyboardVisible', style: const TextStyle(fontWeight: FontWeight.w700)),
            SizedBox(height: 12.dp),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '点我弹起键盘 / 收起键盘观察状态变化',
              ),
            ),
            SizedBox(height: 12.dp),
            Expanded(
              child: Card(
                child: ListView.separated(
                  padding: EdgeInsets.all(12.dp),
                  itemCount: _events.length,
                  separatorBuilder: (context, index) => Divider(height: 16.dp),
                  itemBuilder: (context, i) => Text(_events[i]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

abstract final class MixinAppLifecycleDemoRt {
  MixinAppLifecycleDemoRt._();
  static const String path = '/demo/mixin_app_lifecycle';
  static const String description = 'Mixins Demo · App 生命周期';
}

@NovaRoute(path: MixinAppLifecycleDemoRt.path, description: MixinAppLifecycleDemoRt.description)
@RoutePage()
class AppLifecycleDemoPage extends NovaStatefulPageShell {
  const AppLifecycleDemoPage({super.key});

  @override
  State<AppLifecycleDemoPage> createState() => _AppLifecycleDemoPageState();
}

class _AppLifecycleDemoPageState extends NovaStatefulPageShellState<AppLifecycleDemoPage> with AppLifecycleMixin {
  final _events = <String>[];

  @override
  void onAppLifecycleStateChanged(AppLifecycleState state) {
    setState(() {
      _events.insert(0, '${DateTime.now().toIso8601String()}  lifecycle=${state.name}');
    });
  }

  @override
  Widget buildPhone(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('App 生命周期 Demo')),
      body: Padding(
        padding: EdgeInsets.all(16.dp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '最后一次生命周期：${lastLifecycleState?.name ?? '-'}',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 8.dp),
            const Text('把 App 切到后台再回来（或锁屏/解锁）观察事件变化。'),
            SizedBox(height: 12.dp),
            Expanded(
              child: Card(
                child: ListView.separated(
                  padding: EdgeInsets.all(12.dp),
                  itemCount: _events.length,
                  separatorBuilder: (context, index) => Divider(height: 16.dp),
                  itemBuilder: (context, i) => Text(_events[i]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

abstract final class MixinRouteAwareDemoRt {
  MixinRouteAwareDemoRt._();
  static const String path = '/demo/mixin_route_aware';
  static const String description = 'Mixins Demo · RouteAware';
}

@NovaRoute(path: MixinRouteAwareDemoRt.path, description: MixinRouteAwareDemoRt.description)
@RoutePage()
class RouteAwareDemoPage extends NovaStatefulPageShell {
  const RouteAwareDemoPage({super.key});

  @override
  State<RouteAwareDemoPage> createState() => _RouteAwareDemoPageState();
}

class _RouteAwareDemoPageState extends NovaStatefulPageShellState<RouteAwareDemoPage> with RouteAwareMixin {
  final _events = <String>[];

  void _add(String msg) {
    setState(() {
      _events.insert(0, '${DateTime.now().toIso8601String()}  $msg');
    });
  }

  @override
  void onDidPush() => _add('didPush（当前页入栈并成为 top）');

  @override
  void onDidPop() => _add('didPop（当前页出栈）');

  @override
  void onDidPushNext() => _add('didPushNext（被其他页面覆盖）');

  @override
  void onDidPopNext() => _add('didPopNext（覆盖页被 pop，当前页重新可见）');

  @override
  Widget buildPhone(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('RouteAware Demo')),
      body: Padding(
        padding: EdgeInsets.all(16.dp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FilledButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => Scaffold(
                      appBar: AppBar(title: const Text('临时覆盖页')),
                      body: Center(
                        child: FilledButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          child: const Text('pop 返回（触发 didPopNext）'),
                        ),
                      ),
                    ),
                  ),
                );
              },
              child: const Text('push 一个覆盖页（MaterialPageRoute）'),
            ),
            SizedBox(height: 12.dp),
            Expanded(
              child: Card(
                child: ListView.separated(
                  padding: EdgeInsets.all(12.dp),
                  itemCount: _events.length,
                  separatorBuilder: (context, index) => Divider(height: 16.dp),
                  itemBuilder: (context, i) => Text(_events[i]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
