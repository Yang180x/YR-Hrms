/// 安全地将 dynamic 转为 List`<`Map`<`String, dynamic>>>
List<Map<String, dynamic>> safeMapList(dynamic data) => switch (data) {
  final List<dynamic> list => list.whereType<Map<String, dynamic>>().toList(),
  _ => <Map<String, dynamic>>[],
};

/// 安全地将 dynamic 转为 Map`<`String, dynamic>>
Map<String, dynamic> safeMap(dynamic data) => switch (data) {
  final Map<String, dynamic> m => m,
  _ => <String, dynamic>{},
};

/// 类型工具
extension NullableStringExtension on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;
  bool get isNotNullOrEmpty => !isNullOrEmpty;
}
