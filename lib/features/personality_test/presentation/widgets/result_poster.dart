import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../data/models/personality_type.dart';
import '../../data/models/question.dart';
import 'dimension_bar.dart';

class ResultPoster extends StatelessWidget {
  final TestResult result;

  const ResultPoster({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final personality = result.personality;

    return Container(
      margin: const EdgeInsets.only(top: 60),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusXLarge),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.spacingL),
              child: Column(
                children: [
                  const Text(
                    '我的猫咪性格报告',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingM),

                  // Poster content (screenshot-able area)
                  _PosterContent(
                    personality: personality,
                    result: result,
                  ),

                  const SizedBox(height: AppDimensions.spacingL),

                  // Save / share buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // TODO: Save to gallery
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('海报保存功能开发中...')),
                            );
                          },
                          icon: const Icon(Icons.save_alt),
                          label: const Text('保存到相册'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: const BorderSide(color: AppColors.primary),
                            foregroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusMedium),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppDimensions.spacingM),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () {
                            // TODO: Share
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('分享功能开发中...')),
                            );
                          },
                          icon: const Icon(Icons.share),
                          label: const Text('分享给好友'),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusMedium),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.spacingM),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PosterContent extends StatelessWidget {
  final PersonalityType personality;
  final TestResult result;

  const _PosterContent({
    required this.personality,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.spacingL),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Cat icon
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.pets,
              size: 36,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),

          // Code + title
          Text(
            personality.code,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            personality.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.onBackground,
            ),
          ),
          const SizedBox(height: 12),

          // Tags
          Wrap(
            spacing: 6,
            children: personality.tags.map((tag) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  tag,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.primaryDark,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Dimension bars
          ...Dimension.values.map((dim) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: DimensionBar(
                dimension: dim,
                score: result.dimensionScores[dim.name] ?? 0,
                maxScore: result.maxScores[dim.name] ?? 3,
              ),
            );
          }),

          const SizedBox(height: 12),

          // Quote
          Text(
            personality.quote,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 16),
          const Divider(color: AppColors.divider),
          const SizedBox(height: 8),

          // Branding
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.pets, size: 14, color: AppColors.primary),
              const SizedBox(width: 4),
              Text(
                '猫咪语言 · 16喵格测试',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
