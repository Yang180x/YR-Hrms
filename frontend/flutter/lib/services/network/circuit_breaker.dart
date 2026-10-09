/// 熔断器状态
enum CircuitBreakerState {
  /// 正常放行
  closed,

  /// 熔断中，拒绝所有请求
  open,

  /// 尝试放行少量探测请求
  halfOpen,
}

/// 熔断器 — 防止雪崩效应
///
/// 连续失败达到阈值时熔断，冷却后进入半开状态尝试探测请求。
/// 全局单一实例，服务器过载时全局熔断。
class CircuitBreaker {
  static final CircuitBreaker instance = CircuitBreaker._();

  CircuitBreaker._();

  CircuitBreakerState _state = CircuitBreakerState.closed;

  /// 当前熔断器状态
  CircuitBreakerState get state => _state;

  /// 是否允许发起请求
  bool get allowRequest {
    switch (_state) {
      case CircuitBreakerState.closed:
        return true;
      case CircuitBreakerState.open:
        // 冷却时间已过，进入半开状态
        if (_lastFailureTime != null &&
            DateTime.now().difference(_lastFailureTime!) >= _resetDuration) {
          _transitionTo(CircuitBreakerState.halfOpen);
          return true;
        }
        return false;
      case CircuitBreakerState.halfOpen:
        // 半开状态下只允许少量探测请求
        if (_halfOpenCalls < _halfOpenMaxCalls) {
          _halfOpenCalls++;
          return true;
        }
        return false;
    }
  }

  /// 失败计数
  int _failureCount = 0;

  /// 失败阈值（达到此值后熔断）
  final int _failureThreshold = 10;

  /// 最后失败时间
  DateTime? _lastFailureTime;

  /// 冷却时间
  final Duration _resetDuration = const Duration(seconds: 30);

  /// 半开状态下允许的最大探测请求数
  final int _halfOpenMaxCalls = 3;

  /// 当前半开探测数
  int _halfOpenCalls = 0;

  /// 记录一次成功（仅在半开状态时有效）
  void recordSuccess() {
    if (_state == CircuitBreakerState.halfOpen) {
      // 半开状态下成功后恢复正常
      _transitionTo(CircuitBreakerState.closed);
    }
    // 关闭状态下成功，重置失败计数
    if (_state == CircuitBreakerState.closed) {
      _failureCount = 0;
    }
  }

  /// 记录一次失败
  void recordFailure() {
    _failureCount++;
    _lastFailureTime = DateTime.now();

    if (_state == CircuitBreakerState.halfOpen) {
      // 半开状态下的探测失败，回到熔断
      _transitionTo(CircuitBreakerState.open);
      return;
    }

    if (_state == CircuitBreakerState.closed &&
        _failureCount >= _failureThreshold) {
      _transitionTo(CircuitBreakerState.open);
    }
  }

  /// 状态转换
  void _transitionTo(CircuitBreakerState newState) {
    _state = newState;
    switch (newState) {
      case CircuitBreakerState.open:
        _halfOpenCalls = 0;
        _lastFailureTime = DateTime.now();
        break;
      case CircuitBreakerState.halfOpen:
        _halfOpenCalls = 0;
        break;
      case CircuitBreakerState.closed:
        _failureCount = 0;
        _halfOpenCalls = 0;
        _lastFailureTime = null;
        break;
    }
  }

  /// 重置熔断器
  void reset() {
    _failureCount = 0;
    _halfOpenCalls = 0;
    _lastFailureTime = null;
    _state = CircuitBreakerState.closed;
  }
}
