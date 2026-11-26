import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hunardaily/data/local/progress_repository.dart';
import 'package:hunardaily/features/courses/course_detail_screen.dart';
import 'package:hunardaily/features/courses/quiz_ui_strings.dart';
import 'package:hunardaily/features/settings/app_settings_controller.dart';
import 'package:hunardaily/l10n/app_localizations.dart';

class CoursesScreen extends ConsumerWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(appSettingsProvider);
    final progressState = ref.watch(progressControllerProvider);
    final ui = QuizUiStrings.of(settings.uiLanguage);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final modules = <_ModuleSummary>[
      _ModuleSummary(
        id: 'vocab',
        icon: Icons.menu_book_rounded,
        title: l10n.moduleVocab,
        subtitle: settings.learningPair.nativeLabel,
        accent: const Color(0xFF0F766E),
      ),
      _ModuleSummary(
        id: 'typing',
        icon: Icons.keyboard_alt_rounded,
        title: l10n.moduleTyping,
        subtitle: l10n.levelTags,
        accent: const Color(0xFF4F46E5),
      ),
      _ModuleSummary(
        id: 'quizzes',
        icon: Icons.bolt_rounded,
        title: l10n.moduleQuizzes,
        subtitle: l10n.levelTags,
        accent: const Color(0xFFD97706),
      ),
      _ModuleSummary(
        id: 'gk',
        icon: Icons.public_rounded,
        title: l10n.moduleGk,
        subtitle: l10n.levelTags,
        accent: const Color(0xFF059669),
      ),
      _ModuleSummary(
        id: 'digital_skills',
        icon: Icons.devices_other_rounded,
        title: l10n.moduleDigitalSkills,
        subtitle: l10n.levelTags,
        accent: const Color(0xFF0284C7),
      ),
      _ModuleSummary(
        id: 'reading_writing',
        icon: Icons.edit_note_rounded,
        title: l10n.moduleReadingWriting,
        subtitle: l10n.levelTags,
        accent: const Color(0xFF7C3AED),
      ),
    ];

    int completedForCourse(String courseId) {
      return progressState.items.values
          .where((p) => p.courseId == courseId && p.completed)
          .length;
    }

    final totalDone = progressState.completedLevelsCount;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.coursesTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 24),
          children: [
            // Modern Summary Banner
            Container(
              padding: const EdgeInsetsDirectional.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [
                          colorScheme.primaryContainer,
                          colorScheme.secondaryContainer,
                        ]
                      : [
                          colorScheme.primaryContainer,
                          colorScheme.secondaryContainer.withValues(alpha: 0.7),
                        ],
                  begin: AlignmentDirectional.topStart,
                  end: AlignmentDirectional.bottomEnd,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.verified_rounded,
                        color: colorScheme.onPrimaryContainer,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l10n.masteryThresholdLabel,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.surface.withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          '$totalDone / 24',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: totalDone / 24,
                      minHeight: 7,
                      backgroundColor:
                          colorScheme.surface.withValues(alpha: 0.45),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ...modules.map((item) {
              final doneCount = completedForCourse(item.id);
              final ratio = doneCount / 4;
              return Padding(
                padding: const EdgeInsetsDirectional.only(bottom: 12),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    key: ValueKey<String>('course_card_${item.id}'),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => CourseDetailScreen(
                            courseId: item.id,
                            localizedTitle: item.title,
                            accentColor: item.accent,
                            icon: item.icon,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsetsDirectional.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: item.accent.withValues(
                                alpha: isDark ? 0.25 : 0.12,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              item.icon,
                              color: isDark
                                  ? Color.lerp(item.accent, Colors.white, 0.35)
                                  : item.accent,
                              size: 26,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  item.subtitle,
                                  style: theme.textTheme.bodySmall,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(999),
                                        child: LinearProgressIndicator(
                                          value: ratio,
                                          minHeight: 5,
                                          color: item.accent,
                                          backgroundColor:
                                              colorScheme.surfaceContainerHighest,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '$doneCount/4 ${ui.masteredWord}',
                                      style:
                                          theme.textTheme.labelSmall?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.chevron_right_rounded,
                              size: 20,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
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
    required this.accent,
  });

  final String id;
  final IconData icon;
  final String title;
  final String subtitle;
  final Color accent;
}
