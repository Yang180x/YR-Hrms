import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../common/i18n/app_l10n.dart';
import '../../common/index.dart';
import '../../provider/locale/locale_provider.dart';

/// 设置页
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final currentLangCode = ref.watch(localeProvider).languageCode;

    return Scaffold(
      backgroundColor: DesignColors.background,
      appBar: AppTdNavBar(
        title: l10n.mineSettings,
        background: DesignColors.primary,
        titleColor: Colors.white,
        showBottomLine: false,
      ),
      body: ListView(
        padding: EdgeInsets.all(16.r),
        children: [
          _buildGroup(
            context,
            title: l10n.settingsGeneral,
            items: [
              _SettingItem(
                icon: Icons.notifications_outlined,
                iconColor: DesignColors.primary,
                title: l10n.settingsNotifications,
                onTap: () => TDToast.showText(
                  l10n.commonFeatureDeveloping,
                  context: context,
                ),
              ),
              _SettingItem(
                icon: Icons.language_outlined,
                iconColor: const Color(0xFF10B981),
                title: l10n.settingsLanguage,
                trailing: Text(
                  currentLangCode == 'en'
                      ? l10n.settingsLanguageEn
                      : l10n.settingsLanguageZh,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: DesignColors.textMuted,
                  ),
                ),
                onTap: () => _showLanguagePicker(context, ref),
              ),
              _SettingItem(
                icon: Icons.storage_outlined,
                iconColor: const Color(0xFFFF9500),
                title: l10n.settingsClearCache,
                trailing: Text(
                  '< 1 MB',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: DesignColors.textMuted,
                  ),
                ),
                onTap: () => _clearCache(context),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          _buildGroup(
            context,
            title: l10n.mineAbout,
            items: [
              _SettingItem(
                icon: Icons.info_outline,
                iconColor: DesignColors.primary,
                title: l10n.settingsVersion,
                trailing: Text(
                  'v1.0.0',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: DesignColors.textMuted,
                  ),
                ),
                onTap: () {},
              ),
              _SettingItem(
                icon: Icons.description_outlined,
                iconColor: const Color(0xFF8A2BE2),
                title: l10n.settingsAgreement,
                onTap: () => TDToast.showText(
                  l10n.commonFeatureDeveloping,
                  context: context,
                ),
              ),
              _SettingItem(
                icon: Icons.shield_outlined,
                iconColor: const Color(0xFF5AC8FA),
                title: l10n.settingsPrivacy,
                onTap: () => TDToast.showText(
                  l10n.commonFeatureDeveloping,
                  context: context,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 语言切换：跟随系统 / 中文 / English
  Future<void> _showLanguagePicker(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final choice = await showDialog<String>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(l10n.settingsLanguage),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.pop(ctx, 'system'),
            child: Text(l10n.settingsLanguageSystem),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(ctx, 'zh'),
            child: Text(l10n.settingsLanguageZh),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(ctx, 'en'),
            child: Text(l10n.settingsLanguageEn),
          ),
        ],
      ),
    );
    if (choice == null) return;
    final notifier = ref.read(localeProvider.notifier);
    switch (choice) {
      case 'system':
        await notifier.setLocale(null);
      case 'zh':
        await notifier.setLocale(const Locale('zh'));
      case 'en':
        await notifier.setLocale(const Locale('en'));
    }
  }

  Widget _buildGroup(
    BuildContext context, {
    required String title,
    required List<_SettingItem> items,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 8.h),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: DesignColors.textMuted,
              ),
            ),
          ),
          const Divider(height: 1, color: DesignColors.border),
          ...items.asMap().entries.map((e) {
            final idx = e.key;
            final item = e.value;
            return _buildItemRow(
              context,
              item,
              showBottomBorder: idx < items.length - 1,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildItemRow(
    BuildContext context,
    _SettingItem item, {
    required bool showBottomBorder,
  }) {
    return AppTdCell(
      leftIconWidget: Container(
        width: 28.r,
        height: 28.r,
        decoration: BoxDecoration(
          color: item.iconColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Icon(item.icon, size: 16.r, color: item.iconColor),
      ),
      title: item.title,
      rightIconWidget: item.trailing,
      arrow: true,
      onTap: item.onTap,
      showBottomBorder: showBottomBorder,
    );
  }

  void _clearCache(BuildContext context) {
    TDToast.showText(context.l10n.commonCacheCleared, context: context);
  }
}

class _SettingItem {
  final IconData icon;
  final Color iconColor;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.trailing,
    this.onTap,
  });
}
