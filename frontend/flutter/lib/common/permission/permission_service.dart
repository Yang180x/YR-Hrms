/// 权限管理服务层
///
/// 封装 [flutter_permission_wizard] 的三种驱动模式，
/// 统一应用项目设计系统风格。
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_permission_wizard/flutter_permission_wizard.dart';

import '../theme/index.dart';

/// 权限请求服务
///
/// 使用示例：
/// ```dart
/// final result = await PermissionWizardService.request(
///   context: context,
///   request: cameraPermissionRequest(),
/// );
/// if (result is GrantedResult) { /* 已授权 */ }
/// ```
class PermissionWizardService {
  PermissionWizardService._();

  /// 构建项目设计系统主题覆盖
  static WizardTheme _buildTheme() {
    return WizardTheme(
      primaryColor: DesignColors.primary,
      surfaceColor: DesignColors.surface,
      titleStyle: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: DesignColors.textPrimary,
      ),
      contentPadding: EdgeInsets.all(24.r),
      sectionSpacing: 16.h,
      primaryButtonHeight: 48.h,
      secondaryButtonHeight: 40.h,
      containerShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignSize.radiusXl.r),
      ),
      iconSize: 32.r,
      iconContainerSize: 64.r,
      iconContainerRadius: BorderRadius.circular(DesignSize.radiusLg.r),
      iconBackgroundColor: DesignColors.primary.withValues(alpha: 0.1),
      iconColor: DesignColors.primary,
    );
  }

  /// 将项目主题合并到 PermissionRequest 中
  static PermissionRequest _mergeTheme(PermissionRequest request) {
    return PermissionRequest(
      permission: request.permission,
      rationale: request.rationale,
      deniedConfig: request.deniedConfig,
      permanentlyDeniedConfig: request.permanentlyDeniedConfig,
      restrictedConfig: request.restrictedConfig,
      callbacks: request.callbacks,
      skipRationaleIfPreviouslyDenied: request.skipRationaleIfPreviouslyDenied,
      settingsReturnDelay: request.settingsReturnDelay,
      maxRetryAttempts: request.maxRetryAttempts,
      theme: _buildTheme(),
    );
  }

  /// 单权限请求 — 直接调用模式
  ///
  /// [context] BuildContext，用于展示弹窗
  /// [request] 权限请求配置（含 rationale + deniedConfig）
  /// [permanentlyDeniedConfig] 永久拒绝后的引导配置（可选）
  static Future<PermissionWizardResult> request({
    required BuildContext context,
    required PermissionRequest request,
    PermissionDeniedConfig? permanentlyDeniedConfig,
  }) async {
    final merged = PermissionRequest(
      permission: request.permission,
      rationale: request.rationale,
      deniedConfig: request.deniedConfig,
      permanentlyDeniedConfig:
          permanentlyDeniedConfig ?? request.permanentlyDeniedConfig,
      restrictedConfig: request.restrictedConfig,
      callbacks: request.callbacks,
      skipRationaleIfPreviouslyDenied: request.skipRationaleIfPreviouslyDenied,
      settingsReturnDelay: request.settingsReturnDelay,
      maxRetryAttempts: request.maxRetryAttempts,
      theme: _buildTheme(),
    );

    return PermissionWizard.request(context: context, request: merged);
  }

  /// 批量权限请求
  ///
  /// [strategy] 合并解释(combined) 或 逐个询问(sequential)
  /// [rationale] 批量理由说明
  /// [requests] 权限请求列表
  static Future<BatchPermissionWizardResult> requestBatch({
    required BuildContext context,
    required BatchStrategy strategy,
    required PermissionRationale rationale,
    required List<PermissionRequest> requests,
  }) {
    return PermissionWizard.requestBatch(
      context: context,
      request: BatchPermissionRequest(
        strategy: strategy,
        batchRationale: rationale,
        permissions: requests,
        theme: _buildTheme(),
      ),
    );
  }

  /// 构建响应式权限请求 Widget — Builder 模式
  ///
  /// 适合需要实时响应权限状态的场景
  static PermissionWizardBuilder buildRequestWidget({
    required PermissionRequest request,
    required PermissionWizardWidgetBuilder builder,
  }) {
    return PermissionWizardBuilder(
      request: _mergeTheme(request),
      builder: builder,
    );
  }

  /// 创建无 Context Controller — Controller 模式
  ///
  /// 适合 BLoC/Riverpod/Repository 中使用
  static PermissionWizardController createController({
    required PermissionRequest request,
  }) {
    return PermissionWizardController(request: _mergeTheme(request));
  }
}
