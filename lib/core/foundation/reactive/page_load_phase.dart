/// 页面级接口请求展示阶段（可与 [NovaPageState]、[NovaPageView] 配合使用）
enum NovaPageLoadPhase {
  /// 显性加载中（全页或占位 loading）
  loading,

  /// 加载成功，使用业务数据渲染正文
  success,

  /// 加载失败，展示错误信息与重试
  failure,

  /// 隐式刷新：不展示 loading，完成后直接更新数据
  silentRefresh,
}
