import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hunardaily/data/local/progress_repository.dart';
import 'package:hunardaily/features/courses/models/curriculum_models.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
  });

  group('Module 2 Curriculum & SQLite Progress', () {
    test('parses bundled curriculum_v1.json with 6 courses and 4 levels each', () {
      final raw = File('assets/content/curriculum_v1.json').readAsStringSync();
      final catalog = CurriculumCatalog.fromJsonString(raw);

      expect(catalog.version, 1);
      expect(catalog.courses.length, 6);
      for (final course in catalog.courses) {
        expect(course.levels.length, 4);
        for (final level in course.levels) {
          expect(level.questions.isNotEmpty, isTrue);
        }
      }

      final vocab = catalog.courseById('vocab')!;
      final firstQ = vocab.levels.first.questions.first;
      expect(firstQ.promptForPair('hi_to_en'), contains('धन्यवाद'));
      expect(firstQ.promptForPair('ur_to_en'), contains('شکریہ'));
      expect(firstQ.promptForPair('bn_to_en'), contains('ধন্যবাদ'));
    });

    test('persists attempts in SQLite and unlocks next level at 75% mastery', () async {
      final db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
      await ProgressRepository.createSchema(db);
      final repo = ProgressRepository(testDatabase: db);

      final levelIds = <String>['beginner', 'elementary', 'intermediate', 'advanced'];

      // Initially only Beginner is unlocked
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

      // Score 50% -> still locked
      await repo.recordAttempt(
        courseId: 'vocab',
        levelId: 'beginner',
        scorePercent: 50,
      );
      all = await repo.loadAllProgress();
      expect(all['vocab_beginner']!.completed, isFalse);
      expect(
        isLevelUnlocked(
          courseId: 'vocab',
          levelIds: levelIds,
          levelIndex: 1,
          progressMap: all,
        ),
        isFalse,
      );

      // Score 75% -> Elementary unlocks!
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
