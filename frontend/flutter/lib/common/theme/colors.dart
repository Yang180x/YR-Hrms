import 'package:flutter/material.dart';

/// YR-Hrms 设计系统 — 色彩令牌
///
/// 所有色值统一在此定义，页面代码禁止硬编码 Color(0xFF...)。
abstract final class DesignColors {
  DesignColors._();

  // ── 品牌色 ──
  static const Color primary = Color(0xFF2563EB);
  static Color primaryContainer([double opacity = 0.1]) =>
      primary.withValues(alpha: opacity);

  // ── 功能色 ──
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF97316);

  // ── 状态色 ──
  static const Color statusOn = Color(0xFF10B981);
  static const Color statusOff = Color(0xFFEF4444);

  // ── 中性色 ──
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF334155);
  static const Color textMuted = Color(0xFF64748B);
  static const Color textDisabled = Color(0xFF94A3B8);
  static const Color border = Color(0xFFE2E8F0);
  static const Color inputFill = Color(0xFFF1F5F9);
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);

  // ── 暗黑模式色值 ──
  static const Color darkBackground = Color(0xFF111827);
  static const Color darkSurface = Color(0xFF1F2937);
  static const Color darkTextPrimary = Color(0xFFF9FAFB);
  static const Color darkTextMuted = Color(0xFF9CA3AF);
  static const Color darkBorder = Color(0xFF374151);
}
