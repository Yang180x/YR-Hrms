import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_permission_wizard/flutter_permission_wizard.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../common/i18n/app_l10n.dart';
import '../../common/index.dart';
import '../../env/index.dart';
import '../../provider/auth/auth_provider.dart';
import '../../provider/permission/avatar_provider.dart';
import '../../services/index.dart';

/// 个人资料页
class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  late TextEditingController _nameCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _emailCtrl;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final p = ref.read(authProfileProvider);
    _nameCtrl = TextEditingController(text: p?.name ?? '');
    _phoneCtrl = TextEditingController(text: p?.mobile ?? '');
    _emailCtrl = TextEditingController(text: p?.email ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = context.l10n;
    setState(() => _saving = true);
    try {
      await UserApi.updateProfile({
        'name': _nameCtrl.text.trim(),
        'mobile': _phoneCtrl.text.trim(),
        'email': _emailCtrl.text.trim(),
      });
      // 刷新 profile
      final profile = await UserApi.profile();
      ref.read(authProfileProvider.notifier).setProfile(profile);
      EasyLoading.showSuccess(l10n.profileSaveSuccess);
    } catch (_) {
      // 错误已由拦截器提示
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _showAvatarPicker() async {
    final source = await PhotoPickerSheet.show(context: context);
    if (source == null || !mounted) return;

    late PermissionRequest permissionReq;
    VoidCallback pickAction;

    if (source == ImageSource.camera) {
      permissionReq = cameraPermissionRequest(
        customDescription: context.l10n.profileCameraPermissionDesc,
      );
      pickAction = () => ref.read(avatarImageProvider.notifier).takePhoto();
    } else {
      permissionReq = photoPermissionRequest(
        customDescription: context.l10n.profileGalleryPermissionDesc,
      );
      pickAction = () =>
          ref.read(avatarImageProvider.notifier).pickFromGallery();
    }

    final result = await PermissionWizardService.request(
      context: context,
      request: permissionReq,
    );
    if (result is GrantedResult && mounted) {
      pickAction();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<UserProfile?>(authProfileProvider, (_, profile) {
      if (profile != null && !_saving) {
        _nameCtrl.text = profile.name ?? '';
        _phoneCtrl.text = profile.mobile ?? '';
        _emailCtrl.text = profile.email ?? '';
      }
    });
    final profile = ref.watch(authProfileProvider);
    final avatarState = ref.watch(avatarImageProvider);

    return Scaffold(
      backgroundColor: DesignColors.background,
      appBar: AppTdNavBar(
        title: context.l10n.profileTitle,
        background: DesignColors.primary,
        titleColor: Colors.white,
        showBottomLine: false,
        rightBarItems: [
          TDNavBarItem(
            iconWidget: Text(
              context.l10n.commonSave,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            action: _saving ? null : _save,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.r),
        child: Column(
          children: [
            // 头像
            Center(
              child: Stack(
                children: [
                  _buildAvatar(profile?.avatar, avatarState.imageFile),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: GestureDetector(
                      onTap: _showAvatarPicker,
                      child: Container(
                        padding: EdgeInsets.all(4.r),
                        decoration: BoxDecoration(
                          color: DesignColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2.r),
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          size: 14.r,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            // 基本信息卡
            _buildCard(
              title: context.l10n.profileBasic,
              children: [
                _buildInfoRow(
                  label: context.l10n.profileAccount,
                  value: profile?.username ?? '-',
                ),
                _buildTextField(
                  label: context.l10n.profileName,
                  controller: _nameCtrl,
                  hint: context.l10n.profileNameHint,
                ),
                _buildTextField(
                  label: context.l10n.profilePhone,
                  controller: _phoneCtrl,
                  hint: context.l10n.profilePhoneHint,
                  keyboardType: TextInputType.phone,
                ),
                _buildTextField(
                  label: context.l10n.profileEmail,
                  controller: _emailCtrl,
                  hint: context.l10n.profileEmailHint,
                  keyboardType: TextInputType.emailAddress,
                ),
              ],
            ),
            SizedBox(height: 12.h),

            // 组织信息卡
            _buildCard(
              title: context.l10n.profileOrg,
              children: [
                _buildInfoRow(
                  label: context.l10n.profileDept,
                  value: profile?.deptName ?? '-',
                ),
                _buildInfoRow(
                  label: context.l10n.profilePosition,
                  value: (profile?.positionNames ?? []).join(', '),
                ),
                _buildInfoRow(
                  label: context.l10n.profileRole,
                  value: (profile?.roleNames ?? []).join(', '),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            // 登录信息卡
            _buildCard(
              title: context.l10n.profileLoginInfo,
              children: [
                _buildInfoRow(
                  label: context.l10n.profileLastLogin,
                  value: profile?.lastLogin ?? '-',
                ),
              ],
            ),

            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(String? avatarUrl, File? localImage) {
    return Container(
      width: 80.r,
      height: 80.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: DesignColors.border, width: 2.r),
      ),
      child: ClipOval(
        child: localImage != null
            ? Image.file(localImage, fit: BoxFit.cover)
            : (avatarUrl != null && avatarUrl.isNotEmpty
                  ? Image.network(
                      avatarUrl.startsWith('data:')
                          ? ''
                          : '${AppEnv.apiUrl}$avatarUrl',
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => _defaultAvatarIcon(),
                    )
                  : _defaultAvatarIcon()),
      ),
    );
  }

  Widget _defaultAvatarIcon() => Container(
    color: DesignColors.inputFill,
    child: Icon(Icons.person, size: 40.r, color: DesignColors.textDisabled),
  );

  Widget _buildCard({required String title, required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 8.h),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: DesignColors.textPrimary,
              ),
            ),
          ),
          const Divider(height: 1, color: DesignColors.border),
          ...children,
        ],
      ),
    );
  }

  /// 只读信息行（label 左 / value 右，Trailing 防溢出省略）
  Widget _buildInfoRow({required String label, required String value}) {
    return AppTdCell(
      titleWidget: Text(
        label,
        style: TextStyle(fontSize: 13.sp, color: DesignColors.textMuted),
      ),
      trailingText: value.isEmpty ? '-' : value,
      showBottomBorder: false,
    );
  }

  /// 可编辑字段（AppTDInput 官方样式 + 左 label 对齐）
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return AppTDInput(
      controller: controller,
      hint: hint,
      leftLabel: label,
      leftLabelStyle: TextStyle(fontSize: 13.sp, color: DesignColors.textMuted),
      leftInfoWidth: 72.w,
      keyboardType: keyboardType,
      height: 44,
    );
  }
}
