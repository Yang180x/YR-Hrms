import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 启动页倒计时
class SplashNotifier extends Notifier<int> {
  Timer? _timer;

  @override
  int build() => 5;

  void startCountdown(void Function() onComplete) {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state > 1) {
        state = state - 1;
      } else {
        timer.cancel();
        onComplete();
      }
    });
  }

  void dispose() {
    _timer?.cancel();
  }
}

final splashProvider = NotifierProvider<SplashNotifier, int>(
  SplashNotifier.new,
);
