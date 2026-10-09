import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'colors.dart';

/// FastapiAdmin TDesign 主题 — 用 `DesignColors` 构造 `TDThemeData`
///
/// 打通 TDesign 组件与品牌主题：TDesign 组件只认 `TDThemeData`，Material 组件只认 `ThemeData`。
/// 🔴 必须在 `main()` 调用 `TDTheme.needMultiTheme(true)`，并把 light/dark 注入
///    Material 主题 `extensions`（否则 `TDTheme.of(context)` 回退 tdesign 默认主题
///    `#0052d9`，与品牌蓝 `DesignColors.primary = #2563EB` 不一致）。
class AppTdTheme {
  /// 主题数据（返回值 light 自引用，light.dark 指向 dark）
  static TDThemeData get tdThemeData {
    final base = TDThemeData.defaultData();
    final light = base.copyWithTDThemeData(
      'fastapiadmin',
      colorMap: _lightColorMap,
      fontMap: _lightFontMap,
    );
    final dark = (base.dark ?? base).copyWithTDThemeData(
      'fastapiadminDark',
      colorMap: _darkColorMap,
    );
    // 与 TDThemeData.fromJson 同款初始化：late light 需自引用，dark.light 指向浅色主题
    light.light = light;
    light.dark = dark;
    dark.light = light;
    return light;
  }

  /// 浅色品牌蓝 + 语义色板（锚点引用 DesignColors）
  static const Map<String, Color> _lightColorMap = {
    // ── 品牌蓝梯度（主色 #2563EB）──
    'brandColor1': Color(0xFFEFF4FF),
    'brandColor2': Color(0xFFDBE7FE),
    'brandColor3': Color(0xFFBBD1FB),
    'brandColor4': Color(0xFF93B6F8),
    'brandColor5': Color(0xFF6694F4),
    'brandColor6': Color(0xFF4477EF),
    'brandColor7': DesignColors.primary, // #2563EB
    'brandColor8': Color(0xFF1D51C4),
    'brandColor9': Color(0xFF17439F),
    'brandColor10': Color(0xFF12357D),
    // ── 错误 / 警告 / 成功（锚点）──
    'errorColor6': DesignColors.error, // #EF4444
    'warningColor5': DesignColors.warning, // #F97316
    'successColor5': DesignColors.success, // #10B981
    'successColor6': Color(0xFF0EA371), // 深一档
    // ── 灰阶（页面/边框/文字，锚点 DesignColors）──
    'grayColor1': DesignColors.surface, // #FFFFFF
    'grayColor2': DesignColors.background, // #F8FAFC 页面背景 bgColorPage
    'grayColor4': DesignColors.inputFill, // #F1F5F9
    'grayColor5': DesignColors.border, // #E2E8F0
    'grayColor6': Color(0xFFCBD5E1), // 边框 componentBorderColor
    'grayColor7': DesignColors.textDisabled, // #94A3B8
    'grayColor8': Color(0xFF94A3B8),
    'grayColor9': DesignColors.textDisabled, // #94A3B8
    'grayColor10': DesignColors.textMuted, // #64748B
    'grayColor11': DesignColors.textSecondary, // #334155
    'grayColor13': DesignColors.textPrimary, // #1E293B
    'grayColor14': DesignColors.textPrimary, // #1E293B
    // ── 文字（主/次/占位/禁用）──
    'fontGyColor1': DesignColors.textPrimary, // #1E293B
    'fontGyColor2': DesignColors.textSecondary, // #334155
    'fontGyColor3': DesignColors.textMuted, // #64748B
    'fontGyColor4': DesignColors.textDisabled, // #94A3B8
  };

  /// 深色品牌蓝 + 语义色板（暗化版本，锚点 DesignColors.dark*）
  static const Map<String, Color> _darkColorMap = {
    // ── 品牌蓝梯度（深色主色 #5B8DEF）──
    'brandColor1': Color(0xFF0F1B33),
    'brandColor2': Color(0xFF15264A),
    'brandColor3': Color(0xFF1D3565),
    'brandColor4': Color(0xFF264782),
    'brandColor5': Color(0xFF305AA3),
    'brandColor6': Color(0xFF3B6FC8),
    'brandColor7': Color(0xFF5B8DEF),
    'brandColor8': Color(0xFF82A9F3),
    'brandColor9': Color(0xFFA9C5F8),
    'brandColor10': Color(0xFFD0E0FC),
    // ── 错误 / 警告 / 成功（深色亮化）──
    'errorColor6': Color(0xFFFF6F6F),
    'warningColor5': Color(0xFFFFB64D),
    'successColor5': Color(0xFF34D399),
    // ── 灰阶（深色页面/容器/组件）──
    'grayColor9': DesignColors.darkBorder, // #374151 边框 componentBorderColor
    'grayColor11': Color(0xFF4B5563), // 组件描边 componentStrokeColor
    'grayColor13': DesignColors.darkSurface, // #1F2937 容器 bgColorContainer
    'grayColor14': DesignColors.darkBackground, // #111827 页面背景 bgColorPage
    // ── 文字（白字分层）──
    'fontWhColor1': Color(0xFFFFFFFF), // 主
    'fontWhColor2': Color(0xB3FFFFFF), // 次
    'fontWhColor3': Color(0x80FFFFFF), // 占位
    'fontWhColor4': Color(0x4DFFFFFF), // 禁用
  };

  /// TDesign 字体覆盖：fontBodyLarge = 16sp（对齐 `DesignTextStyle.bodyLg` /
  /// `AppTDInput` 默认字号），消除 TDInput 内部 _measureTextWidth 测量偏差
  static final Map<String, Font> _lightFontMap = {
    'fontBodyLarge': Font(size: 16, lineHeight: 24),
  };
}
