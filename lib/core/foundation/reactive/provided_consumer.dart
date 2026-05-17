import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// [ChangeNotifierProvider] + [Consumer] 合并为一层，减少样板代码。
///
/// ```dart
/// NovaProvidedConsumer<ArticleListProvider>(
///   create: (_) => ArticleListProvider(),
///   builder: (context, model, _) => ...,
/// );
/// ```
class NovaProvidedConsumer<T extends ChangeNotifier> extends StatelessWidget {
  const NovaProvidedConsumer({
    super.key,
    required this.create,
    required this.builder,
    this.child,
  });

  final T Function(BuildContext context) create;
  final Widget Function(BuildContext context, T model, Widget? child) builder;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
      create: create,
      child: Consumer<T>(builder: builder, child: child),
    );
  }
}
