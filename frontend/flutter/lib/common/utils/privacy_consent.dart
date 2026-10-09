import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../services/index.dart';

/// 隐私政策同意闸门 —— **用户同意前不得采集任何个人信息**（上架合规红线）
///
/// 根因不是某一行写错，而是**初始化顺序没有闸门**：启动期「设备信息预加载 / 推送 SDK 初始化 /
/// 错误上报」都跑在隐私弹窗之前（`flutter_udid` 的 Android 实现即
/// `Settings.Secure.getString(resolver, ANDROID_ID)`，调用即违规）。
/// 基座提供本机制，派生项目只需「把采集型初始化交给 [defer]」，不再重复踩坑。
///
/// ## 接入三步（派生项目照做即可合规）
///
/// 1. **判断**：启动时用 [isAgreed] 决定「立即初始化」还是「[defer] 到同意后」；
///
///    ```dart
///    if (PrivacyConsent.isAgreed) {
///      await _initPush();                       // 极光 / 友盟 / 埋点 …
///    } else {
///      await PushSdk.setCollectEnabled(false);  // 只关采集开关，不初始化
///      PrivacyConsent.defer(_initPush);
///    }
///    ```
///
/// 2. **同意**：用户点「同意」时调 [agree]（落盘 + 执行全部延迟初始化），
///    并同时提供「补同意」入口（个人中心/设置页），避免用户点了「暂不同意」后
///    本次运行内永远无法同意（只能靠下次冷启动重弹）。
///
/// 3. **设备标识**：读 ANDROID_ID / IDFV / OAID 一律封装在单一工具里并加同样的闸门
///    （未同意 → 返回占位值，**根本不读原生**）；若同意前已生成过占位值，
///    在 [agree] 里作废它，否则同意后仍读不到真实标识（AppID 与会话绑定不一致）。
///
/// ⚠️ 失败关闭：存储未就绪时 [isAgreed] 恒为 `false`（宁可少采集，不可违规）。
class PrivacyConsent {
  PrivacyConsent._();

  /// 持久化 key —— 沿用历史 key（**勿改**，否则已同意用户会重复看到弹窗）
  static const String storageKey = 'privacy_agreed';

  /// 待「同意后」执行的初始化队列（同意后清空，不重复执行）
  static final List<FutureOr<void> Function()> _deferred = [];

  /// 是否已同意隐私政策
  ///
  /// - 存储未就绪（启动极早期 / 单测脚手架）→ 按**未同意**处理（不采集）；
  /// - 不做内存缓存：`KVStorage` 读的是内存 map（O(1)），缓存反而会在
  ///   「换账号 / 测试用例重置 prefs」时读到脏值。
  static bool get isAgreed {
    if (!KVStorage.isReady) {
      return false;
    }
    return KVStorage.getBool(storageKey) ?? false;
  }

  /// 用户点击「同意」：落盘 → 执行全部延迟初始化（幂等）
  ///
  /// 前置条件：`KVStorage.init()` 已完成（`Global.init()` 保证）。
  /// 派生项目若在同意前生成过占位设备标识，请在本方法内一并作废（见文件头「接入三步」第 3 条）。
  static Future<void> agree() async {
    if (KVStorage.isReady) {
      KVStorage.setBool(storageKey, true);
    }
    await flushDeferred();
  }

  /// 注册「同意后才允许执行」的初始化
  ///
  /// - 已同意 → **立即执行**（同步启动：调用方拿回控制权前动作已开始，
  ///   不能包一层 `Future(() => ...)` 推迟到下一个事件循环，否则「启动即上报」类逻辑
  ///   会出现时序空洞）；异步异常内部吞掉不外抛；
  /// - 未同意 → 入队，等 [agree] 触发。
  static void defer(FutureOr<void> Function() action) {
    if (isAgreed) {
      _runGuarded(action);
      return;
    }
    _deferred.add(action);
  }

  /// 立即执行：同步启动 + 捕获取同步异常与异步异常（均不外抛）
  static void _runGuarded(FutureOr<void> Function() action) {
    try {
      final FutureOr<void> result = action();
      if (result is Future<void>) {
        unawaited(result.catchError((Object e, StackTrace s) {
          debugPrint('[PrivacyConsent] 延迟初始化失败: $e\n$s');
        }));
      }
    } catch (e, s) {
      debugPrint('[PrivacyConsent] 延迟初始化失败: $e\n$s');
    }
  }

  /// 执行全部延迟初始化（由 [agree] 调用；单个失败不阻断其余）
  static Future<void> flushDeferred() async {
    if (_deferred.isEmpty) {
      return;
    }
    final List<FutureOr<void> Function()> pending = List.of(_deferred);
    _deferred.clear();
    for (final action in pending) {
      try {
        await action();
      } catch (e, s) {
        debugPrint('[PrivacyConsent] 延迟初始化失败: $e\n$s');
      }
    }
  }

  /// 待执行的延迟初始化数量（诊断 / 测试用）
  @visibleForTesting
  static int get pendingCount => _deferred.length;

  /// 清空延迟队列（**仅供测试隔离**；生产代码勿调用）
  @visibleForTesting
  static void resetForTest() => _deferred.clear();
}
