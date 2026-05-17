/// 项目常用文案（后续可接 l10n）。
abstract final class AppStrings {
  AppStrings._();

  // ---------------------------------------------------------------------------
  // 通用
  // ---------------------------------------------------------------------------

  static const unknownErr = '未知异常';

  // ---------------------------------------------------------------------------
  // 网络 / 异常（[ErrorInterceptor]、[ApiClient]）
  // ---------------------------------------------------------------------------

  static const connectionTimeout = '连接超时';
  static const serverError = '服务器错误';
  static const clientError = '客户端错误';
  static const requestCancelled = '请求被取消';
  static const connectionError = '网络连接错误';
  static const certificateError = '证书错误';
  static const requestFailed = '请求失败';

  static String invalidJsonResponse(Object error) => '响应不是合法 JSON: $error';

  // ---------------------------------------------------------------------------
  // 登录 / 401（[AuthInterceptor]）
  // ---------------------------------------------------------------------------

  static const navigatorNotReady = 'Navigator 未就绪';
  static const loginReplayFailed = '打开登录或重放失败';
  static const loginCancelled = '登录已取消';

  // ---------------------------------------------------------------------------
  // 页面加载态（[NovaPageView]）
  // ---------------------------------------------------------------------------

  static const loadFailed = '加载失败';
  static const retry = '重新请求';
  static const retryShort = '重试';
  static const requesting = '请求中...';
  static const emptyData = '暂无数据';

  // ---------------------------------------------------------------------------
  // 下拉刷新 / 上拉加载（[RefreshListView]）
  // ---------------------------------------------------------------------------

  static const refreshDrag = '下拉刷新';
  static const refreshArmed = '释放立即刷新';
  static const refreshProcessing = '正在刷新…';
  static const refreshProcessed = '刷新完成';
  static const refreshFailed = '刷新失败';

  static const loadDrag = '上拉加载';
  static const loadArmed = '释放立即加载';
  static const loadProcessing = '正在加载…';
  static const loadProcessed = '加载完成';
  static const loadFailedFooter = '加载失败';

  static const noMore = '没有更多了';
  static const lastUpdated = '上次更新 %T';
}
