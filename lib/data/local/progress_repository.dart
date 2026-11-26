import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hunardaily/core/config/app_constants.dart';
import 'package:hunardaily/data/local/database_config.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class LevelProgress {
  const LevelProgress({
    required this.courseId,
    required this.levelId,
    required this.bestScorePercent,
    required this.attempts,
    required this.completed,
    required this.updatedAtIso,
  });

  factory LevelProgress.fromMap(Map<String, Object?> map) {
    return LevelProgress(
      courseId: map['course_id'] as String,
      levelId: map['level_id'] as String,
      bestScorePercent: map['best_score_percent'] as int,
      attempts: map['attempts'] as int,
      completed: (map['completed'] as int) == 1,
      updatedAtIso: map['updated_at'] as String,
    );
  }

  final String courseId;
  final String levelId;
  final int bestScorePercent;
  final int attempts;
  final bool completed;
  final String updatedAtIso;

  String get key => '${courseId}_$levelId';
}

class ProgressRepository {
  ProgressRepository({Database? testDatabase}) : _db = testDatabase;

  static const String tableName = 'lesson_progress';
  Database? _db;

  Future<Database> _getDatabase() async {
    if (_db != null) {
      return _db!;
    }
    final dbDir = await getDatabasesPath();
    final dbPath = p.join(dbDir, DatabaseConfig.databaseFileName);
    _db = await openDatabase(
      dbPath,
      version: DatabaseConfig.schemaVersion,
      onCreate: (db, version) async {
        await createSchema(db);
      },
    );
    return _db!;
  }

  static Future<void> createSchema(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableName (
        course_id TEXT NOT NULL,
        level_id TEXT NOT NULL,
        best_score_percent INTEGER NOT NULL DEFAULT 0,
        attempts INTEGER NOT NULL DEFAULT 0,
        completed INTEGER NOT NULL DEFAULT 0,
        updated_at TEXT NOT NULL,
        PRIMARY KEY (course_id, level_id)
      )
    ''');
  }

  Future<Map<String, LevelProgress>> loadAllProgress() async {
    final db = await _getDatabase();
    final rows = await db.query(tableName);
    final result = <String, LevelProgress>{};
    for (final row in rows) {
      final item = LevelProgress.fromMap(row);
      result[item.key] = item;
    }
    return result;
  }

  Future<LevelProgress> recordAttempt({
    required String courseId,
    required String levelId,
    required int scorePercent,
    int masteryThreshold = AppConstants.defaultMasteryThresholdPercent,
  }) async {
    final db = await _getDatabase();
    final existingRows = await db.query(
      tableName,
      where: 'course_id = ? AND level_id = ?',
      whereArgs: <Object>[courseId, levelId],
      limit: 1,
    );

    final nowIso = DateTime.now().toIso8601String();
    int bestScore = scorePercent;
    int attempts = 1;
    bool completed = scorePercent >= masteryThreshold;

    if (existingRows.isNotEmpty) {
      final prev = LevelProgress.fromMap(existingRows.first);
      if (prev.bestScorePercent > bestScore) {
        bestScore = prev.bestScorePercent;
      }
      attempts = prev.attempts + 1;
      completed = prev.completed || completed;
    }

    await db.insert(
      tableName,
      <String, Object>{
        'course_id': courseId,
        'level_id': levelId,
        'best_score_percent': bestScore,
        'attempts': attempts,
        'completed': completed ? 1 : 0,
        'updated_at': nowIso,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return LevelProgress(
      courseId: courseId,
      levelId: levelId,
      bestScorePercent: bestScore,
      attempts: attempts,
      completed: completed,
      updatedAtIso: nowIso,
    );
  }

  Future<void> clearAll() async {
    final db = await _getDatabase();
    await db.delete(tableName);
  }
}

/// Evaluates whether a level index is unlocked based on 75% mastery of the
/// previous level. Index 0 (Beginner) is always unlocked.
bool isLevelUnlocked({
  required String courseId,
  required List<String> levelIds,
  required int levelIndex,
  required Map<String, LevelProgress> progressMap,
  int masteryThreshold = AppConstants.defaultMasteryThresholdPercent,
}) {
  if (levelIndex <= 0) {
    return true;
  }
  final prevLevelId = levelIds[levelIndex - 1];
  final prevProgress = progressMap['${courseId}_$prevLevelId'];
  if (prevProgress == null) {
    return false;
  }
  return prevProgress.completed || prevProgress.bestScorePercent >= masteryThreshold;
}

class ProgressState {
  const ProgressState({
    required this.items,
    this.isLoaded = false,
  });

  final Map<String, LevelProgress> items;
  final bool isLoaded;

  int get completedLevelsCount =>
      items.values.where((p) => p.completed).length;

  int get totalAttempts =>
      items.values.fold<int>(0, (sum, p) => sum + p.attempts);

  int get averageBestScore {
    if (items.isEmpty) {
      return 0;
    }
    final total = items.values.fold<int>(0, (sum, p) => sum + p.bestScorePercent);
    return (total / items.length).round();
  }
}

class ProgressController extends StateNotifier<ProgressState> {
  ProgressController(this._repo)
      : super(const ProgressState(items: <String, LevelProgress>{})) {
    _init();
  }

  final ProgressRepository _repo;

  Future<void> _init() async {
    try {
      final loaded = await _repo.loadAllProgress();
      if (mounted) {
        state = ProgressState(items: loaded, isLoaded: true);
      }
    } catch (e) {
      debugPrint('ProgressController init skipped: $e');
      if (mounted) {
        state = const ProgressState(items: <String, LevelProgress>{}, isLoaded: true);
      }
    }
  }

  Future<void> saveAttempt({
    required String courseId,
    required String levelId,
    required int scorePercent,
  }) async {
    try {
      final updated = await _repo.recordAttempt(
        courseId: courseId,
        levelId: levelId,
        scorePercent: scorePercent,
      );
      if (mounted) {
        final nextMap = Map<String, LevelProgress>.from(state.items);
        nextMap[updated.key] = updated;
        state = ProgressState(items: nextMap, isLoaded: true);
      }
    } catch (e) {
      debugPrint('ProgressController saveAttempt fallback: $e');
      final nowIso = DateTime.now().toIso8601String();
      final key = '${courseId}_$levelId';
      final prev = state.items[key];
      final best = (prev != null && prev.bestScorePercent > scorePercent)
          ? prev.bestScorePercent
          : scorePercent;
      final completed = (prev?.completed ?? false) ||
          scorePercent >= AppConstants.defaultMasteryThresholdPercent;
      final fallback = LevelProgress(
        courseId: courseId,
        levelId: levelId,
        bestScorePercent: best,
        attempts: (prev?.attempts ?? 0) + 1,
        completed: completed,
        updatedAtIso: nowIso,
      );
      if (mounted) {
        final nextMap = Map<String, LevelProgress>.from(state.items);
        nextMap[key] = fallback;
        state = ProgressState(items: nextMap, isLoaded: true);
      }
    }
  }
}

final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  return ProgressRepository();
});

final progressControllerProvider =
    StateNotifierProvider<ProgressController, ProgressState>((ref) {
  final repo = ref.watch(progressRepositoryProvider);
  return ProgressController(repo);
});
