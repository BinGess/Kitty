import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../providers/test_provider.dart';

class QuestionScreen extends ConsumerStatefulWidget {
  const QuestionScreen({super.key});

  @override
  ConsumerState<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends ConsumerState<QuestionScreen> {
  bool _transitioning = false;
  int? _pendingScore;

  void _handleAnswer(int score) {
    if (_transitioning) return;

    HapticFeedback.lightImpact();
    setState(() {
      _transitioning = true;
      _pendingScore = score;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      final testState = ref.read(testProvider);
      final isLast = testState.isLastQuestion;

      ref.read(testProvider.notifier).answerQuestion(score);
      setState(() => _pendingScore = null);

      if (isLast) {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) context.pushReplacement('/test/analyzing');
        });
      }
    });
  }

  void _onTransitionEnd() {
    if (mounted) setState(() => _transitioning = false);
  }

  @override
  Widget build(BuildContext context) {
    final testState = ref.watch(testProvider);
    final question = testState.currentQuestion;

    if (question == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop || _transitioning) return;
        if (testState.currentIndex > 0) {
          ref.read(testProvider.notifier).goBack();
        } else {
          ref.read(testProvider.notifier).reset();
          context.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '${testState.mode.label} ${testState.currentIndex + 1}/${testState.questions.length}',
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (_transitioning) return;
              if (testState.currentIndex > 0) {
                ref.read(testProvider.notifier).goBack();
              } else {
                ref.read(testProvider.notifier).reset();
                context.pop();
              }
            },
          ),
        ),
        body: Column(
          children: [
            _ProgressBar(progress: testState.progress),
            Expanded(
              child: _QuestionSwitcher(
                questionNumber: question.number,
                onTransitionEnd: _onTransitionEnd,
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.spacingL),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${question.dimension.leftName} vs ${question.dimension.rightName}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacingL),
                      Text(
                        question.text,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onBackground,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacingXL),
                      _OptionButton(
                        text: question.optionA.text,
                        label: 'A',
                        isSelected: _pendingScore == question.optionA.score,
                        onTap: () => _handleAnswer(question.optionA.score),
                      ),
                      const SizedBox(height: AppDimensions.spacingM),
                      _OptionButton(
                        text: question.optionB.text,
                        label: 'B',
                        isSelected: _pendingScore == question.optionB.score,
                        onTap: () => _handleAnswer(question.optionB.score),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Handles the two-phase transition: old question fades out, then new one fades in.
class _QuestionSwitcher extends StatefulWidget {
  final int questionNumber;
  final Widget child;
  final VoidCallback? onTransitionEnd;

  const _QuestionSwitcher({
    required this.questionNumber,
    required this.child,
    this.onTransitionEnd,
  });

  @override
  State<_QuestionSwitcher> createState() => _QuestionSwitcherState();
}

class _QuestionSwitcherState extends State<_QuestionSwitcher>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _opacity;
  late Animation<Offset> _slide;

  int _displayedQuestion = -1;
  Widget? _child;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    _opacity = CurvedAnimation(
      parent: _ctrl,
      curve: Curves.easeOut,
    );
    _slide = Tween<Offset>(
      begin: const Offset(0.06, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _ctrl,
      curve: Curves.easeOutCubic,
    ));

    _displayedQuestion = widget.questionNumber;
    _child = widget.child;
    _ctrl.value = 1.0;
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _QuestionSwitcher oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.questionNumber != _displayedQuestion) {
      _animateToNewQuestion();
    } else {
      _child = widget.child;
    }
  }

  Future<void> _animateToNewQuestion() async {
    // Phase 1: fade out the current question
    await _ctrl.reverse();
    if (!mounted) return;

    // Phase 2: swap content and fade in the new question
    setState(() {
      _displayedQuestion = widget.questionNumber;
      _child = widget.child;
    });
    await _ctrl.forward();
    widget.onTransitionEnd?.call();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _slide,
        child: _child ?? widget.child,
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final double progress;
  const _ProgressBar({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4,
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingM),
      decoration: BoxDecoration(
        color: AppColors.divider,
        borderRadius: BorderRadius.circular(2),
      ),
      child: AnimatedFractionallySizedBox(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        alignment: Alignment.centerLeft,
        widthFactor: progress,
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryDark],
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}

class _OptionButton extends StatelessWidget {
  final String text;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _OptionButton({
    required this.text,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingL,
          vertical: AppDimensions.spacingM + 4,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.15)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.surfaceVariant,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: isSelected
                    ? const Icon(Icons.check, size: 18, color: Colors.white)
                    : Text(
                        label,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: AppDimensions.spacingM),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  color: isSelected
                      ? AppColors.primaryDark
                      : AppColors.onSurface,
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
