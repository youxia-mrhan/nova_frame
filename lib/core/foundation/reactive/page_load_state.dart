import 'package:nova_frame/core/foundation/reactive/page_load_phase.dart';

class NovaPageLoadState<T> {
  NovaPageLoadState._({
    required this.phase,
    this.data,
    this.errorMessage,
    this.error,
  });

  /// 显性加载中
  factory NovaPageLoadState.loading() =>
      NovaPageLoadState._(phase: NovaPageLoadPhase.loading);

  /// 加载成功，携带业务数据
  factory NovaPageLoadState.success(T data) => NovaPageLoadState._(
        phase: NovaPageLoadPhase.success,
        data: data,
      );

  /// 加载失败
  factory NovaPageLoadState.failure({
    String? errorMessage,
    Object? error,
  }) =>
      NovaPageLoadState._(
        phase: NovaPageLoadPhase.failure,
        errorMessage: errorMessage,
        error: error,
      );

  /// 隐式刷新：不展示全屏 loading
  factory NovaPageLoadState.silentRefresh([T? data]) => NovaPageLoadState._(
        phase: NovaPageLoadPhase.silentRefresh,
        data: data,
      );

  final NovaPageLoadPhase phase;
  final T? data;
  final String? errorMessage;
  final Object? error;
}
