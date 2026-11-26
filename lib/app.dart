import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hunardaily/core/theme/app_theme.dart';
import 'package:hunardaily/features/settings/app_settings_controller.dart';
import 'package:hunardaily/features/shell/app_shell.dart';
import 'package:hunardaily/l10n/app_localizations.dart';

class HunarDailyApp extends ConsumerWidget {
  const HunarDailyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    final uiLanguage = settings.uiLanguage;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      locale: uiLanguage.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      theme: AppTheme.light(uiLanguage),
      darkTheme: AppTheme.dark(uiLanguage),
      themeMode: settings.themeMode,
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);
        final combinedScale = mediaQuery.textScaler.scale(1.0) *
            settings.fontScale.factor;
        final clampedScale = combinedScale.clamp(0.85, 1.6);

        return MediaQuery(
          data: mediaQuery.copyWith(
            textScaler: TextScaler.linear(clampedScale),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: const AppShell(),
    );
  }
}
