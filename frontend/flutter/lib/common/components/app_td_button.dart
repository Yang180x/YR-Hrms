import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// 统一按钮封装 — TDesign `TDButton` 全局统一出口（Material ElevatedButton/OutlinedButton/TextButton 平替）
///
/// 抽取「TDButton 矮按钮（如 80×32）默认 medium padding 上下 8（共 16）
/// → 32dp 高内文字区仅 16px，medium 字体 lineHeight ≈ 24 → 文字被垂直裁剪显示不全」的修复：
/// 默认 `padding: EdgeInsets.zero`，调用方无需重复传。
///
/// 用法：
/// ```dart
/// AppTdButton(
///   width: 80, height: 32,
///   text: '拒绝',
///   textStyle: const TextStyle(fontSize: 14),
///   disabled: _isProcessing,
///   onTap: () => ...,
/// )
/// ```
class AppTdButton extends StatelessWidget {
  final String? text;
  final double? width;
  final double? height;
  final TDButtonStyle? style;
  final TextStyle? textStyle;
  final bool disabled;
  final VoidCallback? onTap;
  final TDButtonType type;
  final TDButtonTheme? theme;
  final TDButtonShape shape;
  final TDButtonSize size;
  final EdgeInsetsGeometry? padding;

  /// 处理中 loading（官方 TDLoading 图标，文字保留并列；同时禁用点击）
  final bool loading;

  /// loading 图标颜色（默认白）
  final Color? loadingColor;

  /// 禁用态样式（Material disabledBackgroundColor 等价）
  final TDButtonStyle? disableStyle;

  /// 禁用态文字样式（Material disabledForegroundColor 等价）
  final TextStyle? disableTextStyle;

  /// 左侧自定义图标（优先级高于 [icon]）
  final Widget? iconWidget;

  /// 官方 icon（TDIcons 图标，颜色跟随 style.textColor）
  final IconData? icon;

  /// 渐变背景（官方 TDButton.gradient，替代 ButtonStyle 渐变）
  final Gradient? gradient;

  /// 通栏按钮（官方 isBlock，全宽居中 + 水平 padding 16）
  final bool isBlock;

  const AppTdButton({
    super.key,
    this.text,
    this.width,
    this.height,
    this.style,
    this.textStyle,
    this.disabled = false,
    this.onTap,
    this.type = TDButtonType.fill,
    this.theme,
    this.shape = TDButtonShape.rectangle,
    this.size = TDButtonSize.medium,
    this.padding = EdgeInsets.zero, // ✅ 默认去 padding（矮按钮防文字垂直裁剪）
    this.loading = false,
    this.loadingColor,
    this.disableStyle,
    this.disableTextStyle,
    this.iconWidget,
    this.icon,
    this.gradient,
    this.isBlock = false,
  });

  @override
  Widget build(BuildContext context) {
    return TDButton(
      text: text,
      width: width,
      height: height,
      style: style,
      textStyle: textStyle,
      disableStyle: disableStyle,
      disableTextStyle: disableTextStyle,
      disabled: disabled || loading, // loading 时禁用点击
      onTap: onTap,
      type: type,
      theme: theme,
      shape: shape,
      size: size,
      padding: padding,
      icon: icon,
      gradient: gradient,
      isBlock: isBlock,
      // ✅ 官方 loading：TDLoading 图标（iconWidget 优先于 icon，loading 时替换图标，文字保留）
      iconWidget: loading
          ? TDLoading(
              size: TDLoadingSize.small,
              icon: TDLoadingIcon.circle,
              iconColor: loadingColor ?? Colors.white,
            )
          : iconWidget,
    );
  }
}
