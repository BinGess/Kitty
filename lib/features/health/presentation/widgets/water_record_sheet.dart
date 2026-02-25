import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/providers/current_cat_provider.dart';
import '../../../../core/providers/database_provider.dart';

class WaterRecordSheet extends ConsumerStatefulWidget {
  const WaterRecordSheet({super.key});

  @override
  ConsumerState<WaterRecordSheet> createState() => _WaterRecordSheetState();
}

class _WaterRecordSheetState extends ConsumerState<WaterRecordSheet> {
  double _amount = 50;
  double _todayTotal = 0;
  double _target = 200;

  static const _quickAmounts = [20.0, 50.0, 100.0, 200.0];

  @override
  void initState() {
    super.initState();
    _loadToday();
  }

  Future<void> _loadToday() async {
    try {
      final cat = ref.read(currentCatProvider);
      if (cat == null) return;
      final dao = ref.read(healthDaoProvider);
      final total = await dao.getTodayWaterTotal(cat.id);
      if (mounted) {
        setState(() {
          _todayTotal = total;
          _target = cat.targetWaterMl;
        });
      }
    } catch (_) {}
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;
    final cat = ref.read(currentCatProvider);
    if (cat == null) {
      _showError(l10n.commonNoCat);
      return;
    }
    try {
      final dao = ref.read(healthDaoProvider);
      await dao.insertWaterRecord(WaterRecordsCompanion(
        catId: Value(cat.id),
        amountMl: Value(_amount),
        recordedAt: Value(DateTime.now()),
      ));
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        _showError(
            AppLocalizations.of(context)!.commonSaveFailed(e.toString()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final quickLabels = [
      l10n.waterQuickSmall,
      l10n.waterQuickHalf,
      l10n.waterQuickOne,
      l10n.waterQuickFull,
    ];
    final newTotal = _todayTotal + _amount;
    final ratio = _target > 0 ? (newTotal / _target).clamp(0.0, 1.0) : 0.0;

    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _handle(),
          const SizedBox(height: 12),
          Text(
            l10n.waterSheetTitle,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.onBackground),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(_quickAmounts.length, (i) {
              final sel = _amount == _quickAmounts[i];
              return GestureDetector(
                onTap: () => setState(() => _amount = _quickAmounts[i]),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: sel
                        ? AppColors.info.withValues(alpha: 0.15)
                        : AppColors.surface,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: sel ? AppColors.info : AppColors.divider,
                      width: sel ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _quickAmounts[i].toStringAsFixed(0),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: sel ? AppColors.info : AppColors.onSurface,
                        ),
                      ),
                      Text(
                        quickLabels[i],
                        style: TextStyle(
                          fontSize: 9,
                          color: sel
                              ? AppColors.info
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 24),
          Text(
            '${_amount.toStringAsFixed(0)}ml',
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w700,
              color: AppColors.onBackground,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SliderTheme(
              data: SliderThemeData(
                activeTrackColor: AppColors.info,
                inactiveTrackColor: AppColors.info.withValues(alpha: 0.15),
                thumbColor: AppColors.info,
                overlayColor: AppColors.info.withValues(alpha: 0.1),
                trackHeight: 6,
              ),
              child: Slider(
                min: 5,
                max: 300,
                divisions: 59,
                value: _amount,
                onChanged: (v) =>
                    setState(() => _amount = v.roundToDouble()),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 10,
              backgroundColor: AppColors.divider,
              valueColor: const AlwaysStoppedAnimation(AppColors.info),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.waterTodayTarget(
              newTotal.toStringAsFixed(0),
              _target.toStringAsFixed(0),
            ),
            style: const TextStyle(
                fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.info,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: Text(
                l10n.commonSave,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showError(String message) {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.commonTip),
        content: Text(message),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.commonOk),
          ),
        ],
      ),
    );
  }

  Widget _handle() => Center(
        child: Container(
          width: 36,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.divider,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      );
}
