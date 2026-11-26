import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hunardaily/data/local/progress_repository.dart';
import 'package:hunardaily/features/courses/course_detail_screen.dart';
import 'package:hunardaily/features/settings/app_settings_controller.dart';
import 'package:hunardaily/l10n/app_localizations.dart';

class CoursesScreen extends ConsumerWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(appSettingsProvider);
    final progressState = ref.watch(progressControllerProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final modules = <_ModuleSummary>[
      _ModuleSummary(
        id: 'vocab',
        icon: Icons.menu_book_rounded,
        title: l10n.moduleVocab,
        subtitle: settings.learningPair.nativeLabel,
      ),
      _ModuleSummary(
        id: 'typing',
        icon: Icons.keyboard_alt_outlined,
        title: l10n.moduleTyping,
        subtitle: l10n.levelTags,
      ),
      _ModuleSummary(
        id: 'quizzes',
        icon: Icons.quiz_outlined,
        title: l10n.moduleQuizzes,
        subtitle: l10n.levelTags,
      ),
      _ModuleSummary(
        id: 'gk',
        icon: Icons.public_rounded,
        title: l10n.moduleGk,
        subtitle: l10n.levelTags,
      ),
      _ModuleSummary(
        id: 'digital_skills',
        icon: Icons.devices_other_rounded,
        title: l10n.moduleDigitalSkills,
        subtitle: l10n.levelTags,
      ),
      _ModuleSummary(
        id: 'reading_writing',
        icon: Icons.edit_note_rounded,
        title: l10n.moduleReadingWriting,
        subtitle: l10n.levelTags,
      ),
    ];

    int completedForCourse(String courseId) {
      return progressState.items.values
          .where((p) => p.courseId == courseId && p.completed)
          .length;
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.coursesTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 24),
          children: [
            Text(l10n.coursesSubtitle, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 10),
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
                      l10n.masteryThresholdLabel,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ...modules.map((item) {
              final doneCount = completedForCourse(item.id);
              return Padding(
                padding: const EdgeInsetsDirectional.only(bottom: 12),
                child: Card(
                  child: ListTile(
                    key: ValueKey<String>('course_card_${item.id}'),
                    contentPadding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: colorScheme.secondaryContainer,
                      foregroundColor: colorScheme.onSecondaryContainer,
                      child: Icon(item.icon),
                    ),
                    title: Text(item.title, style: theme.textTheme.titleMedium),
                    subtitle: Text(
                      doneCount > 0
                          ? '${item.subtitle} • $doneCount/4 mastered'
                          : item.subtitle,
                      style: theme.textTheme.bodySmall,
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => CourseDetailScreen(
                            courseId: item.id,
                            localizedTitle: item.title,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _ModuleSummary {
  const _ModuleSummary({
    required this.id,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final String id;
  final IconData icon;
  final String title;
  final String subtitle;
}
