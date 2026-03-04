import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

enum HealthRecordType { diet, water, weight, excretion }

/// 统一的健康记录时间轴条目（聚合 4 种记录类型）
class HealthTimelineEntry {
  final int id;
  final HealthRecordType type;
  final DateTime recordedAt;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool isWarning;
  // Raw numeric value for widget-layer localization (weight kg, water ml, diet g, bristol/urine scale)
  final double? numericValue;
  // 'poop' | 'urine' for excretion entries
  final String? subtype;

  const HealthTimelineEntry({
    required this.id,
    required this.type,
    required this.recordedAt,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.isWarning = false,
    this.numericValue,
    this.subtype,
  });
}

/// 仪表盘摘要数据
class HealthSummary {
  final double? latestWeight;
  final double? weightChange;
  final double? weightGoalMinKg;
  final double? weightGoalMaxKg;
  final double todayWaterMl;
  final double targetWaterMl;
  final int todayMeals;
  final int targetMeals;
  final bool isWeightOutOfGoal;
  final bool hasWeightWarning;
  final int todayPlaySessions;
  final int todayPlayCaptures;
  final int playCaptureGoal;
  final int playRewardWaterMlToday;
  final int playRewardWaterLoggedMlToday;
  final int playRewardWaterPendingMl;
  final int nextPlayRewardWaterMl;
  final int playReminderIntervalMinutes;
  final String playReminderSuggestion;
  final String playModeLabel;
  final String playModeDescription;
  final String playModeKey;

  const HealthSummary({
    this.latestWeight,
    this.weightChange,
    this.weightGoalMinKg,
    this.weightGoalMaxKg,
    this.todayWaterMl = 0,
    this.targetWaterMl = 200,
    this.todayMeals = 0,
    this.targetMeals = 3,
    this.isWeightOutOfGoal = false,
    this.hasWeightWarning = false,
    this.todayPlaySessions = 0,
    this.todayPlayCaptures = 0,
    this.playCaptureGoal = 4,
    this.playRewardWaterMlToday = 0,
    this.playRewardWaterLoggedMlToday = 0,
    this.playRewardWaterPendingMl = 0,
    this.nextPlayRewardWaterMl = 16,
    this.playReminderIntervalMinutes = 120,
    this.playReminderSuggestion = '',
    this.playModeLabel = '自动',
    this.playModeDescription = '',
    this.playModeKey = 'auto',
  });

  bool get isPlayGoalReached => todayPlayCaptures >= playCaptureGoal;

  double get playProgress {
    if (playCaptureGoal <= 0) return 1;
    return (todayPlayCaptures / playCaptureGoal).clamp(0, 1).toDouble();
  }
}

/// 排泄图标/颜色辅助
class ExcretionLabels {
  static IconData iconForBristol(int scale) {
    switch (scale) {
      case 1:
        return Icons.circle;
      case 2:
        return Icons.check_circle;
      case 3:
        return Icons.water_drop;
      case 4:
        return Icons.warning_amber;
      default:
        return Icons.help_outline;
    }
  }

  static Color colorForBristol(int scale) {
    switch (scale) {
      case 1:
        return AppColors.warning;
      case 2:
        return AppColors.success;
      case 3:
        return AppColors.info;
      case 4:
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }
}
