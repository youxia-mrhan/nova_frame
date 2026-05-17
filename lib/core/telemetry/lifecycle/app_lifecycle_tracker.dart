import 'package:flutter/widgets.dart';
import 'package:nova_frame/core/telemetry/uploader/session_uploader.dart';

/// 上传埋点数据时机：
///   1、冷启动后，首次上传
///   2、应用切入后台时触发上传
class AppLifecycleTracker extends StatefulWidget {
  const AppLifecycleTracker({super.key, required this.child});

  final Widget child;

  @override
  State<AppLifecycleTracker> createState() => _AppLifecycleTrackerState();
}

class _AppLifecycleTrackerState extends State<AppLifecycleTracker> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      SessionUploader.tryFlushRootStackPipeline();
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
