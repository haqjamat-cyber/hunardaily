import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hunardaily/core/config/app_constants.dart';
import 'package:hunardaily/data/local/progress_repository.dart';
import 'package:hunardaily/features/courses/models/curriculum_models.dart';
import 'package:hunardaily/features/settings/app_settings_controller.dart';

class LessonQuizScreen extends ConsumerStatefulWidget {
  const LessonQuizScreen({
    super.key,
    required this.courseId,
    required this.courseTitle,
    required this.level,
  });

  final String courseId;
  final String courseTitle;
  final CourseLevel level;

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

    final scorePercent = total == 0 ? 0 : ((_correctCount / total) * 100).round();
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
    final settings = ref.watch(appSettingsProvider);
    final questions = widget.level.questions;

    if (_finished) {
      final total = questions.length;
      final scorePercent = total == 0 ? 0 : ((_correctCount / total) * 100).round();
      final passed = scorePercent >= AppConstants.defaultMasteryThresholdPercent;

      return Scaffold(
        appBar: AppBar(title: Text('${widget.courseTitle} • ${widget.level.name}')),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsetsDirectional.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  passed ? Icons.emoji_events_rounded : Icons.refresh_rounded,
                  size: 72,
                  color: passed ? colorScheme.primary : colorScheme.tertiary,
                ),
                const SizedBox(height: 16),
                Text(
                  passed ? 'Level Mastered!' : 'Keep Practicing!',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Score: $scorePercent% ($_correctCount / $total)',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  passed
                      ? 'You reached the ${AppConstants.defaultMasteryThresholdPercent}% mastery threshold. The next level is now unlocked!'
                      : 'Score at least ${AppConstants.defaultMasteryThresholdPercent}% to unlock the next level.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 28),
                FilledButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back_rounded),
                  label: const Text('Back to Levels'),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: _restart,
                  icon: const Icon(Icons.replay_rounded),
                  label: const Text('Try Again'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final question = questions[_currentIndex];
    final prompt = question.promptForPair(settings.learningPair.id);
    final isAnswered = _selectedOptionIndex != null;

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.courseTitle} • ${widget.level.name}'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 24),
          children: [
            LinearProgressIndicator(
              value: (_currentIndex + 1) / questions.length,
              borderRadius: BorderRadius.circular(8),
            ),
            const SizedBox(height: 10),
            Text(
              'Question ${_currentIndex + 1} of ${questions.length}',
              style: theme.textTheme.labelLarge,
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsetsDirectional.all(18),
                child: Text(
                  prompt,
                  style: theme.textTheme.titleMedium,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ...List<Widget>.generate(question.options.length, (idx) {
              final optionText = question.options[idx];
              final isSelected = _selectedOptionIndex == idx;
              final isCorrect = idx == question.correctIndex;

              Color? tileColor;
              if (isAnswered) {
                if (isCorrect) {
                  tileColor = colorScheme.primaryContainer;
                } else if (isSelected) {
                  tileColor = colorScheme.errorContainer;
                }
              }

              return Padding(
                padding: const EdgeInsetsDirectional.only(bottom: 10),
                child: Card(
                  color: tileColor,
                  child: ListTile(
                    onTap: () => _selectOption(idx, question),
                    leading: CircleAvatar(
                      radius: 14,
                      child: Text(String.fromCharCode(65 + idx)),
                    ),
                    title: Text(optionText),
                    trailing: isAnswered && isCorrect
                        ? Icon(Icons.check_circle_rounded, color: colorScheme.primary)
                        : (isAnswered && isSelected && !isCorrect)
                            ? Icon(Icons.cancel_rounded, color: colorScheme.error)
                            : null,
                  ),
                ),
              );
            }),
            if (isAnswered) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsetsDirectional.all(14),
                decoration: BoxDecoration(
                  color: colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.lightbulb_outline_rounded,
                      color: colorScheme.onSecondaryContainer,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        question.explanation,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSecondaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _nextQuestion,
                child: Text(
                  _currentIndex + 1 < questions.length
                      ? 'Next Question'
                      : 'Finish & Save Score',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
