import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fastapiadmin_mobile/common/utils/privacy_consent.dart';
import 'package:fastapiadmin_mobile/services/index.dart';

/// 隐私同意闸门回归测试 —— 锁死「用户同意前不采集个人信息」这条上架合规红线
///
/// 背景：2026-09-18 派生项目（启运网司机端）隐私合规检测判定
/// 「读取AndroidID 早于 弹出隐私政策」——根因是启动期采集型初始化没有闸门。
/// 基座把这套机制固化成 `PrivacyConsent`，本测试守住语义：
///   ① 存储未就绪 → 失败关闭（isAgreed = false，宁可不采集）；
///   ② 未同意 → defer 的采集型初始化**不执行**；
///   ③ 同意（agree）→ 落盘 + 按注册顺序补齐全部延迟初始化；
///   ④ 重复 agree 幂等；单个初始化抛异常不阻断其余；
///   ⑤ 已同意 → defer **同步启动**（不得推迟到下一个事件循环）。
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    PrivacyConsent.resetForTest();
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await KVStorage.init();
  });

  test('存储未就绪 → 失败关闭（isAgreed 恒 false，不采集）', () {
    SharedPreferences.setMockInitialValues(<String, Object>{
      PrivacyConsent.storageKey: true, // 即使磁盘上已同意
    });
    // 丢弃已缓存实例 → 模拟「未就绪」（启动极早期 / 未 init）
    KVStorage.resetCacheForTest();
    expect(KVStorage.isReady, isFalse);
    expect(PrivacyConsent.isAgreed, isFalse,
        reason: '存储未就绪时必须按「未同意」处理，宁可少采集不可违规');
  });

  test('未同意 → defer 入队不执行', () async {
    expect(PrivacyConsent.isAgreed, isFalse);

    var ran = false;
    PrivacyConsent.defer(() {
      ran = true;
    });
    await pumpEventQueue();

    expect(ran, isFalse, reason: '未同意不得执行采集型初始化');
    expect(PrivacyConsent.pendingCount, 1);
  });

  test('agree() 落盘 + 按注册顺序补齐全部延迟初始化', () async {
    final List<String> ran = <String>[];
    PrivacyConsent.defer(() async => ran.add('pushSdk'));
    PrivacyConsent.defer(() async => ran.add('deviceInfo'));
    PrivacyConsent.defer(() async => ran.add('report'));
    await pumpEventQueue();
    expect(ran, isEmpty);

    await PrivacyConsent.agree();

    expect(KVStorage.getBool(PrivacyConsent.storageKey), isTrue, reason: '同意必须落盘');
    expect(ran, <String>['pushSdk', 'deviceInfo', 'report'],
        reason: '补同意后必须按注册顺序全部补上（漏一个 = 该能力静默失效）');
    expect(PrivacyConsent.pendingCount, 0);
  });

  test('重复 agree 幂等：延迟初始化不会执行两次', () async {
    var runs = 0;
    PrivacyConsent.defer(() async => runs++);

    await PrivacyConsent.agree();
    await PrivacyConsent.agree();

    expect(runs, 1);
    expect(PrivacyConsent.isAgreed, isTrue);
  });

  test('单个延迟初始化抛异常不阻断其余', () async {
    var second = false;
    PrivacyConsent.defer(() => throw StateError('boom'));
    PrivacyConsent.defer(() {
      second = true;
    });

    await PrivacyConsent.agree();

    expect(second, isTrue);
  });

  test('已同意 → defer 同步启动（不推迟到下一个事件循环）', () async {
    await PrivacyConsent.agree();

    var ran = false;
    PrivacyConsent.defer(() {
      ran = true;
    });

    // 关键：不 await / 不 pumpEventQueue 也应已开始执行
    expect(ran, isTrue,
        reason: '已同意路径必须同步启动，否则「启动即上报」类逻辑会出现时序空洞');
    expect(PrivacyConsent.pendingCount, 0);
  });
}
