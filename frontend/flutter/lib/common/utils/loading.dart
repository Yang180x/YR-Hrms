import 'package:flutter_easyloading/flutter_easyloading.dart';

/// 加载动画工具
class LoadingUtil {
  LoadingUtil._();

  static void show([String? msg]) {
    EasyLoading.show(status: msg ?? '加载中...');
  }

  static void dismiss() {
    EasyLoading.dismiss();
  }

  static void toast(String msg) {
    EasyLoading.showToast(msg);
  }

  static void error(String msg) {
    EasyLoading.showError(msg);
  }

  static void success(String msg) {
    EasyLoading.showSuccess(msg);
  }
}
