import 'package:hunardaily/core/localization/supported_language.dart';

/// Localized UI labels for Courses, Level Details, Quizzes, and Home stats
/// so switching the app language immediately translates every learning screen.
class QuizUiStrings {
  const QuizUiStrings({
    required this.beginner,
    required this.elementary,
    required this.intermediate,
    required this.advanced,
    required this.masteryRuleTemplate,
    required this.questionsWord,
    required this.readyToStart,
    required this.locked,
    required this.bestScoreWord,
    required this.masteredWord,
    required this.questionWord,
    required this.ofWord,
    required this.nextQuestion,
    required this.finishAndSave,
    required this.levelMastered,
    required this.keepPracticing,
    required this.scoreLabel,
    required this.passedHintTemplate,
    required this.retryHintTemplate,
    required this.backToLevels,
    required this.tryAgain,
    required this.correctLabel,
    required this.incorrectLabel,
    required this.statMastered,
    required this.statAvgScore,
    required this.statAttempts,
    required this.loadErrorPrefix,
    required this.courseNotFound,
  });

  final String beginner;
  final String elementary;
  final String intermediate;
  final String advanced;
  final String masteryRuleTemplate;
  final String questionsWord;
  final String readyToStart;
  final String locked;
  final String bestScoreWord;
  final String masteredWord;
  final String questionWord;
  final String ofWord;
  final String nextQuestion;
  final String finishAndSave;
  final String levelMastered;
  final String keepPracticing;
  final String scoreLabel;
  final String passedHintTemplate;
  final String retryHintTemplate;
  final String backToLevels;
  final String tryAgain;
  final String correctLabel;
  final String incorrectLabel;
  final String statMastered;
  final String statAvgScore;
  final String statAttempts;
  final String loadErrorPrefix;
  final String courseNotFound;

  String levelName(String levelId) {
    switch (levelId) {
      case 'beginner':
        return beginner;
      case 'elementary':
        return elementary;
      case 'intermediate':
        return intermediate;
      case 'advanced':
        return advanced;
      default:
        return levelId;
    }
  }

  String masteryRule(int percent) =>
      masteryRuleTemplate.replaceAll('{p}', '$percent');

  String passedHint(int percent) =>
      passedHintTemplate.replaceAll('{p}', '$percent');

  String retryHint(int percent) =>
      retryHintTemplate.replaceAll('{p}', '$percent');

  String questionProgress(int current, int total) =>
      '$questionWord $current $ofWord $total';

  static QuizUiStrings of(UiLanguage lang) {
    switch (lang) {
      case UiLanguage.hindi:
        return const QuizUiStrings(
          beginner: 'शुरुआती',
          elementary: 'प्राथमिक',
          intermediate: 'मध्यम',
          advanced: 'उन्नत',
          masteryRuleTemplate: 'अगला स्तर खोलने के लिए कम से कम {p}% अंक लाएँ।',
          questionsWord: 'प्रश्न',
          readyToStart: 'शुरू करने के लिए तैयार',
          locked: 'लॉक है',
          bestScoreWord: 'सर्वश्रेष्ठ स्कोर',
          masteredWord: 'पूर्ण',
          questionWord: 'प्रश्न',
          ofWord: '/',
          nextQuestion: 'अगला प्रश्न',
          finishAndSave: 'समाप्त करें और स्कोर सहेजें',
          levelMastered: 'स्तर पूरा हुआ!',
          keepPracticing: 'अभ्यास जारी रखें!',
          scoreLabel: 'स्कोर',
          passedHintTemplate:
              'आपने {p}% लक्ष्य प्राप्त कर लिया है। अगला स्तर अब खुल गया है!',
          retryHintTemplate:
              'अगला स्तर खोलने के लिए कम से कम {p}% अंक प्राप्त करें।',
          backToLevels: 'स्तरों पर वापस जाएँ',
          tryAgain: 'फिर से प्रयास करें',
          correctLabel: 'बिल्कुल सही!',
          incorrectLabel: 'सही उत्तर देखें',
          statMastered: 'पूर्ण स्तर',
          statAvgScore: 'औसत स्कोर',
          statAttempts: 'प्रयास',
          loadErrorPrefix: 'ऑफ़लाइन सामग्री लोड नहीं हो सकी:',
          courseNotFound: 'कोर्स सामग्री नहीं मिली।',
        );
      case UiLanguage.urdu:
        return const QuizUiStrings(
          beginner: 'ابتدائی',
          elementary: 'بنیادی',
          intermediate: 'درمیانہ',
          advanced: 'اعلیٰ',
          masteryRuleTemplate:
              'اگلا لیول کھولنے کے لیے کم از کم {p}% اسکور حاصل کریں۔',
          questionsWord: 'سوالات',
          readyToStart: 'شروع کرنے کے لیے تیار',
          locked: 'لاک ہے',
          bestScoreWord: 'بہترین اسکور',
          masteredWord: 'مکمل',
          questionWord: 'سوال',
          ofWord: 'از',
          nextQuestion: 'اگلا سوال',
          finishAndSave: 'مکمل کریں اور اسکور محفوظ کریں',
          levelMastered: 'لیول مکمل ہو گیا!',
          keepPracticing: 'مشق جاری رکھیں!',
          scoreLabel: 'اسکور',
          passedHintTemplate:
              'آپ نے {p}% ہدف حاصل کر لیا ہے۔ اگلا لیول اب کھل گیا ہے!',
          retryHintTemplate:
              'اگلا لیول کھولنے کے لیے کم از کم {p}% اسکور حاصل کریں۔',
          backToLevels: 'لیولز پر واپس جائیں',
          tryAgain: 'دوبارہ کوشش کریں',
          correctLabel: 'بالکل درست!',
          incorrectLabel: 'صحیح جواب دیکھیں',
          statMastered: 'مکمل لیولز',
          statAvgScore: 'اوسط اسکور',
          statAttempts: 'کوششیں',
          loadErrorPrefix: 'آف لائن مواد لوڈ نہیں ہو سکا:',
          courseNotFound: 'کورس کا مواد نہیں ملا۔',
        );
      case UiLanguage.bengali:
        return const QuizUiStrings(
          beginner: 'শুরু',
          elementary: 'প্রাথমিক',
          intermediate: 'মধ্যম',
          advanced: 'উন্নত',
          masteryRuleTemplate:
              'পরবর্তী ধাপ খুলতে অন্তত {p}% নম্বর অর্জন করুন।',
          questionsWord: 'প্রশ্ন',
          readyToStart: 'শুরু করার জন্য প্রস্তুত',
          locked: 'লক করা',
          bestScoreWord: 'সেরা স্কোর',
          masteredWord: 'সম্পন্ন',
          questionWord: 'প্রশ্ন',
          ofWord: '/',
          nextQuestion: 'পরবর্তী প্রশ্ন',
          finishAndSave: 'শেষ করুন ও স্কোর সেভ করুন',
          levelMastered: 'ধাপ সম্পন্ন হয়েছে!',
          keepPracticing: 'অনুশীলন চালিয়ে যান!',
          scoreLabel: 'স্কোর',
          passedHintTemplate:
              'আপনি {p}% লক্ষ্য অর্জন করেছেন। পরবর্তী ধাপ এখন আনলক হয়েছে!',
          retryHintTemplate:
              'পরবর্তী ধাপ খুলতে অন্তত {p}% স্কোর করুন।',
          backToLevels: 'ধাপগুলোতে ফিরে যান',
          tryAgain: 'আবার চেষ্টা করুন',
          correctLabel: 'একদম সঠিক!',
          incorrectLabel: 'সঠিক উত্তর দেখুন',
          statMastered: 'সম্পন্ন ধাপ',
          statAvgScore: 'গড় স্কোর',
          statAttempts: 'চেষ্টা',
          loadErrorPrefix: 'অফলাইন কনটেন্ট লোড করা যায়নি:',
          courseNotFound: 'কোর্সের তথ্য পাওয়া যায়নি।',
        );
      case UiLanguage.english:
        return const QuizUiStrings(
          beginner: 'Beginner',
          elementary: 'Elementary',
          intermediate: 'Intermediate',
          advanced: 'Advanced',
          masteryRuleTemplate:
              'Score {p}% or higher in a level to unlock the next one.',
          questionsWord: 'questions',
          readyToStart: 'Ready to start',
          locked: 'Locked',
          bestScoreWord: 'Best score',
          masteredWord: 'mastered',
          questionWord: 'Question',
          ofWord: 'of',
          nextQuestion: 'Next Question',
          finishAndSave: 'Finish & Save Score',
          levelMastered: 'Level Mastered!',
          keepPracticing: 'Keep Practicing!',
          scoreLabel: 'Score',
          passedHintTemplate:
              'You reached the {p}% mastery threshold. The next level is now unlocked!',
          retryHintTemplate:
              'Score at least {p}% to unlock the next level.',
          backToLevels: 'Back to Levels',
          tryAgain: 'Try Again',
          correctLabel: 'Correct!',
          incorrectLabel: 'Review the explanation',
          statMastered: 'Mastered',
          statAvgScore: 'Avg Score',
          statAttempts: 'Attempts',
          loadErrorPrefix: 'Could not load offline course content:',
          courseNotFound: 'Course content not found.',
        );
    }
  }
}
