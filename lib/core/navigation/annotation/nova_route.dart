// ignore_for_file: camel_case_types

/// ```dart
/// abstract final class ArticleRt {
///   ArticleRt._();
///   static const String path = '/article/detail';
///   static const String description = '文章详情';
/// }
///
/// @NovaRoute(path: ArticleRt.path, description: ArticleRt.description)
/// @RoutePage()
/// class ArticleDetailPage extends StatelessWidget { ... }
/// ```
class NovaRoute {
  const NovaRoute({
    required this.path,
    required this.description,
  });

  final String path;
  final String description;
}
