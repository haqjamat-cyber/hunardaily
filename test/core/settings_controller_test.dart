import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hunardaily/core/localization/supported_language.dart';
import 'package:hunardaily/data/local/prefs_service.dart';
import 'package:hunardaily/features/settings/app_settings_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppSettingsController', () {
    test(
      'switching interface language persists and never resets learning pair',
      () async {
        SharedPreferences.setMockInitialValues(<String, Object>{});
        final prefs = await SharedPreferences.getInstance();

        final container = ProviderContainer(
          overrides: [
            prefsServiceProvider.overrideWithValue(PrefsService(prefs)),
          ],
        );
        addTearDown(container.dispose);

        final controller = container.read(appSettingsProvider.notifier);

        await controller.setLearningPair(LearningPair.urduToEnglish);
        await controller.acceptLocalDataNotice();
        await controller.setUiLanguage(UiLanguage.bengali);

        final state = container.read(appSettingsProvider);
        expect(state.uiLanguage, UiLanguage.bengali);
        expect(state.learningPair, LearningPair.urduToEnglish);
        expect(state.localDataNoticeAccepted, isTrue);

        final reloaded = PrefsService(prefs).loadSettings();
        expect(reloaded.uiLanguage, UiLanguage.bengali);
        expect(reloaded.learningPair, LearningPair.urduToEnglish);
        expect(reloaded.localDataNoticeAccepted, isTrue);
      },
    );

    test('theme mode, font scale, and reset work cleanly', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final prefs = await SharedPreferences.getInstance();

      final container = ProviderContainer(
        overrides: [
          prefsServiceProvider.overrideWithValue(PrefsService(prefs)),
        ],
      );
      addTearDown(container.dispose);

      final controller = container.read(appSettingsProvider.notifier);
      await controller.setThemeMode(ThemeMode.dark);
      await controller.setFontScale(FontScalePreset.large);

      expect(container.read(appSettingsProvider).themeMode, ThemeMode.dark);
      expect(
        container.read(appSettingsProvider).fontScale,
        FontScalePreset.large,
      );

      await controller.resetLocalPreferences();
      final resetState = container.read(appSettingsProvider);
      expect(resetState.uiLanguage, UiLanguage.english);
      expect(resetState.themeMode, ThemeMode.system);
      expect(resetState.fontScale, FontScalePreset.normal);
    });
  });
}
