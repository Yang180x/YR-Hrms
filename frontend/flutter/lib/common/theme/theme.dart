import 'package:flutter/material.dart';
import 'colors.dart';
import 'dimensions.dart';

/// FastapiAdmin 设计系统 — 字体样式
abstract final class DesignTextStyle {
  DesignTextStyle._();

  // ── 静态样式 ──
  static const TextStyle display = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: DesignColors.textPrimary,
  );

  static const TextStyle headline = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: DesignColors.textPrimary,
  );

  static const TextStyle titleLg = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: DesignColors.textPrimary,
  );

  static const TextStyle titleMd = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: DesignColors.textPrimary,
  );

  static const TextStyle bodyLg = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: DesignColors.textPrimary,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: DesignColors.textSecondary,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: DesignColors.textMuted,
  );

  static const TextStyle tiny = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: DesignColors.textDisabled,
  );

  // ── Theme 上下文样式 ──
  static TextStyle displayOf(BuildContext context) =>
      Theme.of(context).textTheme.headlineLarge ?? display;

  static TextStyle titleLgOf(BuildContext context) =>
      Theme.of(context).textTheme.titleLarge ?? titleLg;

  static TextStyle bodyOf(BuildContext context) =>
      Theme.of(context).textTheme.bodyLarge ?? body;
}

/// 容器装饰工厂
abstract final class DesignDecoration {
  DesignDecoration._();

  /// 标准卡片装饰
  static BoxDecoration card({
    double radius = DesignSize.radiusXl,
    Color color = DesignColors.surface,
    List<BoxShadow>? shadow,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: shadow ?? DesignShadow.card,
    );
  }

  /// 状态标签装饰
  static BoxDecoration statusChip(Color bgColor) {
    return BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(DesignSize.radiusSm),
    );
  }
}
