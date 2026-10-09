/// 通用 API 响应包装（后端统一返回 { code, msg, data }）
class ApiResult<T> {
  final int code;
  final String? msg;
  final T? data;

  const ApiResult({required this.code, this.msg, this.data});

  bool get isSuccess => code == 0;

  /// 从 Map 解析，data 保持原值由调用方按需转换
  factory ApiResult.fromJson(Map<String, dynamic> json) {
    return ApiResult(
      code: json['code'] as int,
      msg: json['msg'] as String?,
      data: json['data'] as T?,
    );
  }
}

/// 通用分页结果包装
class PageResult<T> {
  final int total;
  final List<T> rows;

  const PageResult({required this.total, required this.rows});

  factory PageResult.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      // 兼容 rows / records / list 多种格式
      final list =
          (json['rows'] ?? json['records'] ?? json['list'] ?? []) as List;
      return PageResult(
        total: (json['total'] as num?)?.toInt() ?? list.length,
        rows: list.map((e) => e as T).toList(),
      );
    }
    if (json is List) {
      final list = json.map((e) => e as T).toList();
      return PageResult(total: list.length, rows: list);
    }
    return const PageResult(total: 0, rows: []);
  }
}

/// 通用分页请求参数
class PageParams {
  final int page;
  final int pageSize;

  /// 额外筛选参数（如 keyword、status、dateRange 等），合并到请求参数中
  final Map<String, dynamic> extra;

  const PageParams({this.page = 1, this.pageSize = 20, this.extra = const {}});

  /// 转为 API 请求参数 Map（默认 key: page_num / page_size）
  Map<String, dynamic> toJson() => {
    'page_num': page,
    'page_size': pageSize,
    ...extra,
  };
}
