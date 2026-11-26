import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hunardaily/core/localization/supported_language.dart';
import 'package:hunardaily/features/settings/app_settings_controller.dart';
import 'package:hunardaily/l10n/app_localizations.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(appSettingsProvider);
    final controller = ref.read(appSettingsProvider.notifier);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 32),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsetsDirectional.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: colorScheme.primaryContainer,
                      foregroundColor: colorScheme.onPrimaryContainer,
                      child: const Icon(Icons.person_outline_rounded, size: 28),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.guestModeHeading,
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            l10n.guestModeSubheading,
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.sectionInterfaceLanguage,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: UiLanguage.values.map((lang) {
                  final selected = settings.uiLanguage == lang;
                  return ListTile(
                    key: ValueKey<String>('settings_lang_${lang.code}'),
                    title: Text(lang.nativeName),
                    subtitle: Text(lang.englishName),
                    trailing: selected
                        ? Icon(
                            Icons.check_circle_rounded,
                            color: colorScheme.primary,
                          )
                        : const Icon(Icons.circle_outlined),
                    onTap: () => controller.setUiLanguage(lang),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.sectionLearningPair,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              l10n.independentPairNote,
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: LearningPair.values.map((pair) {
                  final selected = settings.learningPair == pair;
                  return ListTile(
                    key: ValueKey<String>('settings_pair_${pair.id}'),
                    title: Text(pair.nativeLabel),
                    subtitle: Text(pair.englishLabel),
                    trailing: selected
                        ? Icon(
                            Icons.check_circle_rounded,
                            color: colorScheme.primary,
                          )
                        : const Icon(Icons.circle_outlined),
                    onTap: () => controller.setLearningPair(pair),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.sectionAppearance,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            SegmentedButton<ThemeMode>(
              segments: <ButtonSegment<ThemeMode>>[
                ButtonSegment<ThemeMode>(
                  value: ThemeMode.system,
                  label: Text(l10n.themeSystem),
                  icon: const Icon(Icons.brightness_auto_outlined),
                ),
                ButtonSegment<ThemeMode>(
                  value: ThemeMode.light,
                  label: Text(l10n.themeLight),
                  icon: const Icon(Icons.light_mode_outlined),
                ),
                ButtonSegment<ThemeMode>(
                  value: ThemeMode.dark,
                  label: Text(l10n.themeDark),
                  icon: const Icon(Icons.dark_mode_outlined),
                ),
              ],
              selected: <ThemeMode>{settings.themeMode},
              onSelectionChanged: (selection) {
                if (selection.isNotEmpty) {
                  controller.setThemeMode(selection.first);
                }
              },
            ),
            const SizedBox(height: 20),
            Text(
              l10n.sectionTextSize,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: <({FontScalePreset preset, String label})>[
                (preset: FontScalePreset.small, label: l10n.textSizeSmall),
                (preset: FontScalePreset.normal, label: l10n.textSizeNormal),
                (preset: FontScalePreset.large, label: l10n.textSizeLarge),
                (
                  preset: FontScalePreset.extraLarge,
                  label: l10n.textSizeExtraLarge,
                ),
              ].map((item) {
                return ChoiceChip(
                  label: Text(item.label),
                  selected: settings.fontScale == item.preset,
                  onSelected: (_) => controller.setFontScale(item.preset),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsetsDirectional.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.bidiPreviewTitle,
                      style: theme.textTheme.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.bidiPreviewDesc,
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 10),
                    const Directionality(
                      textDirection: TextDirection.ltr,
                      child: Text(
                        'Skill (n.) — Practice makes steady progress.',
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Directionality(
                      textDirection: TextDirection.rtl,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'ہنر — روزانہ مشق سے مستقل ترقی ہوتی ہے۔',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.sectionPrivacy,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsetsDirectional.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.localStorageNoticeTitle,
                      style: theme.textTheme.titleSmall,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.localStorageNoticeBody,
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 14),
                    OutlinedButton.icon(
                      onPressed: () => _confirmReset(context, ref),
                      icon: const Icon(Icons.restart_alt_rounded),
                      label: Text(l10n.resetPrefsButton),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmReset(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.resetDialogTitle),
        content: Text(l10n.resetDialogBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.cancelButton),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.confirmResetButton),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(appSettingsProvider.notifier).resetLocalPreferences();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.settingsResetDone)),
        );
      }
    }
  }
}
