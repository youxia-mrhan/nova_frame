import 'package:flutter/foundation.dart';

/// 全局调试日志：仅在 [kDebugMode] 下输出，Release / Profile 不执行
abstract final class NovaLogger {
  NovaLogger._();

  /// Debug 日志（仅 debug 构建）
  static void d(Object? message, {Object? error, StackTrace? stackTrace}) {
    if (!kDebugMode) return;
    final buffer = StringBuffer('$message');
    if (error != null) {
      buffer.writeln();
      buffer.writeln(error);
    }
    if (stackTrace != null) {
      buffer.writeln();
      buffer.writeln(stackTrace);
    }
    debugPrint(buffer.toString());
  }
}
