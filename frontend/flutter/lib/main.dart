import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'common/theme/index.dart';
import 'global.dart';
import 'l10n/generated/app_localizations.dart';
import 'provider/locale/locale_provider.dart';
import 'router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 启用多主题：TDTheme.of(context) 从 Theme.extensions[TDThemeData] 取品牌主题
  // （否则恒返回 tdesign 默认主题 #0052d9，与品牌蓝 #2563EB 不一致）
  TDTheme.needMultiTheme(true);
  await Global.init();

  // 复用 Global.init() 中预热过的容器（auth 状态/用户信息已读入内存），
  // 避免 runApp 后再触发 SharedPreferences IO
  runApp(
    UncontrolledProviderScope(
      container: Global.container,
      child: const App(),
    ),
  );
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final td = AppTdTheme.tdThemeData;

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return TDTheme(
          data: td,
          child: MaterialApp.router(
            title: 'FastapiAdmin',
            debugShowCheckedModeBanner: false,
            // i18n：语言状态 + 本地化代理（见 lib/provider/locale + lib/l10n/）
            locale: ref.watch(localeProvider),
            supportedLocales: LocaleNotifier.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            routerConfig: router,
            builder: EasyLoading.init(),
            // TDesign 主题注入 Material extensions：多主题下 TDTheme.of(context)
            // 从 Theme.extensions[TDThemeData] 取品牌主题（AppTdTheme.tdThemeData）
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: DesignColors.primary,
                primary: DesignColors.primary,
                error: DesignColors.error,
                surface: DesignColors.surface,
              ),
              scaffoldBackgroundColor: DesignColors.background,
              appBarTheme: const AppBarTheme(
                backgroundColor: DesignColors.surface,
                surfaceTintColor: Colors.transparent,
                centerTitle: true,
                elevation: 0,
                scrolledUnderElevation: 0.5,
              ),
              bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                backgroundColor: DesignColors.surface,
                selectedItemColor: DesignColors.primary,
                unselectedItemColor: DesignColors.textDisabled,
                elevation: 0,
              ),
              dividerTheme: const DividerThemeData(
                color: DesignColors.border,
                thickness: 1,
                space: 0,
              ),
              // iOS/macOS 使用 Cupertino 过渡动画（配合 adaptivePage 启用原生侧滑返回）
              pageTransitionsTheme: const PageTransitionsTheme(
                builders: {
                  TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                  TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
                },
              ),
            ).copyWith(extensions: [td.light]),
          ),
        );
      },
    );
  }
}
