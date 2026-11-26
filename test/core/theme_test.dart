import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hunardaily/core/localization/supported_language.dart';
import 'package:hunardaily/core/theme/app_colors.dart';
import 'package:hunardaily/core/theme/app_theme.dart';
import 'package:hunardaily/core/theme/app_typography.dart';

void main() {
  group('HunarDaily Theme & Script Typography', () {
    test('light theme uses Teal primary and Warm Off-White scaffold', () {
      final light = AppTheme.light(UiLanguage.english);
      expect(light.brightness, Brightness.light);
      expect(light.colorScheme.primary, AppColors.lightPrimary);
      expect(light.scaffoldBackgroundColor, AppColors.lightBackground);
    });

    test('dark theme uses Dark Slate scaffold and bright Teal primary', () {
      final dark = AppTheme.dark(UiLanguage.english);
      expect(dark.brightness, Brightness.dark);
      expect(dark.colorScheme.primary, AppColors.darkPrimary);
      expect(dark.scaffoldBackgroundColor, AppColors.darkBackground);
    });

    test('Urdu script gets increased line height for clean diacritic spacing', () {
      expect(
        AppTypography.lineHeightFor(UiLanguage.urdu),
        greaterThan(AppTypography.lineHeightFor(UiLanguage.english)),
      );
    });
  });
}
