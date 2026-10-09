import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../theme/index.dart';

/// 统一导航栏 — 封装 TDesign `TDNavBar`，作为项目导航栏通用基座。
///
/// 设计契约（统一品牌样式，替代各页面的 Material AppBar）：
/// - 高 44dp、白底、`centerTitle` 可控（默认居中，首页等左对齐传 false）
/// - 左：可选返回按钮（`showBack`，首页 Tab 页传 false 不显示）
/// - 中：`titleWidget` 优先，否则 `title` 文案（17sp w500 深黑）
/// - 右：`rightBarItems`（TDNavBarItem，22dp 图标 + 统一间距 `DesignSize.spaceXxl`）
/// - 状态栏图标亮度：白底 → 深色图标
///
/// ⚠️ 已知坑：TDNavBar.preferredSize = Size.fromHeight(height) 只含自身高度，
///   不含 belowTitleWidget —— 不要把大块内容放 belowTitleWidget（会溢出裁剪），
///   下方内容（如 TabBar）放 Scaffold body 顶部独立灰底。
///
/// 用法：`appBar: AppTdNavBar(title: 'xxx')`；
///       首页无返回：`appBar: AppTdNavBar(titleWidget: ..., showBack: false, centerTitle: false)`
class AppTdNavBar extends StatelessWidget implements PreferredSizeWidget {
  /// 标题文案（与 [titleWidget] 二选一，titleWidget 优先）
  final String? title;

  /// 标题控件（优先于 [title]）
  final Widget? titleWidget;

  /// 标题颜色
  final Color titleColor;

  /// 返回按钮图标颜色（默认 null → 跟随主题 textPrimary；蓝底导航传白色）
  final Color? backIconColor;

  /// 背景色（默认白）
  final Color background;

  /// 是否居中标题（默认居中；首页等左对齐传 false）
  final bool centerTitle;

  /// 左侧返回按钮（默认 true；首页 Tab 页传 false）
  final bool showBack;

  /// 返回回调（默认 Navigator.maybePop）
  final VoidCallback? onBack;

  /// 左侧操作项（TDNavBarItem；如扫码图标；showBack 时返回按钮在其前）
  final List<TDNavBarItem>? leftBarItems;

  /// 右侧操作项（TDNavBarItem）
  final List<TDNavBarItem>? rightBarItems;

  /// 导航栏高度（默认 44dp，对齐 Android layout_header dimen_44）
  final double height;

  /// 底部是否显示分割线（默认 `DesignColors.border` 0.5dp）
  final bool showBottomLine;

  /// 标题外边距（TDNavBar middleSpacing，默认 16；左对齐贴左传 0）
  final double titleMargin;

  /// 导航栏内容 padding（默认 null → 水平 16 对称；贴左时传 `EdgeInsets.only(right: spaceLg)`）
  final EdgeInsetsGeometry? contentPadding;

  /// 状态栏图标亮度（默认 null → 根据 [background] 亮度自动推断：白底→深色图标，深底→浅色图标）
  final Brightness? statusBarIconBrightness;

  const AppTdNavBar({
    super.key,
    this.title,
    this.titleWidget,
    this.titleColor = DesignColors.textPrimary,
    this.backIconColor,
    this.background = Colors.white,
    this.centerTitle = true,
    this.showBack = true,
    this.onBack,
    this.leftBarItems,
    this.rightBarItems,
    this.height = 44, // 对齐 Android layout_header dimen_44
    this.showBottomLine = true,
    this.titleMargin = 16,
    this.contentPadding,
    this.statusBarIconBrightness,
  }) : assert(
         title != null || titleWidget != null,
         'AppTdNavBar: title 或 titleWidget 至少提供一个',
       );

  @override
  // ⚠️ 必须计入底部 0.5dp 分割线：Scaffold 按 preferredSize 分配 appBar 区域，
  //   实际渲染为 TDNavBar(height) + 分割线(0.5) → 只声明 height 会导致底部溢出「露底」
  Size get preferredSize =>
      Size.fromHeight(height + (showBottomLine ? 0.5 : 0));

  @override
  Widget build(BuildContext context) {
    // 状态栏图标亮度：白底 → 深色图标
    //   🔴 AnnotatedRegion 显式声明，避免从「浅色图标页」（如橙/蓝渐变头
    //      AnnotatedRegion 强制白字）返回/切换后，框架重新解析状态栏样式时找不到
    //      本页声明 → 残留浅色图标 → 白底导航栏上白色图标不可见
    final iconBrightness =
        statusBarIconBrightness ??
        (background.computeLuminance() > 0.5
            ? Brightness.dark
            : Brightness.light);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: iconBrightness,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TDNavBar(
            height: height,
            backgroundColor: background,
            centerTitle: centerTitle,
            titleMargin: titleMargin,
            padding:
                contentPadding ??
                const EdgeInsets.symmetric(
                  horizontal: DesignSize.spaceLg,
                  vertical: 0,
                ),
            useDefaultBack: showBack, // showBack 才显示默认返回按钮
            backIconColor: backIconColor ?? titleColor,
            onBack: onBack,
            title: title,
            titleColor: titleColor,
            titleWidget: titleWidget,
            titleFont: Font(
              size: 17,
              lineHeight: 24,
            ), // 17sp 对齐 Android notosans_medium（非 const，勿加 const）
            titleFontWeight: FontWeight.w500,
            leftBarItems: leftBarItems,
            rightBarItems: rightBarItems,
          ),
          // 底部 0.5dp 分割线
          if (showBottomLine)
            Container(height: 0.5, color: DesignColors.border),
        ],
      ),
    );
  }
}

/// 右侧导航栏图标项 — 统一 22dp + 间距 `DesignSize.spaceXxl`（按钮间距一致）
class AppNavBarIcon {
  /// 图标资源
  final String asset;

  /// 点击回调
  final VoidCallback onTap;

  /// 可选：图标上方叠加 badge（如消息红点）
  final Widget? badge;

  /// 可选：图标左侧间距（默认 `DesignSize.spaceXxl`，需要自定义时传入）
  final EdgeInsetsGeometry padding;

  const AppNavBarIcon({
    required this.asset,
    required this.onTap,
    this.badge,
    this.padding = const EdgeInsets.only(left: DesignSize.spaceXxl, right: 0),
  });

  /// 转换为 TDNavBarItem（统一 22dp 图标 + 可选 left 间距，badge 用 Stack 叠加）
  TDNavBarItem toTdItem() => TDNavBarItem(
    iconWidget: SizedBox(
      width: 22,
      height: 22,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Image.asset(asset, width: 22, height: 22, fit: BoxFit.contain),
          if (badge != null) badge!,
        ],
      ),
    ),
    action: onTap,
    padding: padding,
  );
}
