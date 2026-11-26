import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hunardaily/core/localization/supported_language.dart';
import 'package:hunardaily/data/local/progress_repository.dart';
import 'package:hunardaily/features/courses/models/curriculum_models.dart';
import 'package:hunardaily/features/courses/quiz_ui_strings.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
  });

  group('Module 3 Multilingual Curriculum & SQLite Progress', () {
    test('parses curriculum_v1.json with full en/hi/ur/bn translations', () {
      final raw = File('assets/content/curriculum_v1.json').readAsStringSync();
      final catalog = CurriculumCatalog.fromJsonString(raw);

      expect(catalog.version, 2);
      expect(catalog.courses.length, 6);
      for (final course in catalog.courses) {
        expect(course.levels.length, 4);
        for (final level in course.levels) {
          expect(level.questions.length, 4);
          for (final q in level.questions) {
            for (final lang in const <String>['en', 'hi', 'ur', 'bn']) {
              expect(q.promptForLanguage(lang).trim().isNotEmpty, isTrue);
              expect(q.optionsForLanguage(lang).length, 4);
              expect(q.explanationForLanguage(lang).trim().isNotEmpty, isTrue);
            }
          }
        }
      }

      // Verify Daily Quizzes Beginner Q1 switches properly to Hindi, Urdu, Bengali
      final quizzes = catalog.courseById('quizzes')!;
      final q1 = quizzes.levels.first.questions.first;
      expect(q1.promptForLanguage('hi'), contains('मिनट'));
      expect(q1.promptForLanguage('ur'), contains('منٹ'));
      expect(q1.promptForLanguage('bn'), contains('মিনিট'));

      // Verify QuizUiStrings translates level names for all 4 UI languages
      expect(QuizUiStrings.of(UiLanguage.hindi).levelName('beginner'), 'शुरुआती');
      expect(QuizUiStrings.of(UiLanguage.urdu).levelName('beginner'), 'ابتدائی');
      expect(QuizUiStrings.of(UiLanguage.bengali).levelName('beginner'), 'শুরু');
    });

    test('persists attempts in SQLite and unlocks next level at 75% mastery', () async {
      final db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
      await ProgressRepository.createSchema(db);
      final repo = ProgressRepository(testDatabase: db);

      final levelIds = <String>['beginner', 'elementary', 'intermediate', 'advanced'];

      var all = await repo.loadAllProgress();
      expect(
        isLevelUnlocked(
          courseId: 'vocab',
          levelIds: levelIds,
          levelIndex: 0,
          progressMap: all,
        ),
        isTrue,
      );
      expect(
        isLevelUnlocked(
          courseId: 'vocab',
          levelIds: levelIds,
          levelIndex: 1,
          progressMap: all,
        ),
        isFalse,
      );

      await repo.recordAttempt(
        courseId: 'vocab',
        levelId: 'beginner',
        scorePercent: 50,
      );
      all = await repo.loadAllProgress();
      expect(all['vocab_beginner']!.completed, isFalse);

      await repo.recordAttempt(
        courseId: 'vocab',
        levelId: 'beginner',
        scorePercent: 75,
      );
      all = await repo.loadAllProgress();
      expect(all['vocab_beginner']!.completed, isTrue);
      expect(all['vocab_beginner']!.attempts, 2);
      expect(
        isLevelUnlocked(
          courseId: 'vocab',
          levelIds: levelIds,
          levelIndex: 1,
          progressMap: all,
        ),
        isTrue,
      );

      await db.close();
    });
  });
}
