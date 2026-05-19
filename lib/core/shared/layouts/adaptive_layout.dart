import 'package:flutter/material.dart';

import '../../../app/device/device_form_factor.dart';

/// 按设备形态，适配布局
///
/// 替代继承 [NovaPageShell]
class AdaptiveLayout extends StatelessWidget {
  const AdaptiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.foldable,
  });

  final WidgetBuilder mobile;
  final WidgetBuilder? tablet;
  final WidgetBuilder? foldable;

  @override
  Widget build(BuildContext context) {
    return switch (DeviceFormFactorUtil.of(context)) {
      DeviceFormFactor.phone => mobile(context),
      DeviceFormFactor.pad => (tablet ?? mobile)(context),
      DeviceFormFactor.padLandscape => (tablet ?? mobile)(context),
      DeviceFormFactor.foldable => (foldable ?? tablet ?? mobile)(context),
    };
  }
}

/// 替代继承 [NovaStatefulPageShell]
class AdaptiveStatefulLayout extends StatefulWidget {

  const AdaptiveStatefulLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.foldable,
  });

  final WidgetBuilder mobile;
  final WidgetBuilder? tablet;
  final WidgetBuilder? foldable;

  @override
  State<AdaptiveStatefulLayout> createState() => _AdaptiveStatefulLayoutState();
}

class _AdaptiveStatefulLayoutState extends State<AdaptiveStatefulLayout> {

  @override
  Widget build(BuildContext context) {
    return switch (DeviceFormFactorUtil.of(context)) {
      DeviceFormFactor.phone => widget.mobile(context),
      DeviceFormFactor.pad => (widget.tablet ?? widget.mobile)(context),
      DeviceFormFactor.padLandscape => (widget.tablet ?? widget.mobile)(context),
      DeviceFormFactor.foldable => (widget.foldable ?? widget.tablet ?? widget.mobile)(context),
    };
  }

}
