import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/models/health_record.dart';

class SummaryCards extends StatelessWidget {
  final HealthSummary summary;
  const SummaryCards({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Row(
        children: [
          Expanded(child: _WeightCard(summary: summary)),
          const SizedBox(width: 10),
          Expanded(child: _WaterCard(summary: summary)),
          const SizedBox(width: 10),
          Expanded(child: _DietCard(summary: summary)),
        ],
      ),
    );
  }
}

class _WeightCard extends StatelessWidget {
  final HealthSummary summary;
  const _WeightCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    final change = summary.weightChange;
    return _SummaryCardBase(
      icon: Icons.monitor_weight_outlined,
      iconColor: AppColors.info,
      label: '体重',
      hasWarning: summary.hasWeightWarning,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            summary.latestWeight != null
                ? '${summary.latestWeight!.toStringAsFixed(2)}kg'
                : '--',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.onBackground,
            ),
          ),
          if (change != null)
            Text(
              '${change >= 0 ? '↑' : '↓'} ${change.abs().toStringAsFixed(2)}kg',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: change >= 0 ? AppColors.error : AppColors.success,
              ),
            ),
        ],
      ),
    );
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${summary.todayWaterMl.toStringAsFixed(0)}ml',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.onBackground,
            ),
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 6,
              backgroundColor: AppColors.divider,
              valueColor: const AlwaysStoppedAnimation(AppColors.info),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${summary.todayWaterMl.toStringAsFixed(0)}/${summary.targetWaterMl.toStringAsFixed(0)}ml',
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${summary.todayMeals}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.onBackground,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 3, left: 2),
            child: Text(
              '/${summary.targetMeals}次',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCardBase extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final Widget child;
  final bool hasWarning;

  const _SummaryCardBase({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.child,
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
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: iconColor),
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
                const Icon(Icons.warning_amber_rounded,
                    size: 14, color: AppColors.warning),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Expanded(child: child),
        ],
      ),
    );
  }
}
