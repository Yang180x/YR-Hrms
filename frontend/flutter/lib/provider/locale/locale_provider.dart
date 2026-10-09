import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 用户语言偏好持久化 key（仅存语言码，如 'en'）
const String kUserLocalePrefKey = 'user_locale';

/// 全局语言状态
/// state 恒为具体 [Locale]（zh / en），不会为 null —— Provider/Service 侧
/// 可直接 `lookupAppLocalizations(ref.watch(localeProvider))` 取实例。
/// preference == null 表示「跟随系统」：启动/系统语言变化时用平台 locale 最佳匹配。
/// 设计参照 docs/2026-08-13-i18n-design.md §2.2
final localeProvider = NotifierProvider<LocaleNotifier, Locale>(
  LocaleNotifier.new,
);

/// 语言 Notifier
class LocaleNotifier extends Notifier<Locale> {
  /// 支持的语言（顺序即兜底优先级：中文为主，无匹配回退 zh）
  static const List<Locale> supportedLocales = [Locale('zh'), Locale('en')];

  /// 用户手动选择；null = 跟随系统
  Locale? _preference;

  @override
  Locale build() {
    // 资源释放：系统语言监听随 provider 销毁移除
    ref.onDispose(() {
      WidgetsBinding.instance.platformDispatcher.onLocaleChanged = null;
    });
    // 跟随系统：用户未手动选择时，系统语言变化即时生效
    WidgetsBinding.instance.platformDispatcher.onLocaleChanged =
        _onPlatformLocaleChanged;
    // 异步恢复持久化偏好
    _load();
    return _resolvePlatform();
  }

  static Locale _resolvePlatform() {
    final platform = WidgetsBinding.instance.platformDispatcher.locale;
    for (final s in supportedLocales) {
      if (s.languageCode == platform.languageCode) {
        return s;
      }
    }
    return supportedLocales.first;
  }

  static bool _isSupported(String languageCode) =>
      supportedLocales.any((l) => l.languageCode == languageCode);

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(kUserLocalePrefKey);
    if (code != null && code.isNotEmpty && _isSupported(code)) {
      _preference = Locale(code);
      state = Locale(code);
    }
  }

  void _onPlatformLocaleChanged() {
    if (_preference == null) {
      state = _resolvePlatform();
    }
  }

  /// 切换语言；传 null 恢复「跟随系统」
  Future<void> setLocale(Locale? locale) async {
    _preference = locale;
    state = locale ?? _resolvePlatform();
    final prefs = await SharedPreferences.getInstance();
    if (locale == null) {
      await prefs.remove(kUserLocalePrefKey);
    } else {
      await prefs.setString(kUserLocalePrefKey, locale.languageCode);
    }
  }
}
