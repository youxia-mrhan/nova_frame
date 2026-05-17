import 'package:flutter_test/flutter_test.dart';
import 'package:nova_frame/core/navigation/uri/nova_uri.dart';
import 'package:nova_frame/core/foundation/logger/nova_logger.dart';
import 'package:nova_frame/example/push_link/fake_push_link_entity_params_page.dart';
import 'package:nova_frame/example/push_link/fake_push_link_primitive_params_page.dart';
import 'package:nova_frame/example/router_demo/entity/demo_user_entity.dart';

void main() {
  group('_', () {
    test('_', () {
      final uri = NovaUri.buildDeepLinkUri(
        path: FakePushLinkPrimitiveRt.path,
        query: {'title': 'from_push_link', 'count': 2},
      );
      const user = DemoUserEntity(id: 'plink', name: 'PushLink', age: 1);
      final uri2 = NovaUri.buildDeepLinkUri(path: FakePushLinkEntityRt.path, query: {'payload': user.toJson()});
      NovaLogger.d('基本类型参数的链接: $uri');
      NovaLogger.d('实体类型参数的链接: $uri2');
    });
  });
}
