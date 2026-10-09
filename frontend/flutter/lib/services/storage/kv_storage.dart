import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// SharedPreferences 账户级隔离工具
///
/// 核心逻辑：非全局 key 自动加 `{userId}:` 前缀，实现"一个账户一个缓存文件夹"。
/// 全局 key（sessionKey/sessionID/userId/phone/privacy_agreed/is_first_launch/user_locale）
/// 不加前缀，保证登录流程和应用级设置跨账户共享。
const _globalKeys = [
  'sessionKey',
  'sessionID',
  'userId',
  'phone',
  'privacy_agreed',
  'is_first_launch',
  'user_locale',
];

class KVStorage {
  KVStorage._();

  static SharedPreferences? _prefs;

  /// 由 Global.init() 调用，缓存实例
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// 是否已初始化完成（`init()` 已执行）
  ///
  /// `getBool` 等同步读依赖 `_prefs!`，未就绪会抛。合规闸门（`PrivacyConsent`）
  /// 需要在启动极早期判断「是否已同意」，必须先探测就绪状态（未就绪按未同意处理）。
  static bool get isReady => _prefs != null;

  /// 丢弃已缓存的实例（**仅供测试隔离** —— 配合 `setMockInitialValues` 重置状态；
  /// 生产代码勿调用）
  @visibleForTesting
  static void resetCacheForTest() => _prefs = null;

  /// 获取当前用户 ID（从全局 SharedPreferences 同步读取）
  static String? _getUserId() => _prefs?.getString('userId');

  /// 带前缀的 key：全局 key 原样返回，用户级 key 加 `{userId}:` 前缀
  static String _scopedKey(String key) {
    if (_globalKeys.contains(key)) return key;
    final userId = _getUserId();
    return userId != null && userId.isNotEmpty ? '$userId:$key' : key;
  }

  // ── String ──
  // 内存缓存立即生效，磁盘写入异步完成（fire-and-forget）

  static void setString(String key, String value) =>
      _prefs!.setString(_scopedKey(key), value);

  static String? getString(String key) => _prefs!.getString(_scopedKey(key));

  /// 批量写入多个 String 键值对（并行写入，确保全部完成）
  /// 用于登录 token 等需要原子性写入的场景
  static Future<void> setStrings(Map<String, String> entries) async {
    await Future.wait(
      entries.entries.map((e) => _prefs!.setString(_scopedKey(e.key), e.value)),
    );
  }

  // ── Bool ──

  static void setBool(String key, bool value) =>
      _prefs!.setBool(_scopedKey(key), value);

  static bool? getBool(String key) => _prefs!.getBool(_scopedKey(key));

  // ── Remove ──

  static void remove(String key) => _prefs!.remove(_scopedKey(key));

  /// 清除指定用户的级数据（默认当前用户）
  static Future<void> clearUserData([String? userId]) async {
    final uid = userId ?? _getUserId();
    if (uid == null || uid.isEmpty) return;
    final prefix = '$uid:';
    final keysToRemove = _prefs!
        .getKeys()
        .where((k) => k.startsWith(prefix))
        .toList();
    for (final k in keysToRemove) {
      await _prefs!.remove(k);
    }
  }

  /// 首次升级迁移：清除旧的无前缀用户级 key
  static Future<void> migrateIfNeeded() async {
    if (_prefs!.getBool('cache_migrated_v1') == true) return;
    const oldKeys = [
      'user_avatar',
      'realname_key',
      'username_key',
      'NEW_TRANS_LIST',
      'ORDER_COUNT',
      'LAST_CITY',
    ];
    for (final k in oldKeys) {
      await _prefs!.remove(k);
    }
    await _prefs!.setBool('cache_migrated_v1', true);
  }
}
