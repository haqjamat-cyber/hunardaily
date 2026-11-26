import 'package:flutter/material.dart';
import 'package:hunardaily/core/localization/supported_language.dart';

/// Immutable local preferences state for HunarDaily.
/// Interface language ([uiLanguage]) and course language pair ([learningPair])
/// are stored independently so switching app language never alters learning state.
@immutable
class AppSettingsState {
  const AppSettingsState({
    this.uiLanguage = UiLanguage.english,
    this.learningPair = LearningPair.hindiToEnglish,
    this.themeMode = ThemeMode.system,
    this.fontScale = FontScalePreset.normal,
    this.localDataNoticeAccepted = false,
  });

  final UiLanguage uiLanguage;
  final LearningPair learningPair;
  final ThemeMode themeMode;
  final FontScalePreset fontScale;
  final bool localDataNoticeAccepted;

  AppSettingsState copyWith({
    UiLanguage? uiLanguage,
    LearningPair? learningPair,
    ThemeMode? themeMode,
    FontScalePreset? fontScale,
    bool? localDataNoticeAccepted,
  }) {
    return AppSettingsState(
      uiLanguage: uiLanguage ?? this.uiLanguage,
      learningPair: learningPair ?? this.learningPair,
      themeMode: themeMode ?? this.themeMode,
      fontScale: fontScale ?? this.fontScale,
      localDataNoticeAccepted:
          localDataNoticeAccepted ?? this.localDataNoticeAccepted,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppSettingsState &&
        other.uiLanguage == uiLanguage &&
        other.learningPair == learningPair &&
        other.themeMode == themeMode &&
        other.fontScale == fontScale &&
        other.localDataNoticeAccepted == localDataNoticeAccepted;
  }

  @override
  int get hashCode => Object.hash(
        uiLanguage,
        learningPair,
        themeMode,
        fontScale,
        localDataNoticeAccepted,
      );
}
