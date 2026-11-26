import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hunardaily/features/settings/app_settings_controller.dart';
import 'package:hunardaily/l10n/app_localizations.dart';

class CoursesScreen extends ConsumerWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(appSettingsProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final modules = <_ModuleSummary>[
      _ModuleSummary(
        icon: Icons.menu_book_rounded,
        title: l10n.moduleVocab,
        subtitle: settings.learningPair.nativeLabel,
      ),
      _ModuleSummary(
        icon: Icons.keyboard_alt_outlined,
        title: l10n.moduleTyping,
        subtitle: l10n.levelTags,
      ),
      _ModuleSummary(
        icon: Icons.quiz_outlined,
        title: l10n.moduleQuizzes,
        subtitle: l10n.levelTags,
      ),
      _ModuleSummary(
        icon: Icons.public_rounded,
        title: l10n.moduleGk,
        subtitle: l10n.levelTags,
      ),
      _ModuleSummary(
        icon: Icons.devices_other_rounded,
        title: l10n.moduleDigitalSkills,
        subtitle: l10n.levelTags,
      ),
      _ModuleSummary(
        icon: Icons.edit_note_rounded,
        title: l10n.moduleReadingWriting,
        subtitle: l10n.levelTags,
      ),
    ];

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
            ...modules.map(
              (item) => Padding(
                padding: const EdgeInsetsDirectional.only(bottom: 12),
                child: Card(
                  child: ListTile(
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
                      item.subtitle,
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.coursesComingSoonNote,
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _ModuleSummary {
  const _ModuleSummary({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;
}
