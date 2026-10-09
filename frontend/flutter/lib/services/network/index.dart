/// Network module barrel export
///
/// 网络层核心模块，包含：
/// - [ApiClient] — 单例 API 客户端，6 层拦截器链，泛型请求方法
/// - [NetworkStatusService] — 网络质量检测，动态超时 10s/15s/30s
/// - [CircuitBreaker] — 熔断器，10 次失败后熔断 30s
library;

export 'api_client.dart';
export 'network_status.dart';
export 'circuit_breaker.dart';
