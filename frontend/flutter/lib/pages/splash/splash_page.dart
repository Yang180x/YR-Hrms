import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../common/i18n/app_l10n.dart';
import '../../common/index.dart';
import '../../provider/splash/splash_provider.dart';

/// 启动页
class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(splashProvider.notifier).startCountdown(() {
        if (mounted) {
          context.go('/login');
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final countdown = ref.watch(splashProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      // splash 蓝渐变底 → 白色状态栏图标；系统导航栏白底深色图标（与 global.dart 默认一致）
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF2563EB), Color(0xFF1E40AF)],
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 3),
                Text(
                  'FastapiAdmin',
                  style: DesignTextStyle.display.copyWith(color: Colors.white),
                ),
                SizedBox(height: DesignSize.spaceSm.h),
                Text(
                  context.l10n.splashSubtitle,
                  style: DesignTextStyle.body.copyWith(color: Colors.white70),
                ),
                const Spacer(flex: 2),
                Text(
                  context.l10n.splashSkip(count: countdown),
                  style: DesignTextStyle.caption.copyWith(
                    color: Colors.white54,
                  ),
                ),
                SizedBox(height: DesignSize.spaceXxl.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
