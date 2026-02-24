import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/models/health_record.dart';

class SummaryCards extends StatelessWidget {
  final HealthSummary summary;
  const SummaryCards({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _WeightCard(summary: summary)),
        const SizedBox(width: 10),
        Expanded(child: _WaterCard(summary: summary)),
        const SizedBox(width: 10),
        Expanded(child: _DietCard(summary: summary)),
      ],
    );
  }
}

class _WeightCard extends StatelessWidget {
  final HealthSummary summary;
  const _WeightCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    final change = summary.weightChange;
    final hasGoal =
        summary.weightGoalMinKg != null || summary.weightGoalMaxKg != null;
    return _SummaryCardBase(
      icon: Icons.monitor_weight_outlined,
      iconColor: const Color(0xFFAB47BC),
      label: '体重',
      hasWarning: summary.hasWeightWarning,
      value: summary.latestWeight != null
          ? summary.latestWeight!.toStringAsFixed(1)
          : '--',
      unit: 'kg',
      footer: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          change != null
              ? Row(
                  children: [
                    Icon(
                      change >= 0 ? Icons.trending_up : Icons.trending_down,
                      size: 12,
                      color: change >= 0 ? AppColors.error : AppColors.success,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '${change.abs().toStringAsFixed(1)}kg',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: change >= 0
                            ? AppColors.error
                            : AppColors.success,
                      ),
                    ),
                  ],
                )
              : const Text(
                  '暂无变化',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
          if (hasGoal) ...[
            const SizedBox(height: 3),
            Text(
              _buildGoalText(summary),
              style: TextStyle(
                fontSize: 10,
                color: summary.isWeightOutOfGoal
                    ? AppColors.warning
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _buildGoalText(HealthSummary summary) {
    final min = summary.weightGoalMinKg;
    final max = summary.weightGoalMaxKg;
    String base = '';
    if (min != null && max != null) {
      base = '目标 ${min.toStringAsFixed(1)}-${max.toStringAsFixed(1)}kg';
    } else if (min != null) {
      base = '目标 >= ${min.toStringAsFixed(1)}kg';
    } else if (max != null) {
      base = '目标 <= ${max.toStringAsFixed(1)}kg';
    }
    if (base.isEmpty || !summary.isWeightOutOfGoal) return base;
    return '$base（当前超出）';
  }
}

class _WaterCard extends StatelessWidget {
  final HealthSummary summary;
  const _WaterCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    final ratio = summary.targetWaterMl > 0
        ? (summary.todayWaterMl / summary.targetWaterMl).clamp(0.0, 1.0)
        : 0.0;
    return _SummaryCardBase(
      icon: Icons.water_drop_outlined,
      iconColor: AppColors.info,
      label: '饮水',
      value: summary.todayWaterMl.toStringAsFixed(0),
      unit: 'ml',
      footer: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 5,
              backgroundColor: AppColors.divider,
              valueColor: const AlwaysStoppedAnimation(AppColors.info),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            '目标 ${summary.targetWaterMl.toStringAsFixed(0)}ml',
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _DietCard extends StatelessWidget {
  final HealthSummary summary;
  const _DietCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    return _SummaryCardBase(
      icon: Icons.restaurant,
      iconColor: AppColors.primary,
      label: '饮食',
      value: '${summary.todayMeals}',
      unit: '/${summary.targetMeals}次',
      footer: Text(
        summary.todayMeals >= summary.targetMeals ? '已完成' : '进行中',
        style: TextStyle(
          fontSize: 11,
          color: summary.todayMeals >= summary.targetMeals
              ? AppColors.success
              : AppColors.textSecondary,
        ),
      ),
    );
  }
}

/// 统一的卡片基础布局：
///   图标 + 标签 (顶部行)
///   数值 + 单位 (中间主体, 统一的 fontSize/baseline)
///   footer 小组件 (底部)
class _SummaryCardBase extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String unit;
  final Widget footer;
  final bool hasWarning;

  const _SummaryCardBase({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.unit,
    required this.footer,
    this.hasWarning = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: hasWarning
            ? Border.all(color: AppColors.warning, width: 1.5)
            : null,
        boxShadow: [
          BoxShadow(
            color: AppColors.onBackground.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 顶部：图标 + 标签
          Row(
            children: [
              Icon(icon, size: 14, color: iconColor),
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              if (hasWarning) ...[
                const Spacer(),
                const Icon(
                  Icons.warning_amber_rounded,
                  size: 14,
                  color: AppColors.warning,
                ),
              ],
            ],
          ),
          const SizedBox(height: 10),

          // 中间：数值 + 单位 (统一 baseline 对齐)
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onBackground,
                  height: 1.0,
                ),
              ),
              const SizedBox(width: 2),
              Text(
                unit,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  height: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // 底部：footer
          footer,
        ],
      ),
    );
  }
}
