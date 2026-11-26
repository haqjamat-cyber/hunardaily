import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hunardaily/core/localization/supported_language.dart';
import 'package:hunardaily/l10n/app_localizations.dart';

void main() {
  group('Multilingual & RTL Architecture', () {
    test('supports English, Hindi, Urdu (RTL), and Bengali', () {
      expect(UiLanguage.values.length, 4);
      expect(UiLanguage.english.isRtl, isFalse);
      expect(UiLanguage.hindi.isRtl, isFalse);
      expect(UiLanguage.bengali.isRtl, isFalse);
      expect(UiLanguage.urdu.isRtl, isTrue);
      expect(UiLanguage.urdu.textDirection, TextDirection.rtl);
    });

    test('lookup returns non-empty core strings for every supported locale', () {
      for (final locale in AppLocalizations.supportedLocales) {
        final l10n = AppLocalizations.lookup(locale);
        expect(l10n.appTitle, isNotEmpty);
        expect(l10n.homeGreeting, isNotEmpty);
        expect(l10n.navHome, isNotEmpty);
        expect(l10n.navCourses, isNotEmpty);
        expect(l10n.navPractice, isNotEmpty);
        expect(l10n.navProfile, isNotEmpty);
        expect(l10n.localStorageNoticeBody, isNotEmpty);
      }
    });

    test('unknown language code safely falls back to English', () {
      expect(UiLanguage.fromCode('xx'), UiLanguage.english);
      expect(UiLanguage.fromCode(null), UiLanguage.english);
    });
  });
}
