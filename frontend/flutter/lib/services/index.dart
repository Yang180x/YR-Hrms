/// Services barrel export
///
/// 统一导出所有服务层模块：
/// - [api] — API 接口（AuthApi, UserApi, NoticeApi 等）
/// - [models] — 数据模型（UserProfile 等）
/// - [network] — 网络核心（ApiClient 等）
/// - [storage] — 本地存储（KVStorage、TokenStorage）
library;

export 'api/index.dart';
export 'models/index.dart';
export 'network/index.dart';
export 'storage/kv_storage.dart';
export 'storage/token_storage.dart';
