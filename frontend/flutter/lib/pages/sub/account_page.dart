import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../common/i18n/app_l10n.dart';
import '../../common/index.dart';
import '../../provider/auth/auth_provider.dart';
import '../../services/index.dart';

/// 账号设置页（修改密码）
class AccountPage extends ConsumerStatefulWidget {
  const AccountPage({super.key});

  @override
  ConsumerState<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends ConsumerState<AccountPage> {
  final _oldPwdCtrl = TextEditingController();
  final _newPwdCtrl = TextEditingController();
  final _confirmPwdCtrl = TextEditingController();

  bool _oldObscure = true;
  bool _newObscure = true;
  bool _confirmObscure = true;
  bool _saving = false;

  @override
  void dispose() {
    _oldPwdCtrl.dispose();
    _newPwdCtrl.dispose();
    _confirmPwdCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = context.l10n;
    // AppTDInput 无 Form validator，校验改手动（错误经 EasyLoading 提示）
    if (_oldPwdCtrl.text.isEmpty) {
      EasyLoading.showError(l10n.accountCurPwdRequired);
      return;
    }
    if (_newPwdCtrl.text.isEmpty) {
      EasyLoading.showError(l10n.accountNewPwdRequired);
      return;
    }
    if (_newPwdCtrl.text.length < 6) {
      EasyLoading.showError(l10n.accountPwdTooShort);
      return;
    }
    if (_confirmPwdCtrl.text != _newPwdCtrl.text) {
      EasyLoading.showError(l10n.accountPwdMismatch);
      return;
    }
    setState(() => _saving = true);
    try {
      await UserApi.changePassword(
        oldPassword: _oldPwdCtrl.text,
        newPassword: _newPwdCtrl.text,
      );
      EasyLoading.showSuccess(l10n.accountChangeSuccess);
      await Future.delayed(const Duration(seconds: 1));
      await ref.read(authProvider.notifier).logout();
      if (mounted) context.go('/login');
    } catch (_) {
      // 错误已由拦截器提示
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignColors.background,
      appBar: AppTdNavBar(
        title: context.l10n.accountTitle,
        background: DesignColors.primary,
        titleColor: Colors.white,
        showBottomLine: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.all(16.r),
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
                  Text(
                    context.l10n.accountChangePwd,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: DesignColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  _buildPasswordField(
                    label: context.l10n.accountCurPwd,
                    controller: _oldPwdCtrl,
                    obscure: _oldObscure,
                    onToggle: () => setState(() => _oldObscure = !_oldObscure),
                  ),
                  SizedBox(height: 12.h),
                  _buildPasswordField(
                    label: context.l10n.accountNewPwd,
                    controller: _newPwdCtrl,
                    obscure: _newObscure,
                    onToggle: () => setState(() => _newObscure = !_newObscure),
                  ),
                  SizedBox(height: 12.h),
                  _buildPasswordField(
                    label: context.l10n.accountConfirmPwd,
                    controller: _confirmPwdCtrl,
                    obscure: _confirmObscure,
                    onToggle: () =>
                        setState(() => _confirmObscure = !_confirmObscure),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            AppTdButton(
              text: _saving
                  ? context.l10n.commonSubmitting
                  : context.l10n.accountConfirmChange,
              isBlock: true,
              height: 46,
              disabled: _saving,
              onTap: _submit,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 13.sp, color: DesignColors.textMuted),
        ),
        SizedBox(height: 6.h),
        AppTDInput(
          controller: controller,
          hint: label,
          obscure: obscure,
          rightBtn: Icon(
            obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: DesignColors.textDisabled,
            size: 18.r,
          ),
          onBtnTap: onToggle,
        ),
      ],
    );
  }
}
