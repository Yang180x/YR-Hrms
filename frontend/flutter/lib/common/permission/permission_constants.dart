/// 权限管理 — 文案与配置常量
library;

import 'package:flutter_permission_wizard/flutter_permission_wizard.dart';

/// 相机权限预设配置
PermissionRequest cameraPermissionRequest({
  String? customTitle,
  String? customDescription,
}) => PermissionRequest(
  permission: Permission.camera,
  rationale: PermissionRationale(
    title: customTitle ?? '需要相机权限',
    description: customDescription ?? '我们需要使用相机来拍摄照片。',
    allowButtonText: '去授权',
    denyButtonText: '暂不',
  ),
  deniedConfig: const PermissionDeniedConfig(
    title: '相机权限已关闭',
    description: '请前往系统设置重新开启相机权限。',
    openSettingsText: '打开设置',
  ),
);

/// 相册权限预设配置
PermissionRequest photoPermissionRequest({
  String? customTitle,
  String? customDescription,
}) => PermissionRequest(
  permission: Permission.photos,
  rationale: PermissionRationale(
    title: customTitle ?? '需要相册权限',
    description: customDescription ?? '我们需要访问您的相册来选择图片。',
    allowButtonText: '去授权',
    denyButtonText: '暂不',
  ),
  deniedConfig: const PermissionDeniedConfig(
    title: '相册权限已关闭',
    description: '请前往系统设置重新开启相册权限。',
    openSettingsText: '打开设置',
  ),
);

/// 麦克风权限预设配置
PermissionRequest microphonePermissionRequest({
  String? customTitle,
  String? customDescription,
}) => PermissionRequest(
  permission: Permission.microphone,
  rationale: PermissionRationale(
    title: customTitle ?? '需要麦克风权限',
    description: customDescription ?? '我们需要使用麦克风进行录音。',
    allowButtonText: '去授权',
    denyButtonText: '暂不',
  ),
  deniedConfig: const PermissionDeniedConfig(
    title: '麦克风权限已关闭',
    description: '请前往系统设置重新开启麦克风权限。',
    openSettingsText: '打开设置',
  ),
);
