import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hunardaily/core/config/app_constants.dart';
import 'package:hunardaily/data/local/progress_repository.dart';
import 'package:hunardaily/features/courses/curriculum_provider.dart';
import 'package:hunardaily/features/courses/lesson_quiz_screen.dart';
import 'package:hunardaily/features/courses/quiz_ui_strings.dart';
import 'package:hunardaily/features/settings/app_settings_controller.dart';

class CourseDetailScreen extends ConsumerWidget {
  const CourseDetailScreen({
    super.key,
    required this.courseId,
    required this.localizedTitle,
    this.accentColor,
    this.icon = Icons.menu_book_rounded,
  });

  final String courseId;
  final String localizedTitle;
  final Color? accentColor;
  final IconData icon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final curriculumAsync = ref.watch(curriculumProvider);
    final progressState = ref.watch(progressControllerProvider);
    final settings = ref.watch(appSettingsProvider);
    final ui = QuizUiStrings.of(settings.uiLanguage);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final accent = accentColor ?? colorScheme.primary;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text(localizedTitle)),
      body: SafeArea(
        child: curriculumAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(
            child: Padding(
              padding: const EdgeInsetsDirectional.all(24),
              child: Text('${ui.loadErrorPrefix} $err'),
            ),
          ),
          data: (catalog) {
            final course = catalog.courseById(courseId);
            if (course == null) {
              return Center(child: Text(ui.courseNotFound));
            }

            final levelIds =
                course.levels.map((l) => l.id).toList(growable: false);
            final completedCount = course.levels.where((lv) {
              return progressState.items['${course.id}_${lv.id}']?.completed ??
                  false;
            }).length;

            return ListView(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 10, 16, 24),
              children: [
                // Course Hero Card
                Container(
                  padding: const EdgeInsetsDirectional.all(18),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        accent.withValues(alpha: isDark ? 0.35 : 0.14),
                        accent.withValues(alpha: isDark ? 0.18 : 0.05),
                      ],
                      begin: AlignmentDirectional.topStart,
                      end: AlignmentDirectional.bottomEnd,
                    ),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: accent.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: accent,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(icon, color: Colors.white, size: 22),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              ui.masteryRule(
                                AppConstants.defaultMasteryThresholdPercent,
                              ),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(999),
                              child: LinearProgressIndicator(
                                value: completedCount / course.levels.length,
                                minHeight: 7,
                                color: accent,
                                backgroundColor:
                                    colorScheme.surface.withValues(alpha: 0.6),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '$completedCount/${course.levels.length} ${ui.masteredWord}',
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ...List<Widget>.generate(course.levels.length, (index) {
                  final level = course.levels[index];
                  final unlocked = isLevelUnlocked(
                    courseId: course.id,
                    levelIds: levelIds,
                    levelIndex: index,
                    progressMap: progressState.items,
                  );
                  final progress =
                      progressState.items['${course.id}_${level.id}'];
                  final bestScore = progress?.bestScorePercent;
                  final completed = progress?.completed ?? false;
                  final levelTitle = ui.levelName(level.id);

                  return Padding(
                    padding: const EdgeInsetsDirectional.only(bottom: 12),
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: unlocked
                            ? () {
                                Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (_) => LessonQuizScreen(
                                      courseId: course.id,
                                      courseTitle: localizedTitle,
                                      level: level,
                                      accentColor: accent,
                                    ),
                                  ),
                                );
                              }
                            : null,
                        child: Opacity(
                          opacity: unlocked ? 1.0 : 0.62,
                          child: Padding(
                            padding: const EdgeInsetsDirectional.all(16),
                            child: Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: completed
                                        ? colorScheme.primary
                                        : (unlocked
                                            ? accent.withValues(
                                                alpha: isDark ? 0.25 : 0.14,
                                              )
                                            : colorScheme
                                                .surfaceContainerHighest),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Center(
                                    child: completed
                                        ? Icon(
                                            Icons.check_rounded,
                                            color: colorScheme.onPrimary,
                                          )
                                        : (unlocked
                                            ? Text(
                                                '0${index + 1}',
                                                style: theme
                                                    .textTheme.titleMedium
                                                    ?.copyWith(
                                                  color: isDark
                                                      ? Colors.white
                                                      : accent,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              )
                                            : Icon(
                                                Icons.lock_outline_rounded,
                                                size: 20,
                                                color: colorScheme
                                                    .onSurfaceVariant,
                                              )),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        levelTitle,
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        bestScore != null
                                            ? '${level.questions.length} ${ui.questionsWord} • ${ui.bestScoreWord}: $bestScore%'
                                            : '${level.questions.length} ${ui.questionsWord} • ${unlocked ? ui.readyToStart : ui.locked}',
                                        style: theme.textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                                if (unlocked)
                                  Container(
                                    width: 34,
                                    height: 34,
                                    decoration: BoxDecoration(
                                      color: accent.withValues(
                                        alpha: isDark ? 0.25 : 0.12,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      Icons.play_arrow_rounded,
                                      color: isDark ? Colors.white : accent,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            );
          },
        ),
      ),
    );
  }
}
