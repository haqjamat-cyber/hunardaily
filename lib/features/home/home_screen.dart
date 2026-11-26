import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hunardaily/core/localization/supported_language.dart';
import 'package:hunardaily/core/theme/app_colors.dart';
import 'package:hunardaily/features/settings/app_settings_controller.dart';
import 'package:hunardaily/l10n/app_localizations.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(appSettingsProvider);
    final controller = ref.read(appSettingsProvider.notifier);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 12),
            child: IconButton(
              tooltip: l10n.sectionAppearance,
              onPressed: () {
                final nextMode = isDark ? ThemeMode.light : ThemeMode.dark;
                controller.setThemeMode(nextMode);
              },
              icon: Icon(
                isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 24),
          children: [
            Container(
              padding: const EdgeInsetsDirectional.all(20),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      l10n.offlineGuestBadge,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.homeGreeting,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.homeSubtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
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
                          Icons.info_outline_rounded,
                          color: isDark
                              ? AppColors.warningFgDark
                              : AppColors.warningFgLight,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            l10n.localStorageNoticeTitle,
                            style: theme.textTheme.titleMedium?.copyWith(
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
                            Icons.check_circle_outline,
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
            Card(
              child: Padding(
                padding: const EdgeInsetsDirectional.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.quickLanguageTitle,
                      style: theme.textTheme.titleMedium,
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
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          Icons.translate_rounded,
                          size: 20,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
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
                                style: theme.textTheme.titleSmall,
                              ),
                              Text(
                                l10n.independentPairNote,
                                style: theme.textTheme.bodySmall,
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
            Card(
              child: Padding(
                padding: const EdgeInsetsDirectional.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.roadmapTitle,
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    _RoadmapTile(
                      text: l10n.roadmapModule1,
                      isActive: true,
                    ),
                    _RoadmapTile(text: l10n.roadmapModule2),
                    _RoadmapTile(text: l10n.roadmapModule3),
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
