import 'package:flutter/material.dart';
import 'package:hunardaily/core/localization/supported_language.dart';

/// Builds script-aware typography so Devanagari, Bengali, Urdu (RTL), and
/// English render cleanly without clipped diacritics or cramped line heights.
class AppTypography {
  const AppTypography._();

  /// Returns an appropriate line height multiplier per interface script.
  /// Urdu requires extra vertical breathing room so dots and marks never collide.
  static double lineHeightFor(UiLanguage language) {
    switch (language) {
      case UiLanguage.urdu:
        return 1.9;
      case UiLanguage.hindi:
      case UiLanguage.bengali:
        return 1.55;
      case UiLanguage.english:
        return 1.4;
    }
  }

  /// System-safe Noto fallback chain present across Android devices.
  static List<String> fontFallbacksFor(UiLanguage language) {
    switch (language) {
      case UiLanguage.urdu:
        return const [
          'Noto Naskh Arabic',
          'Noto Nastaliq Urdu',
          'Noto Sans',
          'Roboto',
        ];
      case UiLanguage.hindi:
        return const ['Noto Sans Devanagari', 'Noto Sans', 'Roboto'];
      case UiLanguage.bengali:
        return const ['Noto Sans Bengali', 'Noto Sans', 'Roboto'];
      case UiLanguage.english:
        return const ['Noto Sans', 'Roboto'];
    }
  }

  static TextTheme buildTextTheme({
    required UiLanguage language,
    required Color onSurface,
    required Color onSurfaceMuted,
  }) {
    final lineHeight = lineHeightFor(language);
    final fallbacks = fontFallbacksFor(language);

    TextStyle style({
      required double size,
      required FontWeight weight,
      Color? color,
      double? customHeight,
    }) {
      return TextStyle(
        fontSize: size,
        fontWeight: weight,
        color: color ?? onSurface,
        height: customHeight ?? lineHeight,
        fontFamilyFallback: fallbacks,
      );
    }

    return TextTheme(
      headlineMedium: style(size: 24, weight: FontWeight.w700),
      headlineSmall: style(size: 20, weight: FontWeight.w700),
      titleLarge: style(size: 18, weight: FontWeight.w700),
      titleMedium: style(size: 16, weight: FontWeight.w600),
      titleSmall: style(size: 14, weight: FontWeight.w600),
      bodyLarge: style(size: 16, weight: FontWeight.w400),
      bodyMedium: style(size: 14, weight: FontWeight.w400),
      bodySmall: style(
        size: 12,
        weight: FontWeight.w400,
        color: onSurfaceMuted,
      ),
      labelLarge: style(size: 14, weight: FontWeight.w600),
      labelMedium: style(
        size: 12,
        weight: FontWeight.w600,
        color: onSurfaceMuted,
      ),
    );
  }
}
