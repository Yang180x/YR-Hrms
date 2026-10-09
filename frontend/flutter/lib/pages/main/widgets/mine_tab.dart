import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../../common/i18n/app_l10n.dart';
import '../../../common/index.dart';
import '../../../env/index.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../provider/auth/auth_provider.dart';
import '../../../services/index.dart';

/// 我的 Tab
class MineTab extends ConsumerWidget {
  const MineTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStatus = ref.watch(authProvider);
    final profile = ref.watch(authProfileProvider);
    final isLoggedIn = authStatus == AuthStatus.authenticated;

    return Scaffold(
      backgroundColor: DesignColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _UserHeader(isLoggedIn: isLoggedIn, profile: profile),
            SizedBox(height: 12.h),
            _MenuSection(onLogout: () => _handleLogout(context, ref)),
            if (isLoggedIn)
              _LogoutButton(onTap: () => _handleLogout(context, ref)),
          ],
        ),
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(ctx.l10n.commonDialogTitle),
        content: Text(ctx.l10n.mineConfirmLogout),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(ctx.l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(ctx.l10n.commonConfirm),
          ),
        ],
      ),
    );
    if (confirm == true) {
      try {
        await AuthApi.logout();
      } catch (_) {
        // 退出接口可能报错，不影响本地清除
      }
      await ref.read(authProvider.notifier).logout();
      if (context.mounted) {
        TDToast.showText(context.l10n.mineLogoutSuccess, context: context);
        context.go('/login');
      }
    }
  }
}

/// 用户头部
class _UserHeader extends StatelessWidget {
  final bool isLoggedIn;
  final UserProfile? profile;

  const _UserHeader({required this.isLoggedIn, this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2563EB), Color(0xFF1E40AF)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      padding: EdgeInsets.only(
        top: 60.h,
        left: 32.w,
        right: 32.w,
        bottom: 40.h,
      ),
      child: isLoggedIn ? _buildUserInfo(context) : _buildLoginGuide(context),
    );
  }

  Widget _buildLoginGuide(BuildContext context) {
    return InkWell(
      onTap: () => context.go('/login'),
      child: Row(
        children: [
          Container(
            width: 64.r,
            height: 64.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.2),
            ),
            child: Icon(
              Icons.person,
              size: 32.r,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.loginTitle,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  context.l10n.mineLoginHint,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          _buildMiniLoginButton(context),
        ],
      ),
    );
  }

  Widget _buildMiniLoginButton(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/login'),
      child: Container(
        height: 28.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
        ),
        child: Center(
          child: Text(
            context.l10n.loginTitle,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context) {
    final nickname =
        profile?.nickname ??
        profile?.name ??
        profile?.username ??
        context.l10n.mineNotLoggedIn;
    final username = profile?.username;
    final avatarUrl = profile?.avatar;

    return Row(
      children: [
        Container(
          width: 64.r,
          height: 64.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.6),
              width: 2.r,
            ),
          ),
          child: avatarUrl != null && avatarUrl.isNotEmpty
              ? ClipOval(
                  child: Image.network(
                    avatarUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => _defaultAvatar(),
                  ),
                )
              : _defaultAvatar(),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                nickname,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              if (username != null && username.isNotEmpty)
                SizedBox(height: 4.h),
              if (username != null && username.isNotEmpty)
                Text(
                  username,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => context.push('/profile'),
          child: Icon(
            Icons.arrow_forward_ios,
            size: 14.r,
            color: Colors.white.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  Widget _defaultAvatar() {
    return Container(
      color: Colors.grey[200],
      child: Icon(Icons.person, size: 32.r, color: Colors.grey[400]),
    );
  }
}

/// 菜单组（包含常用工具 + 推荐服务）
class _MenuSection extends StatelessWidget {
  final VoidCallback onLogout;

  const _MenuSection({required this.onLogout});

  // 常用工具（key → GoRouter 路径）
  List<_ToolItem> _toolItems(AppLocalizations l10n) => [
    _ToolItem(
      icon: Icons.person_outline,
      label: l10n.workTitleUser,
      route: '/work/user',
    ),
    _ToolItem(
      icon: Icons.work_outline,
      label: l10n.workTitlePosition,
      route: '/work/position',
    ),
    _ToolItem(
      icon: Icons.shield_outlined,
      label: l10n.workTitleRole,
      route: '/work/role',
    ),
    _ToolItem(
      icon: Icons.tune,
      label: l10n.workTitleParams,
      route: '/work/params',
    ),
    _ToolItem(
      icon: Icons.book_outlined,
      label: l10n.workTitleDict,
      route: '/work/dict',
    ),
    _ToolItem(
      icon: Icons.account_tree_outlined,
      label: l10n.workTitleDept,
      route: '/work/dept',
    ),
    _ToolItem(
      icon: Icons.menu_book_outlined,
      label: l10n.workTitleMenu,
      route: '/work/menu',
    ),
    _ToolItem(
      icon: Icons.history,
      label: l10n.workTitleLog,
      route: '/work/log',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildToolsCard(context),
          SizedBox(height: 12.h),
          _buildServicesCard(context),
          SizedBox(height: 12.h),
          // 设置 / 关于
          _MenuGroup(
            items: [
              _MenuItemData(
                icon: Icons.settings_outlined,
                title: l10n.mineSettings,
                route: '/settings',
              ),
              _MenuItemData(icon: Icons.info_outline, title: l10n.mineAbout),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToolsCard(BuildContext context) {
    final l10n = context.l10n;
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
              l10n.mineTools,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: DesignColors.textPrimary,
              ),
            ),
          ),
          const Divider(height: 1, color: DesignColors.border),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.0,
              children: _toolItems(
                l10n,
              ).map((item) => _ToolCard(item: item)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesCard(BuildContext context) {
    final l10n = context.l10n;
    final services = [
      _ServiceItem(
        icon: Icons.language,
        title: l10n.mineOfficialSite,
        route: '',
      ),
      _ServiceItem(
        icon: Icons.feedback_outlined,
        title: l10n.mineFeedback,
        route: '/feedback',
      ),
      _ServiceItem(
        icon: Icons.account_circle_outlined,
        title: l10n.mineProfile,
        route: '/profile',
      ),
      _ServiceItem(
        icon: Icons.manage_accounts_outlined,
        title: l10n.mineAccount,
        route: '/account',
      ),
    ];
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
              l10n.mineServices,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: DesignColors.textPrimary,
              ),
            ),
          ),
          const Divider(height: 1, color: DesignColors.border),
          ...services.asMap().entries.map((e) {
            final idx = e.key;
            final svc = e.value;
            return AppTdCell(
              leftIconWidget: Icon(
                svc.icon,
                size: 20.r,
                color: DesignColors.textMuted,
              ),
              title: svc.title,
              arrow: true,
              showBottomBorder: idx < services.length - 1,
              onTap: () {
                if (svc.route.isEmpty) {
                  TDToast.showText(
                    context.l10n.commonFeatureDeveloping,
                    context: context,
                  );
                } else {
                  context.push(svc.route);
                }
              },
            );
          }),
        ],
      ),
    );
  }
}

class _ToolItem {
  final IconData icon;
  final String label;
  final String route;

  const _ToolItem({
    required this.icon,
    required this.label,
    required this.route,
  });
}

class _ToolCard extends StatelessWidget {
  final _ToolItem item;

  const _ToolCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push(item.route),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 36.r,
            height: 36.r,
            decoration: BoxDecoration(
              color: DesignColors.primaryContainer(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(item.icon, color: DesignColors.primary, size: 18.r),
          ),
          SizedBox(height: 5.h),
          Text(
            item.label,
            style: TextStyle(
              fontSize: 10.sp,
              color: DesignColors.textSecondary,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _ServiceItem {
  final IconData icon;
  final String title;
  final String route;

  const _ServiceItem({
    required this.icon,
    required this.title,
    required this.route,
  });
}

class _MenuItemData {
  final IconData icon;
  final String title;

  /// 点击目标路由；空字符串表示非跳转项（关于 → 版本号 / 其他 → 功能开发中）
  final String route;

  const _MenuItemData({
    required this.icon,
    required this.title,
    this.route = '',
  });
}

class _MenuGroup extends StatelessWidget {
  final List<_MenuItemData> items;

  const _MenuGroup({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
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
        children: items.asMap().entries.map((entry) {
          final idx = entry.key;
          final item = entry.value;
          return AppTdCell(
            leftIconWidget: Icon(
              item.icon,
              size: 20.r,
              color: DesignColors.textSecondary,
            ),
            title: item.title,
            arrow: true,
            showBottomBorder: idx < items.length - 1,
            onTap: () => _onTap(context, item),
          );
        }).toList(),
      ),
    );
  }

  void _onTap(BuildContext context, _MenuItemData item) {
    if (item.route.isNotEmpty) {
      context.push(item.route);
      return;
    }
    // 非跳转项：关于 → 版本号；其余 → 功能开发中
    if (item.title == context.l10n.mineAbout) {
      TDToast.showText(
        '${AppEnv.appName} v${AppEnv.appVersion}',
        context: context,
      );
    } else {
      TDToast.showText(context.l10n.commonFeatureDeveloping, context: context);
    }
  }
}

/// 退出登录按钮
class _LogoutButton extends StatelessWidget {
  final VoidCallback onTap;

  const _LogoutButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 40.h),
      child: SizedBox(
        width: double.infinity,
        height: 44.h,
        child: TDButton(
          text: context.l10n.mineLogout,
          type: TDButtonType.outline,
          theme: TDButtonTheme.primary,
          shape: TDButtonShape.square,
          size: TDButtonSize.medium,
          onTap: onTap,
        ),
      ),
    );
  }
}
