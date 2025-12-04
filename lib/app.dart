import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/router/app_router.dart';
import 'ui/theme/elena_colors.dart';

class ElenaApp extends ConsumerWidget {
  const ElenaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = AppRouter.router;

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,

      // IDIOMA
      locale: const Locale('es'),
      supportedLocales: const [
        Locale('es'),
        Locale('en'),
      ],

      // LOCALIZACIONES OFICIALES
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // TEMA
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: ElenaColors.primary,
        ),
        datePickerTheme: const DatePickerThemeData(
          headerForegroundColor: Colors.white,
          headerBackgroundColor: ElenaColors.primary,
        ),
      ),
    );
  }
}
