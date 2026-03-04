import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../data/models/health_record.dart';
import '../providers/health_provider.dart';

class HealthDailyHistoryScreen extends ConsumerStatefulWidget {
  final HealthMetricType initialMetric;

  const HealthDailyHistoryScreen({super.key, required this.initialMetric});

  @override
  ConsumerState<HealthDailyHistoryScreen> createState() =>
      _HealthDailyHistoryScreenState();
}

class _HealthDailyHistoryScreenState
    extends ConsumerState<HealthDailyHistoryScreen> {
  late HealthMetricType _metric;

  @override
  void initState() {
    super.initState();
    _metric = widget.initialMetric;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dailyAsync = ref.watch(healthDailySummaryProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          '${_metricLabel(l10n, _metric)} · ${l10n.healthTitle}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.onBackground,
          ),
        ),
      ),
      body: dailyAsync.when(
        data: (days) {
          if (days.isEmpty) {
            return Center(
              child: Text(
                l10n.healthTimelineEmpty,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            );
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _MetricSwitch(
                  metric: _metric,
                  onChanged: (m) => setState(() => _metric = m),
                ),
                const SizedBox(height: 12),
                _ChartCard(metric: _metric, days: days),
                const SizedBox(height: 16),
                ...days.map((d) => _DailySummaryCard(day: d)),
              ],
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (error, stackTrace) => const SizedBox.shrink(),
      ),
    );
  }

  String _metricLabel(AppLocalizations l10n, HealthMetricType metric) {
    switch (metric) {
      case HealthMetricType.weight:
        return l10n.healthWeight;
      case HealthMetricType.diet:
        return l10n.healthDiet;
      case HealthMetricType.water:
        return l10n.healthWater;
    }
  }
}

class _MetricSwitch extends StatelessWidget {
  final HealthMetricType metric;
  final ValueChanged<HealthMetricType> onChanged;

  const _MetricSwitch({required this.metric, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    Widget chip(HealthMetricType m, String label) {
      final selected = metric == m;
      return Expanded(
        child: GestureDetector(
          onTap: () => onChanged(m),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected
                  ? AppColors.primary.withValues(alpha: 0.14)
                  : AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selected ? AppColors.primary : AppColors.divider,
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected
                    ? AppColors.primaryDark
                    : AppColors.textSecondary,
              ),
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        chip(HealthMetricType.weight, l10n.healthWeight),
        const SizedBox(width: 8),
        chip(HealthMetricType.diet, l10n.healthDiet),
        const SizedBox(width: 8),
        chip(HealthMetricType.water, l10n.healthWater),
      ],
    );
  }
}

class _ChartCard extends StatelessWidget {
  final HealthMetricType metric;
  final List<DailyHealthSummary> days;

  const _ChartCard({required this.metric, required this.days});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final filtered = days.where((d) {
      if (metric == HealthMetricType.weight) return d.weightKg != null;
      return d.metricValue(metric) > 0;
    }).toList();
    final chartDays = filtered.take(14).toList().reversed.toList();

    if (chartDays.isEmpty) {
      return Container(
        width: double.infinity,
        height: 220,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider),
        ),
        child: Text(
          l10n.healthTimelineEmpty,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
      );
    }

    final values = chartDays.map((d) => d.metricValue(metric)).toList();
    final maxV = values.reduce(math.max).toDouble();
    final minV = values.reduce(math.min).toDouble();
    final weightPadding = math.max(0.15, (maxV - minV).abs() * 0.25).toDouble();
    final maxY = metric == HealthMetricType.weight
        ? (maxV + weightPadding).toDouble()
        : math.max(1.0, maxV * 1.2).toDouble();
    final minY = metric == HealthMetricType.weight
        ? math.max(0.0, minV - weightPadding).toDouble()
        : 0.0;
    final yInterval = math.max(0.1, (maxY - minY) / 4).toDouble();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _chartTitle(l10n, metric),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.onBackground,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 170,
            child: LineChart(
              LineChartData(
                minY: minY,
                maxY: maxY,
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  drawVerticalLine: false,
                  horizontalInterval: yInterval,
                  getDrawingHorizontalLine: (_) =>
                      FlLine(color: AppColors.divider, strokeWidth: 1),
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                      interval: yInterval,
                      getTitlesWidget: (value, _) => Text(
                        value.toStringAsFixed(
                          metric == HealthMetricType.weight ? 1 : 0,
                        ),
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, _) {
                        final i = value.toInt();
                        if (i < 0 || i >= chartDays.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            DateFormat('M/d', locale).format(chartDays[i].day),
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      for (int i = 0; i < chartDays.length; i++)
                        FlSpot(i.toDouble(), chartDays[i].metricValue(metric)),
                    ],
                    isCurved: true,
                    color: _metricColor(metric),
                    barWidth: 2.5,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, bar, index) =>
                          FlDotCirclePainter(
                            radius: 3,
                            color: _metricColor(metric),
                            strokeWidth: 1,
                            strokeColor: Colors.white,
                          ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: _metricColor(metric).withValues(alpha: 0.14),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(enabled: false),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _chartTitle(AppLocalizations l10n, HealthMetricType m) {
    switch (m) {
      case HealthMetricType.weight:
        return '${l10n.healthWeight}（kg）';
      case HealthMetricType.diet:
        return '${l10n.healthDiet}（g）';
      case HealthMetricType.water:
        return '${l10n.healthWater}（ml）';
    }
  }

  Color _metricColor(HealthMetricType m) {
    switch (m) {
      case HealthMetricType.weight:
        return const Color(0xFFAB47BC);
      case HealthMetricType.diet:
        return AppColors.primary;
      case HealthMetricType.water:
        return AppColors.info;
    }
  }
}

class _DailySummaryCard extends StatelessWidget {
  final DailyHealthSummary day;

  const _DailySummaryCard({required this.day});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final dateText = locale.startsWith('zh')
        ? DateFormat('M月d日 EEEE', locale).format(day.day)
        : DateFormat.yMMMd(locale).format(day.day);

    String weightText = day.weightKg == null
        ? '--'
        : '${day.weightKg!.toStringAsFixed(2)}kg';
    String dietText =
        '${day.dietCount} × ${day.dietTotalGrams.toStringAsFixed(0)}g';
    String waterText = '${day.waterTotalMl.toStringAsFixed(0)}ml';

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dateText,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.onBackground,
            ),
          ),
          const SizedBox(height: 10),
          _DailyMetricRow(
            icon: Icons.monitor_weight_outlined,
            color: const Color(0xFFAB47BC),
            label: l10n.healthWeight,
            value: weightText,
          ),
          const SizedBox(height: 6),
          _DailyMetricRow(
            icon: Icons.restaurant,
            color: AppColors.primary,
            label: l10n.healthDiet,
            value: dietText,
          ),
          const SizedBox(height: 6),
          _DailyMetricRow(
            icon: Icons.water_drop_outlined,
            color: AppColors.info,
            label: l10n.healthWater,
            value: waterText,
          ),
        ],
      ),
    );
  }
}

class _DailyMetricRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String value;

  const _DailyMetricRow({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.onBackground,
          ),
        ),
      ],
    );
  }
}
