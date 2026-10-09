import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../provider/locale/locale_provider.dart';

/// 国际化便捷访问层
///
/// - **Widget**：`context.l10n.xxx` —— 走 `Localizations` 继承组件，
///   随 `MaterialApp.locale` 变化自动重建，无需手动监听。
/// - **Provider / Service**：`ref.l10n.xxx` —— 用 `lookupAppLocalizations`
///   按当前语言同步构造实例，**无需 BuildContext**（解决 Provider 内
///   字符串无法用 `AppLocalizations.of(context)` 的问题），且随
///   `localeProvider` 变化自动重建。
///
/// 设计参照 docs/2026-08-13-i18n-design.md §2.3
extension AppL10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

extension AppL10nRef on WidgetRef {
  AppLocalizations get l10n => lookupAppLocalizations(watch(localeProvider));
}
