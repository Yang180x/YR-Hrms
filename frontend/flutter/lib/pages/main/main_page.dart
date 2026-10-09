import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../common/i18n/app_l10n.dart';

/// 主页（底部导航框架）
///
/// 接收 StatefulNavigationShell，由 StatefulShellRoute.indexedStack 注入。
/// 各 Tab 页由 GoRouter branches 管理，IndexedStack 保活不销毁重建。
class MainPage extends ConsumerWidget {
  const MainPage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: TDBottomTabBar(
        TDBottomTabBarBasicType.iconText,
        currentIndex: navigationShell.currentIndex,
        useSafeArea: true,
        navigationTabs: [
          TDBottomTabBarTabConfig(
            tabText: context.l10n.tabHome,
            selectedIcon: const Icon(Icons.home),
            unselectedIcon: const Icon(Icons.home_outlined),
            onTap: () => _onTabTap(0),
          ),
          TDBottomTabBarTabConfig(
            tabText: context.l10n.tabWork,
            selectedIcon: const Icon(Icons.work),
            unselectedIcon: const Icon(Icons.work_outline),
            onTap: () => _onTabTap(1),
          ),
          TDBottomTabBarTabConfig(
            tabText: context.l10n.tabMine,
            selectedIcon: const Icon(Icons.person),
            unselectedIcon: const Icon(Icons.person_outline),
            onTap: () => _onTabTap(2),
          ),
        ],
      ),
    );
  }

  void _onTabTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
