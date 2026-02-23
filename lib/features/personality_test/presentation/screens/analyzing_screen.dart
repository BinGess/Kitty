import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/test_provider.dart';

class AnalyzingScreen extends ConsumerStatefulWidget {
  const AnalyzingScreen({super.key});

  @override
  ConsumerState<AnalyzingScreen> createState() => _AnalyzingScreenState();
}

class _AnalyzingScreenState extends ConsumerState<AnalyzingScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _progressController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _progressAnimation;

  final _steps = ['分析行为模式...', '识别性格维度...', '计算匹配度...', '生成性格报告...'];
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    _progressAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );

    _progressController.forward();

    // Step through analysis stages
    _runAnalysis();
  }

  Future<void> _runAnalysis() async {
    for (int i = 0; i < _steps.length; i++) {
      await Future.delayed(const Duration(milliseconds: 700));
      if (mounted) setState(() => _currentStep = i);
    }
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      ref.read(testProvider.notifier).finishAnalyzing();
      context.pushReplacement('/test/result');
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated paw icon
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.pets,
                          size: 48,
                          color: AppColors.primary,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 40),

                const Text(
                  '正在分析中...',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onBackground,
                  ),
                ),
                const SizedBox(height: 24),

                // Progress bar
                AnimatedBuilder(
                  animation: _progressAnimation,
                  builder: (context, child) {
                    return Container(
                      height: 6,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.divider,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: _progressAnimation.value,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                AppColors.primary,
                                AppColors.primaryDark,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 32),

                // Analysis steps
                ...List.generate(_steps.length, (index) {
                  final isActive = index <= _currentStep;
                  final isCurrent = index == _currentStep;
                  return AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: isActive ? 1.0 : 0.3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isCurrent
                                ? Icons.radio_button_checked
                                : isActive
                                    ? Icons.check_circle
                                    : Icons.radio_button_unchecked,
                            size: 18,
                            color: isActive
                                ? AppColors.primary
                                : AppColors.textSecondary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _steps[index],
                            style: TextStyle(
                              fontSize: 15,
                              color: isActive
                                  ? AppColors.onBackground
                                  : AppColors.textSecondary,
                              fontWeight:
                                  isCurrent ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
