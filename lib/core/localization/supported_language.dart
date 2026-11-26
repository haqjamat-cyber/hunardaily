import 'package:flutter/material.dart';

/// App Interface Languages (controls menus, buttons, and LTR/RTL layout).
/// Strictly separated from [LearningPair] so changing UI language never
/// resets or alters a learner's enrolled courses or progress.
enum UiLanguage {
  english(
    code: 'en',
    nativeName: 'English',
    englishName: 'English',
    textDirection: TextDirection.ltr,
    isEnabledInMvp: true,
  ),
  hindi(
    code: 'hi',
    nativeName: 'हिन्दी',
    englishName: 'Hindi',
    textDirection: TextDirection.ltr,
    isEnabledInMvp: true,
  ),
  urdu(
    code: 'ur',
    nativeName: 'اردو',
    englishName: 'Urdu',
    textDirection: TextDirection.rtl,
    isEnabledInMvp: true,
  ),
  bengali(
    code: 'bn',
    nativeName: 'বাংলা',
    englishName: 'Bengali',
    textDirection: TextDirection.ltr,
    isEnabledInMvp: true,
  );

  const UiLanguage({
    required this.code,
    required this.nativeName,
    required this.englishName,
    required this.textDirection,
    required this.isEnabledInMvp,
  });

  final String code;
  final String nativeName;
  final String englishName;
  final TextDirection textDirection;
  final bool isEnabledInMvp;

  Locale get locale => Locale(code);
  bool get isRtl => textDirection == TextDirection.rtl;

  static UiLanguage fromCode(String? code) {
    for (final lang in UiLanguage.values) {
      if (lang.code == code) {
        return lang;
      }
    }
    return UiLanguage.english;
  }
}

/// Supported course learning pairs (source language -> target language).
/// Each pair has independently reviewed content rather than blind machine
/// translation across pairs.
enum LearningPair {
  hindiToEnglish(
    id: 'hi_to_en',
    sourceCode: 'hi',
    targetCode: 'en',
    nativeLabel: 'हिन्दी → English',
    englishLabel: 'Hindi to English',
    sourceDirection: TextDirection.ltr,
    targetDirection: TextDirection.ltr,
  ),
  urduToEnglish(
    id: 'ur_to_en',
    sourceCode: 'ur',
    targetCode: 'en',
    nativeLabel: 'اردو ← English',
    englishLabel: 'Urdu to English',
    sourceDirection: TextDirection.rtl,
    targetDirection: TextDirection.ltr,
  ),
  bengaliToEnglish(
    id: 'bn_to_en',
    sourceCode: 'bn',
    targetCode: 'en',
    nativeLabel: 'বাংলা → English',
    englishLabel: 'Bengali to English',
    sourceDirection: TextDirection.ltr,
    targetDirection: TextDirection.ltr,
  );

  const LearningPair({
    required this.id,
    required this.sourceCode,
    required this.targetCode,
    required this.nativeLabel,
    required this.englishLabel,
    required this.sourceDirection,
    required this.targetDirection,
  });

  final String id;
  final String sourceCode;
  final String targetCode;
  final String nativeLabel;
  final String englishLabel;
  final TextDirection sourceDirection;
  final TextDirection targetDirection;

  static LearningPair fromId(String? id) {
    for (final pair in LearningPair.values) {
      if (pair.id == id) {
        return pair;
      }
    }
    return LearningPair.hindiToEnglish;
  }
}

/// Accessible in-app reading text size presets.
enum FontScalePreset {
  small(key: 'small', factor: 0.9),
  normal(key: 'normal', factor: 1.0),
  large(key: 'large', factor: 1.15),
  extraLarge(key: 'extra_large', factor: 1.3);

  const FontScalePreset({required this.key, required this.factor});

  final String key;
  final double factor;

  static FontScalePreset fromKey(String? key) {
    for (final preset in FontScalePreset.values) {
      if (preset.key == key) {
        return preset;
      }
    }
    return FontScalePreset.normal;
  }
}
