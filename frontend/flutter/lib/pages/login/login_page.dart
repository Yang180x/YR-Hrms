import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../common/i18n/app_l10n.dart';
import '../../common/index.dart';
import '../../provider/auth/auth_provider.dart';
import '../../provider/login/login_provider.dart';
import '../../router/app_router.dart';
import '../../services/index.dart';

/// 登录页
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _usernameController = TextEditingController(text: 'admin');
  final _passwordController = TextEditingController(text: '123456');

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    final l10n = context.l10n;
    // AppTDInput 无 Form validator，校验改手动（错误经 EasyLoading 提示）
    if (_usernameController.text.isEmpty) {
      EasyLoading.showError(l10n.loginUsernameRequired);
      return;
    }
    if (_passwordController.text.isEmpty) {
      EasyLoading.showError(l10n.loginPasswordHint);
      return;
    }

    EasyLoading.show(status: l10n.loginLoading);
    ref.read(loginLoadingProvider.notifier).startLoading();
    try {
      final tokenData = await AuthApi.login(
        username: _usernameController.text,
        password: _passwordController.text,
      );
      await ref.read(authProvider.notifier).login(tokenData);

      // 获取用户信息
      try {
        final profile = await UserApi.profile();
        ref.read(authProfileProvider.notifier).setProfile(profile);
      } catch (_) {
        // 用户信息非必成功
      }

      EasyLoading.showSuccess(l10n.loginSuccess);
      if (mounted) context.go(tabHomePath);
    } on DioException catch (e) {
      // 业务错误已在拦截器中 toast，此处仅处理未预期的异常
      if (e.type != DioExceptionType.badResponse) {
        EasyLoading.showError(l10n.loginNetworkError(message: e.message ?? ''));
      }
    } on Exception catch (e) {
      EasyLoading.showError(l10n.loginNetworkError(message: e.toString()));
    } finally {
      if (mounted) {
        ref.read(loginLoadingProvider.notifier).stopLoading();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginLoading = ref.watch(loginLoadingProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: DesignColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 60.h),

                // ── Brand Header ──
                Center(
                  child: Container(
                    width: 64.r,
                    height: 64.r,
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Icon(
                      Icons.admin_panel_settings_outlined,
                      size: 32.r,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Center(
                  child: Text(
                    'YR-Hrms',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                      color: DesignColors.textPrimary,
                    ),
                  ),
                ),
                SizedBox(height: 4.h),
                Center(
                  child: Text(
                    context.l10n.appSubtitle,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: DesignColors.textDisabled,
                    ),
                  ),
                ),
                SizedBox(height: 40.h),

                // ── 密码登录标题 ──
                Text(
                  context.l10n.loginPwdTab,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: DesignColors.textPrimary,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  context.l10n.loginSubHint,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: DesignColors.textDisabled,
                  ),
                ),
                SizedBox(height: 24.h),

                // ── 登录表单 ──
                _LoginForm(
                  usernameController: _usernameController,
                  passwordController: _passwordController,
                  loginLoading: loginLoading,
                  onLogin: _onLogin,
                ),

                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 登录表单子组件
class _LoginForm extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final bool loginLoading;
  final VoidCallback onLogin;

  const _LoginForm({
    required this.usernameController,
    required this.passwordController,
    required this.loginLoading,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── 账号 ──
          Text(
            context.l10n.loginUsername,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: DesignColors.textSecondary,
            ),
          ),
          SizedBox(height: 8.h),
          AppTDInput(
            controller: usernameController,
            hint: context.l10n.loginUsernameHint,
            leftIcon: Icon(Icons.person_outline, size: 20.r),
            height: 48,
          ),
          SizedBox(height: 20.h),

          // ── 密码 ──
          Text(
            context.l10n.loginPassword,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: DesignColors.textSecondary,
            ),
          ),
          SizedBox(height: 8.h),
          AppTDInput(
            controller: passwordController,
            hint: context.l10n.loginPasswordHint,
            obscure: true,
            leftIcon: Icon(Icons.lock_outline, size: 20.r),
            height: 48,
            onSubmitted: (_) => onLogin(),
          ),
          SizedBox(height: 32.h),

          // ── 登录按钮 ──
          TDButton(
            text: context.l10n.loginBtn,
            iconWidget: loginLoading
                ? Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: TDLoading(
                      size: TDLoadingSize.small,
                      icon: TDLoadingIcon.circle,
                      iconColor: TDTheme.of(context).whiteColor1,
                    ),
                  )
                : null,
            disabled: loginLoading,
            size: TDButtonSize.large,
            type: TDButtonType.fill,
            shape: TDButtonShape.square,
            theme: TDButtonTheme.primary,
            width: double.maxFinite,
            onTap: onLogin,
          ),
        ],
      ),
    );
  }
}
