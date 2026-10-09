import 'package:dio/dio.dart';

/// 排队请求记录
class QueuedRequest {
  final RequestOptions options;
  final RequestInterceptorHandler handler;

  QueuedRequest({required this.options, required this.handler});
}

/// 请求队列 — 断网时将请求入队，网络恢复后自动执行
///
/// 队列最大容量 50，满时丢弃最早请求避免内存溢出。
class RequestQueue {
  static const int _maxQueueSize = 50;
  final List<QueuedRequest> _queue = [];

  /// 当前队列长度
  int get length => _queue.length;

  /// 请求入队
  ///
  /// 队列满时丢弃最早入队的请求。
  bool enqueue(QueuedRequest request) {
    if (_queue.length >= _maxQueueSize) {
      _queue.removeAt(0);
    }
    _queue.add(request);
    return true;
  }

  /// 冲刷队列 — 按序执行所有排队请求
  Future<void> flush() async {
    final requests = List<QueuedRequest>.from(_queue);
    _queue.clear();

    for (final queued in requests) {
      try {
        // 使用 dio 重新发送请求
        // Note: 实际执行由 NetworkStatusInterceptor 通过 Dio 完成
        queued.handler.next(queued.options);
      } catch (_) {
        // 单个请求失败不影响后续请求
      }
    }
  }

  /// 清空队列
  void clear() {
    _queue.clear();
  }
}
