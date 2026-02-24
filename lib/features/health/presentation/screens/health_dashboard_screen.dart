import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/providers/current_cat_provider.dart';
import '../../../../core/providers/database_provider.dart';
import '../../data/models/health_record.dart';
import '../providers/health_provider.dart';
import '../widgets/diet_record_sheet.dart';
import '../widgets/excretion_record_sheet.dart';
import '../widgets/health_fab.dart';
import '../widgets/health_timeline.dart';
import '../widgets/summary_cards.dart';
import '../widgets/water_record_sheet.dart';
import '../widgets/weight_record_sheet.dart';

class HealthDashboardScreen extends ConsumerStatefulWidget {
  const HealthDashboardScreen({super.key});

  @override
  ConsumerState<HealthDashboardScreen> createState() =>
      _HealthDashboardScreenState();
}

class _HealthDashboardScreenState
    extends ConsumerState<HealthDashboardScreen> {
  void _refresh() {
    ref.invalidate(healthSummaryProvider);
    ref.invalidate(healthTimelineProvider);
  }

  Future<void> _showSheet(Widget sheet) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => sheet,
    );
    if (result == true) _refresh();
  }

  Future<void> _deleteEntry(HealthTimelineEntry entry) async {
    final dao = ref.read(healthDaoProvider);
    switch (entry.type) {
      case HealthRecordType.diet:
        await dao.deleteDietRecord(entry.id);
      case HealthRecordType.water:
        await dao.deleteWaterRecord(entry.id);
      case HealthRecordType.weight:
        await dao.deleteWeightRecord(entry.id);
      case HealthRecordType.excretion:
        await dao.deleteExcretionRecord(entry.id);
    }
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final cat = ref.watch(currentCatProvider);
    final summaryAsync = ref.watch(healthSummaryProvider);
    final timelineAsync = ref.watch(healthTimelineProvider);

    if (cat == null) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: AppColors.primary),
              SizedBox(height: 16),
              Text('正在准备...', style: TextStyle(color: AppColors.textSecondary)),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(cat),
                        const SizedBox(height: 20),
                        summaryAsync.when(
                          data: (s) => SummaryCards(summary: s),
                          loading: () => const SizedBox(
                              height: 100,
                              child: Center(
                                  child: CircularProgressIndicator(
                                      color: AppColors.primary))),
                          error: (_, __) => const SizedBox(height: 100),
                        ),
                        const SizedBox(height: 24),
                        _sectionTitle(),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                  sliver: SliverToBoxAdapter(
                    child: timelineAsync.when(
                      data: (entries) => HealthTimeline(
                        entries: entries,
                        onDelete: _deleteEntry,
                      ),
                      loading: () => const Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: Center(
                            child: CircularProgressIndicator(
                                color: AppColors.primary)),
                      ),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              right: 20,
              bottom: 20,
              child: HealthFab(
                onDiet: () => _showSheet(const DietRecordSheet()),
                onWater: () => _showSheet(const WaterRecordSheet()),
                onWeight: () => _showSheet(const WeightRecordSheet()),
                onExcretion: () =>
                    _showSheet(const ExcretionRecordSheet()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Cat? cat) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.monitor_heart_outlined,
              color: AppColors.primaryDark, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cat != null ? '${cat.name}的健康' : '健康记录',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onBackground,
                ),
              ),
              const Text(
                '体重 · 饮食 · 饮水 · 排泄',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        _CatSwitcher(),
      ],
    );
  }

  Widget _sectionTitle() {
    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          '今日记录',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.onBackground,
          ),
        ),
      ],
    );
  }
}

class _CatSwitcher extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cat = ref.watch(currentCatProvider);
    if (cat == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () => _showCatPicker(context, ref),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.pets, size: 14, color: AppColors.primary),
            const SizedBox(width: 4),
            Text(
              cat.name,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(width: 2),
            const Icon(Icons.expand_more,
                size: 16, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }

  void _showCatPicker(BuildContext context, WidgetRef ref) async {
    final cats = await ref.read(catDaoProvider).getAllCats();
    if (!context.mounted || cats.length <= 1) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('切换猫咪',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onBackground)),
            const SizedBox(height: 16),
            ...cats.map((c) => ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.pets,
                        color: AppColors.primaryDark, size: 20),
                  ),
                  title: Text(c.name),
                  trailing: c.id == ref.read(currentCatProvider)?.id
                      ? const Icon(Icons.check_circle,
                          color: AppColors.primary)
                      : null,
                  onTap: () {
                    ref.read(currentCatProvider.notifier).select(c);
                    Navigator.pop(context);
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                )),
            SizedBox(
                height: MediaQuery.of(context).padding.bottom + 8),
          ],
        ),
      ),
    );
  }
}
