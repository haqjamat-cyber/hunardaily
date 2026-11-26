import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hunardaily/core/localization/supported_language.dart';
import 'package:hunardaily/data/local/prefs_service.dart';
import 'package:hunardaily/features/settings/app_settings_state.dart';

/// Must be overridden at app startup in `main.dart` (and in tests).
final prefsServiceProvider = Provider<PrefsService>((ref) {
  throw UnimplementedError(
    'prefsServiceProvider must be overridden with a PrefsService instance.',
  );
});

final appSettingsProvider =
    NotifierProvider<AppSettingsController, AppSettingsState>(
  AppSettingsController.new,
);

class AppSettingsController extends Notifier<AppSettingsState> {
  @override
  AppSettingsState build() {
    final prefs = ref.watch(prefsServiceProvider);
    return prefs.loadSettings();
  }

  Future<void> setUiLanguage(UiLanguage language) async {
    if (state.uiLanguage == language) return;
    state = state.copyWith(uiLanguage: language);
    await ref.read(prefsServiceProvider).saveUiLanguage(language);
  }

  Future<void> setLearningPair(LearningPair pair) async {
    if (state.learningPair == pair) return;
    state = state.copyWith(learningPair: pair);
    await ref.read(prefsServiceProvider).saveLearningPair(pair);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (state.themeMode == mode) return;
    state = state.copyWith(themeMode: mode);
    await ref.read(prefsServiceProvider).saveThemeMode(mode);
  }

  Future<void> setFontScale(FontScalePreset preset) async {
    if (state.fontScale == preset) return;
    state = state.copyWith(fontScale: preset);
    await ref.read(prefsServiceProvider).saveFontScale(preset);
  }

  Future<void> acceptLocalDataNotice() async {
    if (state.localDataNoticeAccepted) return;
    state = state.copyWith(localDataNoticeAccepted: true);
    await ref.read(prefsServiceProvider).saveLocalDataNoticeAccepted(true);
  }

  Future<void> resetLocalPreferences() async {
    await ref.read(prefsServiceProvider).clearAllSettings();
    state = const AppSettingsState();
  }
}
