import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 登录加载状态
class LoginNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void startLoading() => state = true;
  void stopLoading() => state = false;
}

final loginLoadingProvider = NotifierProvider<LoginNotifier, bool>(
  LoginNotifier.new,
);
