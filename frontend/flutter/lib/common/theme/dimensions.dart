import 'package:flutter/material.dart';

/// YR-Hrms 设计系统 — 尺寸/圆角/投影令牌
abstract final class DesignSize {
  DesignSize._();

  // ── 间距（4px 基准） ──
  static const double spaceXs = 4;
  static const double spaceSm = 8;
  static const double spaceMd = 12;
  static const double spaceLg = 16;
  static const double spaceXl = 20;
  static const double spaceXxl = 24;

  // ── 图标尺寸 ──
  static const double iconSm = 16;
  static const double iconMd = 20;
  static const double iconLg = 22;
  static const double iconXl = 24;

  // ── 头像尺寸 ──
  static const double avatarSm = 40;
  static const double avatarMd = 60;
  static const double avatarLg = 80;

  // ── 圆角 ──
  static const double radiusSm = 4;
  static const double radiusMd = 8;
  static const double radiusLg = 10;
  static const double radiusXl = 12;
  static const double radiusXxl = 16;
  static const double radiusFull = 999;
}

/// 投影系统
abstract final class DesignShadow {
  DesignShadow._();

  static List<BoxShadow> card = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.04),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> elevated = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.08),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> floating = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.10),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];
}
