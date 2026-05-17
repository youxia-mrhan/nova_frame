abstract final class NovaLinkScheme {
  NovaLinkScheme._();

  static const String prod = 'novaframe';
  static const String dev = 'novaframedev';

  static const Set<String> schemes = {prod, dev};

  static const String host = 'link';

  static String origin({String scheme = prod}) => '$scheme://$host';

  static bool matchesAppLinkUri(Uri uri) {
    if (uri.host != host) return false;
    return schemes.contains(uri.scheme);
  }
}
