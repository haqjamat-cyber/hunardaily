import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hunardaily/core/config/app_constants.dart';
import 'package:hunardaily/data/local/progress_repository.dart';
import 'package:hunardaily/features/courses/curriculum_provider.dart';
import 'package:hunardaily/features/courses/lesson_quiz_screen.dart';

class CourseDetailScreen extends ConsumerWidget {
  const CourseDetailScreen({
    super.key,
    required this.courseId,
    required this.localizedTitle,
  });

  final String courseId;
  final String localizedTitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final curriculumAsync = ref.watch(curriculumProvider);
    final progressState = ref.watch(progressControllerProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(localizedTitle)),
      body: SafeArea(
        child: curriculumAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(
            child: Padding(
              padding: const EdgeInsetsDirectional.all(24),
              child: Text('Could not load offline course content: $err'),
            ),
          ),
          data: (catalog) {
            final course = catalog.courseById(courseId);
            if (course == null) {
              return const Center(child: Text('Course content not found.'));
            }

            final levelIds = course.levels.map((l) => l.id).toList(growable: false);

            return ListView(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 24),
              children: [
                Container(
                  padding: const EdgeInsetsDirectional.all(14),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.verified_outlined,
                        color: colorScheme.onPrimaryContainer,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Score ${AppConstants.defaultMasteryThresholdPercent}% or higher in a level to unlock the next one.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
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
                  final progress = progressState.items['${course.id}_${level.id}'];
                  final bestScore = progress?.bestScorePercent;
                  final completed = progress?.completed ?? false;

                  return Padding(
                    padding: const EdgeInsetsDirectional.only(bottom: 12),
                    child: Card(
                      child: ListTile(
                        enabled: unlocked,
                        contentPadding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        leading: CircleAvatar(
                          backgroundColor: completed
                              ? colorScheme.primary
                              : (unlocked
                                  ? colorScheme.secondaryContainer
                                  : colorScheme.surfaceContainerHighest),
                          foregroundColor: completed
                              ? colorScheme.onPrimary
                              : (unlocked
                                  ? colorScheme.onSecondaryContainer
                                  : colorScheme.onSurfaceVariant),
                          child: Icon(
                            completed
                                ? Icons.check_rounded
                                : (unlocked
                                    ? Icons.play_arrow_rounded
                                    : Icons.lock_outline_rounded),
                          ),
                        ),
                        title: Text(
                          level.name,
                          style: theme.textTheme.titleMedium,
                        ),
                        subtitle: Text(
                          bestScore != null
                              ? '${level.questions.length} questions • Best score: $bestScore%'
                              : '${level.questions.length} questions • ${unlocked ? 'Ready to start' : 'Locked'}',
                        ),
                        trailing: unlocked
                            ? const Icon(Icons.chevron_right_rounded)
                            : null,
                        onTap: unlocked
                            ? () {
                                Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (_) => LessonQuizScreen(
                                      courseId: course.id,
                                      courseTitle: localizedTitle,
                                      level: level,
                                    ),
                                  ),
                                );
                              }
                            : null,
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
