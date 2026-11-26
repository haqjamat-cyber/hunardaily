import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hunardaily/core/config/app_constants.dart';
import 'package:hunardaily/data/local/progress_repository.dart';
import 'package:hunardaily/features/courses/models/curriculum_models.dart';
import 'package:hunardaily/features/courses/quiz_ui_strings.dart';
import 'package:hunardaily/features/settings/app_settings_controller.dart';

class LessonQuizScreen extends ConsumerStatefulWidget {
  const LessonQuizScreen({
    super.key,
    required this.courseId,
    required this.courseTitle,
    required this.level,
    this.accentColor,
  });

  final String courseId;
  final String courseTitle;
  final CourseLevel level;
  final Color? accentColor;

  @override
  ConsumerState<LessonQuizScreen> createState() => _LessonQuizScreenState();
}

class _LessonQuizScreenState extends ConsumerState<LessonQuizScreen> {
  int _currentIndex = 0;
  int _correctCount = 0;
  int? _selectedOptionIndex;
  bool _finished = false;

  void _selectOption(int index, QuizQuestion question) {
    if (_selectedOptionIndex != null) {
      return;
    }
    setState(() {
      _selectedOptionIndex = index;
      if (index == question.correctIndex) {
        _correctCount++;
      }
    });
  }

  Future<void> _nextQuestion() async {
    final total = widget.level.questions.length;
    if (_currentIndex + 1 < total) {
      setState(() {
        _currentIndex++;
        _selectedOptionIndex = null;
      });
      return;
    }

    final scorePercent =
        total == 0 ? 0 : ((_correctCount / total) * 100).round();
    await ref.read(progressControllerProvider.notifier).saveAttempt(
          courseId: widget.courseId,
          levelId: widget.level.id,
          scorePercent: scorePercent,
        );

    if (mounted) {
      setState(() {
        _finished = true;
      });
    }
  }

  void _restart() {
    setState(() {
      _currentIndex = 0;
      _correctCount = 0;
      _selectedOptionIndex = null;
      _finished = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final settings = ref.watch(appSettingsProvider);
    final langCode = settings.uiLanguage.code;
    final ui = QuizUiStrings.of(settings.uiLanguage);
    final levelTitle = ui.levelName(widget.level.id);
    final accent = widget.accentColor ?? colorScheme.primary;
    final questions = widget.level.questions;

    if (_finished) {
      final total = questions.length;
      final scorePercent =
          total == 0 ? 0 : ((_correctCount / total) * 100).round();
      final passed =
          scorePercent >= AppConstants.defaultMasteryThresholdPercent;

      return Scaffold(
        appBar: AppBar(title: Text('${widget.courseTitle} • $levelTitle')),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsetsDirectional.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 112,
                    height: 112,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: passed
                            ? [colorScheme.primary, colorScheme.secondary]
                            : [
                                colorScheme.tertiary,
                                colorScheme.tertiary.withValues(alpha: 0.7),
                              ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (passed
                                  ? colorScheme.primary
                                  : colorScheme.tertiary)
                              .withValues(alpha: 0.28),
                          blurRadius: 24,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(
                      passed
                          ? Icons.emoji_events_rounded
                          : Icons.refresh_rounded,
                      size: 56,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                Text(
                  passed ? ui.levelMastered : ui.keepPracticing,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Container(
                    padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 18,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '${ui.scoreLabel}: $scorePercent% ($_correctCount / $total)',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  passed
                      ? ui.passedHint(
                          AppConstants.defaultMasteryThresholdPercent,
                        )
                      : ui.retryHint(
                          AppConstants.defaultMasteryThresholdPercent,
                        ),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 30),
                FilledButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back_rounded),
                  label: Text(ui.backToLevels),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: _restart,
                  icon: const Icon(Icons.replay_rounded),
                  label: Text(ui.tryAgain),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final question = questions[_currentIndex];
    final prompt = question.promptForLanguage(langCode);
    final options = question.optionsForLanguage(langCode);
    final explanation = question.explanationForLanguage(langCode);
    final isAnswered = _selectedOptionIndex != null;
    final answeredCorrectly =
        isAnswered && _selectedOptionIndex == question.correctIndex;

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.courseTitle} • $levelTitle'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 24),
          children: [
            // Modern Progress Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: isDark ? 0.25 : 0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    ui.questionProgress(_currentIndex + 1, questions.length),
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: isDark ? Colors.white : accent,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      size: 18,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$_correctCount / ${questions.length}',
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: (_currentIndex + 1) / questions.length,
                minHeight: 8,
                color: accent,
                backgroundColor: colorScheme.surfaceContainerHighest,
              ),
            ),
            const SizedBox(height: 18),
            // Modern Tinted Question Card
            Container(
              padding: const EdgeInsetsDirectional.all(20),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: accent.withValues(alpha: 0.28),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: accent.withValues(alpha: 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Text(
                prompt,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 18),
            // Tactile Option Cards
            ...List<Widget>.generate(options.length, (idx) {
              final optionText = options[idx];
              final isSelected = _selectedOptionIndex == idx;
              final isCorrect = idx == question.correctIndex;

              Color cardBg = colorScheme.surface;
              Color borderColor = colorScheme.outline.withValues(alpha: 0.45);
              Color badgeBg = colorScheme.surfaceContainerHighest;
              Color badgeFg = colorScheme.onSurface;

              if (isAnswered) {
                if (isCorrect) {
                  cardBg = colorScheme.primaryContainer;
                  borderColor = colorScheme.primary;
                  badgeBg = colorScheme.primary;
                  badgeFg = colorScheme.onPrimary;
                } else if (isSelected) {
                  cardBg = colorScheme.errorContainer;
                  borderColor = colorScheme.error;
                  badgeBg = colorScheme.error;
                  badgeFg = colorScheme.onError;
                }
              }

              return Padding(
                padding: const EdgeInsetsDirectional.only(bottom: 10),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: borderColor,
                      width: (isAnswered && (isCorrect || isSelected))
                          ? 1.8
                          : 1.0,
                    ),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () => _selectOption(idx, question),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: badgeBg,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                String.fromCharCode(65 + idx),
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: badgeFg,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              optionText,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          if (isAnswered && isCorrect)
                            Icon(
                              Icons.check_circle_rounded,
                              color: colorScheme.primary,
                            )
                          else if (isAnswered && isSelected && !isCorrect)
                            Icon(
                              Icons.cancel_rounded,
                              color: colorScheme.error,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
            if (isAnswered) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsetsDirectional.all(16),
                decoration: BoxDecoration(
                  color: answeredCorrectly
                      ? colorScheme.secondaryContainer
                      : colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          answeredCorrectly
                              ? Icons.celebration_rounded
                              : Icons.lightbulb_rounded,
                          size: 20,
                          color: answeredCorrectly
                              ? colorScheme.onSecondaryContainer
                              : colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          answeredCorrectly
                              ? ui.correctLabel
                              : ui.incorrectLabel,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      explanation,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _nextQuestion,
                child: Text(
                  _currentIndex + 1 < questions.length
                      ? ui.nextQuestion
                      : ui.finishAndSave,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
