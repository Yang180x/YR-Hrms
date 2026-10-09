/// 权限管理 — 预设 Widget
library;

import 'package:flutter/material.dart';
import 'package:flutter_permission_wizard/flutter_permission_wizard.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../components/index.dart';
import '../theme/index.dart';
import 'permission_constants.dart';

/// 权限按钮类型
enum PermissionButtonType { camera, photos, microphone }

/// 权限请求按钮
///
/// 点击后触发对应权限的请求流程（理由说明 → 系统弹窗 → 拒绝兜底）。
/// 使用 [type] 指定权限类型，[child] 自定义按钮外观。
class PermissionRequestButton extends StatelessWidget {
  final PermissionButtonType type;
  final Widget child;
  final VoidCallback? onGranted;
  final VoidCallback? onDenied;

  const PermissionRequestButton({
    super.key,
    required this.type,
    required this.child,
    this.onGranted,
    this.onDenied,
  });

  PermissionRequest _getRequest() {
    switch (type) {
      case PermissionButtonType.camera:
        return cameraPermissionRequest();
      case PermissionButtonType.photos:
        return photoPermissionRequest();
      case PermissionButtonType.microphone:
        return microphonePermissionRequest();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PermissionWizardBuilder(
      request: _getRequest(),
      builder: (context, status, requestPermission) {
        return GestureDetector(
          onTap: () async {
            final result = await requestPermission();
            if (result is GrantedResult) {
              onGranted?.call();
            } else {
              onDenied?.call();
            }
          },
          child: child,
        );
      },
      autoRequestOnFirstShow: false,
    );
  }
}

/// 权限请求底部面板
///
/// 在底部弹出操作面板，让用户选择"拍照"或"从相册选择"。
/// 适合头像上传等需要二选一的场景。
class PhotoPickerSheet {
  PhotoPickerSheet._();

  /// 显示图片选择底部面板
  ///
  /// 返回选择的来源类型，null 表示取消
  static Future<ImageSource?> show({
    required BuildContext context,
    String title = '更换头像',
  }) async {
    final result = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: DesignColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(DesignSize.radiusXxl.r),
        ),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: DesignColors.textPrimary,
                  ),
                ),
                SizedBox(height: 20.h),
                _sheetOption(
                  ctx,
                  icon: Icons.camera_alt,
                  label: '拍照',
                  source: ImageSource.camera,
                ),
                _sheetOption(
                  ctx,
                  icon: Icons.photo_library_outlined,
                  label: '从相册选择',
                  source: ImageSource.gallery,
                ),
                SizedBox(height: 8.h),
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text(
                    '取消',
                    style: TextStyle(color: DesignColors.textMuted),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    return result;
  }

  static Widget _sheetOption(
    BuildContext ctx, {
    required IconData icon,
    required String label,
    required ImageSource source,
  }) {
    return AppTdCell(
      leftIconWidget: Icon(icon, color: DesignColors.primary),
      title: label,
      showBottomBorder: false,
      onTap: () => Navigator.pop(ctx, source),
    );
  }
}
