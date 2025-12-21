import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:zestinme/core/localization/app_localizations.dart' as legacy;
import 'package:zestinme/l10n/app_localizations.dart' as new_l10n;
import 'package:zestinme/core/localization/locale_provider.dart';
import 'routes/app_router.dart';
import 'theme/app_theme.dart';
import 'theme/theme_provider.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeModeProvider);
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      routerConfig: router,
      title: 'ZestInMe',
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);
        // Calculate the current scale factor
        final scale = mediaQuery.textScaler.scale(1.0).clamp(1.0, 1.4);
        return MediaQuery(
          data: mediaQuery.copyWith(textScaler: TextScaler.linear(scale)),
          child: child!,
        );
      },
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      localizationsDelegates: const [
        legacy.AppLocalizations.delegate,
        new_l10n.AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: new_l10n.AppLocalizations.supportedLocales,
      locale: locale,
    );
  }
}
