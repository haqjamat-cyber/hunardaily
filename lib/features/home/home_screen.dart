import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hunardaily/core/localization/supported_language.dart';
import 'package:hunardaily/core/theme/app_colors.dart';
import 'package:hunardaily/data/local/progress_repository.dart';
import 'package:hunardaily/features/courses/quiz_ui_strings.dart';
import 'package:hunardaily/features/settings/app_settings_controller.dart';
import 'package:hunardaily/l10n/app_localizations.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(appSettingsProvider);
    final controller = ref.read(appSettingsProvider.notifier);
    final progress = ref.watch(progressControllerProvider);
    final ui = QuizUiStrings.of(settings.uiLanguage);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [colorScheme.primary, colorScheme.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.auto_awesome_rounded,
                size: 18,
                color: colorScheme.onPrimary,
              ),
            ),
            const SizedBox(width: 10),
            Text(l10n.appTitle),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 12),
            child: IconButton.filledTonal(
              tooltip: l10n.sectionAppearance,
              onPressed: () {
                final nextMode = isDark ? ThemeMode.light : ThemeMode.dark;
                controller.setThemeMode(nextMode);
              },
              icon: Icon(
                isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                size: 20,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 24),
          children: [
            // Modern Gradient Hero Banner + Live Progress Stats
            Container(
              padding: const EdgeInsetsDirectional.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? const [Color(0xFF0F3D3A), Color(0xFF134E4A)]
                      : const [Color(0xFF0F766E), Color(0xFF059669)],
                  begin: AlignmentDirectional.topStart,
                  end: AlignmentDirectional.bottomEnd,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.22),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.offline_bolt_rounded,
                          size: 14,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          l10n.offlineGuestBadge,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    l10n.homeGreeting,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.homeSubtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _HeroStatPill(
                          value: '${progress.completedLevelsCount}/24',
                          label: ui.statMastered,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _HeroStatPill(
                          value: '${progress.averageBestScore}%',
                          label: ui.statAvgScore,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _HeroStatPill(
                          value: '${progress.totalAttempts}',
                          label: ui.statAttempts,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Quick Language Card (placed high for instant access)
            Card(
              child: Padding(
                padding: const EdgeInsetsDirectional.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.language_rounded,
                          color: colorScheme.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            l10n.quickLanguageTitle,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.quickLanguageHint,
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: UiLanguage.values.map((lang) {
                        final isSelected = settings.uiLanguage == lang;
                        return ChoiceChip(
                          key: ValueKey<String>('home_lang_${lang.code}'),
                          label: Text(lang.nativeName),
                          selected: isSelected,
                          onSelected: (_) => controller.setUiLanguage(lang),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsetsDirectional.all(8),
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.translate_rounded,
                            size: 18,
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.activeCoursePairLabel,
                                style: theme.textTheme.labelMedium,
                              ),
                              Text(
                                settings.learningPair.nativeLabel,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Local Storage Notice Card
            Card(
              color: isDark
                  ? AppColors.warningBgDark
                  : AppColors.warningBgLight,
              child: Padding(
                padding: const EdgeInsetsDirectional.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.shield_outlined,
                          color: isDark
                              ? AppColors.warningFgDark
                              : AppColors.warningFgLight,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            l10n.localStorageNoticeTitle,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? AppColors.warningFgDark
                                  : AppColors.warningFgLight,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.localStorageNoticeBody,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark
                            ? AppColors.warningFgDark
                            : AppColors.warningFgLight,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (!settings.localDataNoticeAccepted)
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: FilledButton(
                          onPressed: controller.acceptLocalDataNotice,
                          child: Text(l10n.localStorageNoticeAcknowledge),
                        ),
                      )
                    else
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            size: 18,
                            color: isDark
                                ? AppColors.warningFgDark
                                : AppColors.warningFgLight,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              l10n.localStorageNoticeConfirmed,
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: isDark
                                    ? AppColors.warningFgDark
                                    : AppColors.warningFgLight,
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Roadmap Card
            Card(
              child: Padding(
                padding: const EdgeInsetsDirectional.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.roadmapTitle,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _RoadmapTile(text: l10n.roadmapModule1, isActive: true),
                    _RoadmapTile(text: l10n.roadmapModule2, isActive: true),
                    _RoadmapTile(text: l10n.roadmapModule3, isActive: true),
                    _RoadmapTile(text: l10n.roadmapModule4),
                    _RoadmapTile(text: l10n.roadmapModule5),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroStatPill extends StatelessWidget {
  const _HeroStatPill({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelSmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoadmapTile extends StatelessWidget {
  const _RoadmapTile({
    required this.text,
    this.isActive = false,
  });

  final String text;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isActive
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked_rounded,
            size: 20,
            color: isActive ? colorScheme.primary : colorScheme.outline,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
