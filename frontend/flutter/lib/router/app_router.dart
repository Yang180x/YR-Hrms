import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../common/i18n/app_l10n.dart';
import '../pages/login/login_page.dart';
import '../pages/main/main_page.dart';
import '../pages/main/widgets/home_tab.dart';
import '../pages/main/widgets/mine_tab.dart';
import '../pages/splash/splash_page.dart';
import '../pages/sub/account_page.dart';
import '../pages/sub/feedback_page.dart';
import '../pages/sub/profile_page.dart';
import '../pages/sub/settings_page.dart';
import '../pages/work/work_list_page.dart';
import '../provider/auth/auth_provider.dart';

/// iOS/macOS 平台自适应页面：CupertinoPage 启用原生侧滑返回手势
/// Android/其他平台保持 MaterialPage
Page<void> adaptivePage(Widget child) {
  switch (defaultTargetPlatform) {
    case TargetPlatform.iOS:
    case TargetPlatform.macOS:
      return CupertinoPage(child: child);
    default:
      return MaterialPage(child: child);
  }
}

/// 主 Tab 无过渡动画页面（对齐 Android 底部导航瞬时切换）
Page<void> noTransitionPage(Widget child) => CustomTransitionPage<void>(
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
      transitionsBuilder: (_, __, ___, child) => child,
      child: child,
    );

/// 主 Tab 页路由路径常量
const tabHomePath = '/home';
const tabWorkPath = '/work';
const tabMinePath = '/mine';

/// GoRouter 路由配置
final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final authStatus = ref.read(authProvider);
      final isLoggedIn = authStatus == AuthStatus.authenticated;
      final location = state.matchedLocation;

      // 已登录在 Splash → 直接跳主页，跳过倒计时
      if (isLoggedIn && location == '/splash') {
        return tabHomePath;
      }

      // 未登录且不在 Login / Splash → 跳登录
      if (!isLoggedIn && location != '/login' && location != '/splash') {
        return '/login';
      }

      // 已登录在 Login → 跳主页
      if (isLoggedIn && location == '/login') {
        return tabHomePath;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        pageBuilder: (_, state) => adaptivePage(const SplashPage()),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        pageBuilder: (_, state) => adaptivePage(const LoginPage()),
      ),

      // ── 主框架（3 Tab 保活）──────────────────────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainPage(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: tabHomePath,
                pageBuilder: (context, state) =>
                    noTransitionPage(const HomeTab()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: tabWorkPath,
                pageBuilder: (context, state) =>
                    noTransitionPage(const PlaceholderWorkPage(title: '工作台')),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: tabMinePath,
                pageBuilder: (context, state) =>
                    noTransitionPage(const MineTab()),
              ),
            ],
          ),
        ],
      ),

      // ── 个人中心子页 ────────────────────────────────────────────────────────
      GoRoute(
        path: '/profile',
        name: 'profile',
        pageBuilder: (_, state) => adaptivePage(const ProfilePage()),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        pageBuilder: (_, state) => adaptivePage(const SettingsPage()),
      ),
      GoRoute(
        path: '/account',
        name: 'account',
        pageBuilder: (_, state) => adaptivePage(const AccountPage()),
      ),
      GoRoute(
        path: '/feedback',
        name: 'feedback',
        pageBuilder: (_, state) => adaptivePage(const FeedbackPage()),
      ),

      // ── 工作台管理页 ────────────────────────────────────────────────────────
      GoRoute(
        path: '/work/user',
        name: 'work_user',
        pageBuilder: (_, state) => adaptivePage(const UserListPage()),
      ),
      GoRoute(
        path: '/work/role',
        name: 'work_role',
        pageBuilder: (_, state) => adaptivePage(const RoleListPage()),
      ),
      GoRoute(
        path: '/work/notice',
        name: 'work_notice',
        pageBuilder: (_, state) => adaptivePage(const NoticeListPage()),
      ),
      GoRoute(
        path: '/work/dept',
        name: 'work_dept',
        pageBuilder: (_, state) => adaptivePage(const DeptListPage()),
      ),
      GoRoute(
        path: '/work/position',
        name: 'work_position',
        pageBuilder: (_, state) => adaptivePage(const PositionListPage()),
      ),
      GoRoute(
        path: '/work/menu',
        name: 'work_menu',
        pageBuilder: (context, state) =>
            adaptivePage(PlaceholderWorkPage(title: context.l10n.workTitleMenu)),
      ),
      GoRoute(
        path: '/work/dict',
        name: 'work_dict',
        pageBuilder: (context, state) =>
            adaptivePage(PlaceholderWorkPage(title: context.l10n.workTitleDict)),
      ),
      GoRoute(
        path: '/work/params',
        name: 'work_params',
        pageBuilder: (context, state) =>
            adaptivePage(PlaceholderWorkPage(title: context.l10n.workTitleParams)),
      ),
      GoRoute(
        path: '/work/log',
        name: 'work_log',
        pageBuilder: (context, state) =>
            adaptivePage(PlaceholderWorkPage(title: context.l10n.workTitleLog)),
      ),
      GoRoute(
        path: '/work/config',
        name: 'work_config',
        pageBuilder: (context, state) =>
            adaptivePage(PlaceholderWorkPage(title: context.l10n.workTitleConfig)),
      ),
    ],
  );

  ref.listen(authProvider, (_, _) => router.refresh());
  ref.onDispose(router.dispose);

  return router;
});
