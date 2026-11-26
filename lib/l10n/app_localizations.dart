import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hunardaily/l10n/app_localizations_bn.dart';
import 'package:hunardaily/l10n/app_localizations_en.dart';
import 'package:hunardaily/l10n/app_localizations_hi.dart';
import 'package:hunardaily/l10n/app_localizations_ur.dart';

/// Type-safe interface localization contract for HunarDaily.
/// Backed by synchronized ARB source files in `lib/l10n/app_*.arb`.
abstract class AppLocalizations {
  const AppLocalizations(this.localeName);

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    final instance = Localizations.of<AppLocalizations>(
      context,
      AppLocalizations,
    );
    assert(
      instance != null,
      'AppLocalizations not found in widget tree. Ensure AppLocalizations.delegate is registered.',
    );
    return instance!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
    Locale('ur'),
    Locale('bn'),
  ];

  static AppLocalizations lookup(Locale locale) {
    switch (locale.languageCode) {
      case 'hi':
        return const AppLocalizationsHi();
      case 'ur':
        return const AppLocalizationsUr();
      case 'bn':
        return const AppLocalizationsBn();
      case 'en':
      default:
        return const AppLocalizationsEn();
    }
  }

  String get appTitle;
  String get navHome;
  String get navCourses;
  String get navPractice;
  String get navProfile;
  String get homeGreeting;
  String get homeSubtitle;
  String get offlineGuestBadge;
  String get quickLanguageTitle;
  String get quickLanguageHint;
  String get activeCoursePairLabel;
  String get independentPairNote;
  String get localStorageNoticeTitle;
  String get localStorageNoticeBody;
  String get localStorageNoticeAcknowledge;
  String get localStorageNoticeConfirmed;
  String get roadmapTitle;
  String get roadmapModule1;
  String get roadmapModule2;
  String get roadmapModule3;
  String get roadmapModule4;
  String get roadmapModule5;
  String get coursesTitle;
  String get coursesSubtitle;
  String get coursesComingSoonNote;
  String get moduleVocab;
  String get moduleTyping;
  String get moduleQuizzes;
  String get moduleGk;
  String get moduleDigitalSkills;
  String get moduleReadingWriting;
  String get levelTags;
  String get practiceTitle;
  String get practiceSubtitle;
  String get practiceTypingCardTitle;
  String get practiceTypingCardDesc;
  String get practiceQuizCardTitle;
  String get practiceQuizCardDesc;
  String get settingsTitle;
  String get guestModeHeading;
  String get guestModeSubheading;
  String get sectionInterfaceLanguage;
  String get sectionLearningPair;
  String get sectionAppearance;
  String get themeSystem;
  String get themeLight;
  String get themeDark;
  String get sectionTextSize;
  String get textSizeSmall;
  String get textSizeNormal;
  String get textSizeLarge;
  String get textSizeExtraLarge;
  String get bidiPreviewTitle;
  String get bidiPreviewDesc;
  String get sectionPrivacy;
  String get resetPrefsButton;
  String get resetDialogTitle;
  String get resetDialogBody;
  String get cancelButton;
  String get confirmResetButton;
  String get settingsResetDone;
  String get masteryThresholdLabel;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi', 'ur', 'bn'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) =>
      SynchronousFuture<AppLocalizations>(AppLocalizations.lookup(locale));

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
