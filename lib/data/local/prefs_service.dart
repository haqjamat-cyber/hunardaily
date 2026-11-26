import 'package:flutter/material.dart';
import 'package:hunardaily/core/localization/supported_language.dart';
import 'package:hunardaily/features/settings/app_settings_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Lightweight on-device key-value store for instant startup theme,
/// interface language, and reading accessibility preferences.
class PrefsService {
  const PrefsService(this._prefs);

  final SharedPreferences _prefs;

  static const String _keyUiLocale = 'hd_ui_locale';
  static const String _keyLearningPair = 'hd_learning_pair';
  static const String _keyThemeMode = 'hd_theme_mode';
  static const String _keyFontScale = 'hd_font_scale';
  static const String _keyLocalNoticeAccepted = 'hd_local_notice_accepted';

  AppSettingsState loadSettings() {
    return AppSettingsState(
      uiLanguage: UiLanguage.fromCode(_prefs.getString(_keyUiLocale)),
      learningPair: LearningPair.fromId(_prefs.getString(_keyLearningPair)),
      themeMode: _decodeThemeMode(_prefs.getString(_keyThemeMode)),
      fontScale: FontScalePreset.fromKey(_prefs.getString(_keyFontScale)),
      localDataNoticeAccepted: _prefs.getBool(_keyLocalNoticeAccepted) ?? false,
    );
  }

  Future<void> saveUiLanguage(UiLanguage language) async {
    await _prefs.setString(_keyUiLocale, language.code);
  }

  Future<void> saveLearningPair(LearningPair pair) async {
    await _prefs.setString(_keyLearningPair, pair.id);
  }

  Future<void> saveThemeMode(ThemeMode mode) async {
    await _prefs.setString(_keyThemeMode, _encodeThemeMode(mode));
  }

  Future<void> saveFontScale(FontScalePreset preset) async {
    await _prefs.setString(_keyFontScale, preset.key);
  }

  Future<void> saveLocalDataNoticeAccepted(bool accepted) async {
    await _prefs.setBool(_keyLocalNoticeAccepted, accepted);
  }

  Future<void> clearAllSettings() async {
    await _prefs.remove(_keyUiLocale);
    await _prefs.remove(_keyLearningPair);
    await _prefs.remove(_keyThemeMode);
    await _prefs.remove(_keyFontScale);
    await _prefs.remove(_keyLocalNoticeAccepted);
  }

  static String _encodeThemeMode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  static ThemeMode _decodeThemeMode(String? value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }
}
