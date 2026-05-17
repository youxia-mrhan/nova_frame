import 'dart:convert';

/// 示例实体：用于“实体参数走 URI query payload”的 demo。
class DemoUserEntity {
  const DemoUserEntity({
    required this.id,
    required this.name,
    required this.age,
  });

  final String id;
  final String name;
  final int age;

  factory DemoUserEntity.fromJson(Map<String, dynamic> json) {
    return DemoUserEntity(
      id: json['id'] as String,
      name: json['name'] as String,
      age: json['age'] as int,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'age': age};

  @override
  String toString() => 'DemoUserEntity(id=$id, name=$name, age=$age)';
}

extension DemoUserEntityPayloadX on DemoUserEntity {
  /// 实体 → JSON → urlEncode（适合放入 URI query 的 payload）
  String toPayload() => Uri.encodeComponent(jsonEncode(toJson()));

  /// payload(urlEncodedJson) → 实体
  static DemoUserEntity fromPayload(String payload) {
    final decoded = Uri.decodeComponent(payload);
    final map = jsonDecode(decoded) as Map<String, dynamic>;
    return DemoUserEntity.fromJson(map);
  }
}

