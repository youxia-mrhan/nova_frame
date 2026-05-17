import '../../../foundation/logger/nova_logger.dart';

class ApiResponse<T> {
  final int? code;
  final String? message;
  final T? data;

  ApiResponse({required this.code, this.message, this.data});

  /// 要根据接口返回的字段，自行调整
  bool get isSuccess => code == 0 || code == 200;

  /// - [json]: 原始 JSON 数据
  /// - [parser]: 转换函数，用于将 JSON 转换为指定类型
  /// 以下 Map 取值（errorCode、errorMsg、data …）要根据接口返回的字段，自行调整
  factory ApiResponse.fromJson(dynamic json, {T Function(dynamic)? parser}) {
    if (json == null) {
      return ApiResponse<T>(code: null, message: null, data: null);
    }
    if (json is! Map) {
      throw FormatException('ApiResponse.fromJson: expected Map envelope, got ${json.runtimeType}');
    }
    final map = Map<String, dynamic>.from(json);

    final codeRaw = map['errorCode'];
    final int? code = switch (codeRaw) {
      final int i => i,
      final num n => n.toInt(),
      final String s => int.tryParse(s),
      _ => null,
    };

    final message = (map['errorMsg']) as String?;

    final bool hasDataKey = map.containsKey('data');
    final dynamic payload = hasDataKey ? map['data'] : map;

    dynamic parsed = payload;
    if (parser != null) {
      try {
        parsed = parser(payload);
      } catch (e, stack) {
        NovaLogger.d('ApiResponse parser failed: $e\n$stack');
        rethrow;
      }
    }

    return ApiResponse<T>(code: code, message: message, data: parsed);
  }
}
