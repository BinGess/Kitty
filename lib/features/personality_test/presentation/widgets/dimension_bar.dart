import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/models/question.dart';

class DimensionBar extends StatelessWidget {
  final Dimension dimension;
  final int score;
  final int maxScore;

  const DimensionBar({
    super.key,
    required this.dimension,
    required this.score,
    required this.maxScore,
  });

  @override
  Widget build(BuildContext context) {
    final leftPercent = maxScore > 0 ? score / maxScore : 0.5;
    final rightPercent = 1.0 - leftPercent;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${dimension.leftLabel} ${dimension.leftName}',
              style: TextStyle(
                fontSize: 13,
                fontWeight:
                    leftPercent > 0.5 ? FontWeight.w600 : FontWeight.normal,
                color: leftPercent > 0.5
                    ? AppColors.primary
                    : AppColors.textSecondary,
              ),
            ),
            Text(
              '${dimension.rightName} ${dimension.rightLabel}',
              style: TextStyle(
                fontSize: 13,
                fontWeight:
                    rightPercent > 0.5 ? FontWeight.w600 : FontWeight.normal,
                color: rightPercent > 0.5
                    ? AppColors.primary
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              flex: (leftPercent * 100).round().clamp(10, 90),
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  color: leftPercent >= 0.5
                      ? AppColors.primary
                      : AppColors.primary.withValues(alpha: 0.25),
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(4),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 2),
            Expanded(
              flex: (rightPercent * 100).round().clamp(10, 90),
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  color: rightPercent > 0.5
                      ? AppColors.primaryDark
                      : AppColors.primaryDark.withValues(alpha: 0.25),
                  borderRadius: const BorderRadius.horizontal(
                    right: Radius.circular(4),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${(leftPercent * 100).round()}%',
              style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
            Text(
              '${(rightPercent * 100).round()}%',
              style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
          ],
        ),
      ],
    );
  }
}
