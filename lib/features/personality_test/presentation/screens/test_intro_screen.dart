import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../data/models/question.dart';
import '../providers/test_provider.dart';

class TestIntroScreen extends ConsumerWidget {
  const TestIntroScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('16喵格测试')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spacingM),
        child: Column(
          children: [
            const SizedBox(height: AppDimensions.spacingL),
            // Hero illustration
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.psychology,
                size: 64,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingL),
            const Text(
              '测测你家猫的隐藏性格',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.onBackground,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingS),
            Text(
              '基于 MBTI 理论，通过观察猫咪的日常行为\n揭示它独特的性格密码',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingXL),

            // Mode selection cards
            _ModeCard(
              mode: TestMode.basic,
              icon: Icons.flash_on,
              color: AppColors.primary,
              subtitle: '快速了解猫咪基本性格倾向',
              onTap: () => _startTest(context, ref, TestMode.basic),
            ),
            const SizedBox(height: AppDimensions.spacingM),
            _ModeCard(
              mode: TestMode.advanced,
              icon: Icons.auto_awesome,
              color: AppColors.primaryDark,
              subtitle: '更全面的性格分析，识别双重性格',
              onTap: () => _startTest(context, ref, TestMode.advanced),
            ),

            const SizedBox(height: AppDimensions.spacingXL),

            // Tips
            Container(
              padding: const EdgeInsets.all(AppDimensions.spacingM),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusMedium),
              ),
              child: Row(
                children: [
                  Icon(Icons.tips_and_updates,
                      color: AppColors.primary, size: 20),
                  const SizedBox(width: AppDimensions.spacingS),
                  Expanded(
                    child: Text(
                      '回答时请基于猫咪的日常表现，没有对错之分哦~',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.spacingXL),
          ],
        ),
      ),
    );
  }

  void _startTest(BuildContext context, WidgetRef ref, TestMode mode) {
    ref.read(testProvider.notifier).startTest(mode);
    context.push('/test/question');
  }
}

class _ModeCard extends StatelessWidget {
  final TestMode mode;
  final IconData icon;
  final Color color;
  final String subtitle;
  final VoidCallback onTap;

  const _ModeCard({
    required this.mode,
    required this.icon,
    required this.color,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppDimensions.spacingL),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          border: Border.all(color: AppColors.divider),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusSmall),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: AppDimensions.spacingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        mode.label,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onBackground,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${mode.questionCount}题',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: color,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.divider),
          ],
        ),
      ),
    );
  }
}
