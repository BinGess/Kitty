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

  const HealthTimelineEntry({
    required this.id,
    required this.type,
    required this.recordedAt,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.isWarning = false,
  });
}

/// 仪表盘摘要数据
class HealthSummary {
  final double? latestWeight;
  final double? weightChange;
  final double todayWaterMl;
  final double targetWaterMl;
  final int todayMeals;
  final int targetMeals;
  final bool hasWeightWarning;

  const HealthSummary({
    this.latestWeight,
    this.weightChange,
    this.todayWaterMl = 0,
    this.targetWaterMl = 200,
    this.todayMeals = 0,
    this.targetMeals = 3,
    this.hasWeightWarning = false,
  });
}

/// 排泄状态文案映射
class ExcretionLabels {
  static const Map<int, String> bristolLabels = {
    1: '干燥球状',
    2: '完美香蕉',
    3: '软便无形',
    4: '水样拉稀',
  };
  static const Map<int, String> urineLabels = {
    1: '小团',
    2: '中团',
    3: '大团',
  };

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
