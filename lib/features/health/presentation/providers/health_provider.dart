import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/providers/current_cat_provider.dart';
import '../../../../core/providers/database_provider.dart';
import '../../data/models/health_record.dart';

final healthSummaryProvider = FutureProvider.autoDispose<HealthSummary>((
  ref,
) async {
  final cat = ref.watch(currentCatProvider);
  if (cat == null) return const HealthSummary();
  final dao = ref.read(healthDaoProvider);

  final latestWeight = await dao.getLatestWeight(cat.id);
  double? weightChange;
  bool hasTrendWarning = false;
  bool isOutOfGoal = false;
  if (latestWeight != null) {
    final percent = await dao.getWeightChangePercent(
      cat.id,
      const Duration(days: 30),
    );
    if (percent != null && percent.abs() > 5) hasTrendWarning = true;
    final weights = await dao.getWeightTrendData(cat.id, 30);
    if (weights.length >= 2) {
      weightChange =
          weights.last.weightKg - weights[weights.length - 2].weightKg;
    }

    final minGoal = cat.weightGoalMinKg;
    final maxGoal = cat.weightGoalMaxKg;
    if (minGoal != null && latestWeight.weightKg < minGoal) {
      isOutOfGoal = true;
    }
    if (maxGoal != null && latestWeight.weightKg > maxGoal) {
      isOutOfGoal = true;
    }
  }

  final todayWater = await dao.getTodayWaterTotal(cat.id);
  final todayDiet = await dao.getTodayDietRecords(cat.id);

  return HealthSummary(
    latestWeight: latestWeight?.weightKg,
    weightChange: weightChange,
    weightGoalMinKg: cat.weightGoalMinKg,
    weightGoalMaxKg: cat.weightGoalMaxKg,
    todayWaterMl: todayWater,
    targetWaterMl: cat.targetWaterMl,
    todayMeals: todayDiet.length,
    targetMeals: cat.targetMealsPerDay,
    isWeightOutOfGoal: isOutOfGoal,
    hasWeightWarning: hasTrendWarning || isOutOfGoal,
  );
});

final healthTimelineProvider =
    FutureProvider.autoDispose<List<HealthTimelineEntry>>((ref) async {
      final cat = ref.watch(currentCatProvider);
      if (cat == null) return [];
      final dao = ref.read(healthDaoProvider);

      final weights = await dao.getWeightTrendData(cat.id, 7);
      final todayDiet = await dao.getTodayDietRecords(cat.id);
      final waterRecords = await dao.getTodayWaterRecords(cat.id);
      final excRecords = await dao.getTodayExcretionRecords(cat.id);

      final entries = <HealthTimelineEntry>[];

      for (final w in weights) {
        entries.add(
          HealthTimelineEntry(
            id: w.id,
            type: HealthRecordType.weight,
            recordedAt: w.recordedAt,
            title: '称重 ${w.weightKg.toStringAsFixed(2)}kg',
            subtitle: w.moodAnnotation ?? '',
            icon: Icons.monitor_weight_outlined,
            color: AppColors.info,
          ),
        );
      }
      for (final d in todayDiet) {
        entries.add(
          HealthTimelineEntry(
            id: d.id,
            type: HealthRecordType.diet,
            recordedAt: d.recordedAt,
            title: '干饭时刻 ${d.amountGrams.toStringAsFixed(0)}g',
            subtitle: d.brandTag ?? d.foodType,
            icon: Icons.restaurant,
            color: AppColors.primary,
          ),
        );
      }
      for (final w in waterRecords) {
        entries.add(
          HealthTimelineEntry(
            id: w.id,
            type: HealthRecordType.water,
            recordedAt: w.recordedAt,
            title: '饮水 ${w.amountMl.toStringAsFixed(0)}ml',
            subtitle: '',
            icon: Icons.water_drop_outlined,
            color: AppColors.info,
          ),
        );
      }
      for (final e in excRecords) {
        final isP = e.excretionType == 'poop';
        final label = isP
            ? ExcretionLabels.bristolLabels[e.bristolScale] ?? '排便'
            : ExcretionLabels.urineLabels[e.urineAmount] ?? '排尿';
        entries.add(
          HealthTimelineEntry(
            id: e.id,
            type: HealthRecordType.excretion,
            recordedAt: e.recordedAt,
            title: isP ? '排便' : '排尿',
            subtitle: label,
            icon: isP ? Icons.circle : Icons.water_drop,
            color: (e.hasBlood || e.hasAnomaly)
                ? AppColors.error
                : AppColors.success,
            isWarning: e.hasBlood || e.hasAnomaly,
          ),
        );
      }

      entries.sort((a, b) => b.recordedAt.compareTo(a.recordedAt));
      return entries;
    });
