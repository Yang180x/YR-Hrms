import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../../common/i18n/app_l10n.dart';
import '../../../common/index.dart';
import '../../../l10n/generated/app_localizations.dart';

/// 首页 Tab
class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  // 快捷导航（route 字段对应 GoRouter 路径）
  List<_NavItem> _navItems(AppLocalizations l10n) => [
    _NavItem(
      icon: Icons.person_outline,
      color: const Color(0xFF4D7FFF),
      bgColor: const Color(0xFFEEF2FF),
      title: l10n.workTitleUser,
      route: '/work/user',
    ),
    _NavItem(
      icon: Icons.shield_outlined,
      color: const Color(0xFF8A2BE2),
      bgColor: const Color(0xFFF3E8FF),
      title: l10n.workTitleRole,
      route: '/work/role',
    ),
    _NavItem(
      icon: Icons.notifications_outlined,
      color: const Color(0xFFFF9500),
      bgColor: const Color(0xFFFFF7E8),
      title: l10n.workTitleNotice,
      route: '/work/notice',
    ),
    _NavItem(
      icon: Icons.settings_outlined,
      color: const Color(0xFF5AC8FA),
      bgColor: const Color(0xFFE8F8FF),
      title: l10n.workTitleConfig,
      route: '/work/config',
    ),
  ];

  // 统计数据
  List<_StatItem> _visitStats(AppLocalizations l10n) => [
    _StatItem(
      icon: Icons.people_alt_outlined,
      label: l10n.statVisitors,
      value: '1,234',
      valueColor: const Color(0xFFFF9500),
    ),
    _StatItem(
      icon: Icons.remove_red_eye_outlined,
      label: l10n.statViews,
      value: '5,678',
      valueColor: const Color(0xFF10B981),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final navItems = _navItems(l10n);
    final visitStats = _visitStats(l10n);

    // 首页蓝顶 → AppTdNavBar（自带 AnnotatedRegion：蓝底自动浅色状态栏图标）
    return Scaffold(
      backgroundColor: DesignColors.background,
      appBar: AppTdNavBar(
        title: l10n.tabHome,
        background: DesignColors.primary,
        titleColor: Colors.white,
        showBottomLine: false,
        showBack: false,
        rightBarItems: [
          TDNavBarItem(
            iconWidget: const Icon(
              Icons.notifications_outlined,
              color: Colors.white,
            ),
            action: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBanner(),
            SizedBox(height: 12.h),
            _buildNavGrid(navItems),
            SizedBox(height: 12.h),
            _buildNoticeBar(context),
            SizedBox(height: 12.h),
            _buildStatsGrid(visitStats),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  // ── 品牌 Banner ──────────────────────────────────────────────────────────
  Widget _buildBanner() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        height: 160.h,
        color: DesignColors.primary,
        alignment: Alignment.center,
        child: Image.asset(
          'assets/images/yr_hrms_logo.png',
          fit: BoxFit.contain,
          height: 150.h,
        ),
      ),
    );
  }

  // ── 快捷导航 ──────────────────────────────────────────────────────────────
  Widget _buildNavGrid(List<_NavItem> navItems) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: navItems
            .map((item) => Expanded(child: _NavCard(item: item)))
            .toList(),
      ),
    );
  }

  // ── 通知公告 ──────────────────────────────────────────────────────────────
  Widget _buildNoticeBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7E8),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: const Color(0xFFFF9500).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Color(0xFFFF9500),
            size: 16,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              context.l10n.noticeContent,
              style: TextStyle(fontSize: 12.sp, color: const Color(0xFFBB7500)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 4.w),
          const Icon(Icons.chevron_right, color: Color(0xFFFF9500), size: 16),
        ],
      ),
    );
  }

  // ── 数据统计 ──────────────────────────────────────────────────────────────
  Widget _buildStatsGrid(List<_StatItem> visitStats) {
    return Row(
      children: visitStats.asMap().entries.map((e) {
        final stat = e.value;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              left: e.key == 0 ? 0 : 5.w,
              right: e.key == 0 ? 5.w : 0,
            ),
            child: _StatsCard(stat: stat),
          ),
        );
      }).toList(),
    );
  }
}

// ── 子组件 ────────────────────────────────────────────────────────────────────

class _NavItem {
  final IconData icon;
  final Color color;
  final Color bgColor;
  final String title;
  final String route;

  const _NavItem({
    required this.icon,
    required this.color,
    required this.bgColor,
    required this.title,
    required this.route,
  });
}

class _NavCard extends StatelessWidget {
  final _NavItem item;

  const _NavCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push(item.route),
      borderRadius: BorderRadius.circular(10.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44.r,
              height: 44.r,
              decoration: BoxDecoration(
                color: item.bgColor,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(item.icon, color: item.color, size: 22.r),
            ),
            SizedBox(height: 6.h),
            Text(
              item.title,
              style: TextStyle(
                fontSize: 11.sp,
                color: DesignColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem {
  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.valueColor,
  });
}

class _StatsCard extends StatelessWidget {
  final _StatItem stat;

  const _StatsCard({required this.stat});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
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
      child: Row(
        children: [
          Icon(stat.icon, color: stat.valueColor, size: 32.r),
          SizedBox(width: 10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                stat.label,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: DesignColors.textMuted,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                stat.value,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: stat.valueColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
