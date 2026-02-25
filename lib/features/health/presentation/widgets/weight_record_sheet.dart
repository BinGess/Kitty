import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/providers/current_cat_provider.dart';
import '../../../../core/providers/database_provider.dart';

class WeightRecordSheet extends ConsumerStatefulWidget {
  const WeightRecordSheet({super.key});

  @override
  ConsumerState<WeightRecordSheet> createState() => _WeightRecordSheetState();
}

class _WeightRecordSheetState extends ConsumerState<WeightRecordSheet> {
  int _intPart = 4;
  int _decPart = 50;
  String? _mood;
  double? _lastWeight;
  int? _lastDays;
  double? _goalMinKg;
  double? _goalMaxKg;

  final _intCtrl = FixedExtentScrollController(initialItem: 4);
  final _decCtrl = FixedExtentScrollController(initialItem: 50);

  // Mood keys (stored in DB) + emoji; display labels come from l10n in build
  static const _moodKeys = ['cooperative', 'neutral', 'resistant'];
  static const _moodEmojis = ['😊', '😐', '😾'];

  @override
  void initState() {
    super.initState();
    _loadLast();
  }

  @override
  void dispose() {
    _intCtrl.dispose();
    _decCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadLast() async {
    try {
      final cat = ref.read(currentCatProvider);
      if (cat == null) return;
      final dao = ref.read(healthDaoProvider);
      final last = await dao.getLatestWeight(cat.id);
      if (!mounted) return;
      setState(() {
        _goalMinKg = cat.weightGoalMinKg;
        _goalMaxKg = cat.weightGoalMaxKg;
      });
      if (last != null) {
        final days = DateTime.now().difference(last.recordedAt).inDays;
        setState(() {
          _lastWeight = last.weightKg;
          _lastDays = days;
          _intPart = last.weightKg.floor();
          _decPart = ((last.weightKg - _intPart) * 100).round();
          _intCtrl.jumpToItem(_intPart);
          _decCtrl.jumpToItem(_decPart);
        });
      }
    } catch (_) {}
  }

  double get _currentWeight => _intPart + _decPart / 100.0;

  bool get _isOutOfGoal {
    if (_goalMinKg != null && _currentWeight < _goalMinKg!) return true;
    if (_goalMaxKg != null && _currentWeight > _goalMaxKg!) return true;
    return false;
  }

  String? _buildGoalText(AppLocalizations l10n) {
    if (_goalMinKg == null && _goalMaxKg == null) return null;
    if (_goalMinKg != null && _goalMaxKg != null) {
      return l10n.weightGoalRange(
          _goalMinKg!.toStringAsFixed(1), _goalMaxKg!.toStringAsFixed(1));
    }
    if (_goalMinKg != null) {
      return l10n.weightGoalMinLimit(_goalMinKg!.toStringAsFixed(1));
    }
    return l10n.weightGoalMaxLimit(_goalMaxKg!.toStringAsFixed(1));
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;
    final cat = ref.read(currentCatProvider);
    if (cat == null) {
      _showError(l10n.commonNoCat);
      return;
    }
    if (_isOutOfGoal) {
      final goOn = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l10n.weightOutOfGoalTitle),
          content: Text(
            l10n.weightOutOfGoalContent(_currentWeight.toStringAsFixed(2)),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l10n.commonCancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(l10n.weightContinueSave),
            ),
          ],
        ),
      );
      if (goOn != true) return;
    }
    try {
      final dao = ref.read(healthDaoProvider);
      await dao.insertWeightRecord(
        WeightRecordsCompanion(
          catId: Value(cat.id),
          weightKg: Value(_currentWeight),
          moodAnnotation: Value(_mood),
          recordedAt: Value(DateTime.now()),
        ),
      );
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        _showError(AppLocalizations.of(context)!.commonSaveFailed(e.toString()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final goalText = _buildGoalText(l10n);
    final diff = _lastWeight != null ? _currentWeight - _lastWeight! : null;
    final lastDateText = _lastDays == null
        ? null
        : (_lastDays == 0 ? l10n.weightLastRecordToday : l10n.weightDaysAgo(_lastDays!));
    final moodLabels = [
      l10n.weightMoodCooperative,
      l10n.weightMoodNeutral,
      l10n.weightMoodResistant,
    ];

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
            l10n.weightSheetTitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.onBackground,
            ),
          ),
          if (goalText != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: _isOutOfGoal
                    ? AppColors.warning.withValues(alpha: 0.14)
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: _isOutOfGoal ? AppColors.warning : AppColors.divider,
                ),
              ),
              child: Text(
                _isOutOfGoal
                    ? '$goalText${l10n.weightGoalExceeded}'
                    : goalText,
                style: TextStyle(
                  fontSize: 12,
                  color: _isOutOfGoal
                      ? AppColors.warning
                      : AppColors.textSecondary,
                ),
              ),
            ),
          ],
          if (_lastWeight != null && lastDateText != null) ...[
            const SizedBox(height: 6),
            Text(
              l10n.weightLastRecord(
                  _lastWeight!.toStringAsFixed(2), lastDateText),
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
          const SizedBox(height: 20),
          SizedBox(
            height: 160,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildWheel(
                  controller: _intCtrl,
                  count: 30,
                  onChanged: (v) => setState(() => _intPart = v),
                  suffix: '',
                  width: 60,
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text(
                    '.',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onBackground,
                    ),
                  ),
                ),
                _buildWheel(
                  controller: _decCtrl,
                  count: 100,
                  onChanged: (v) => setState(() => _decPart = v),
                  suffix: '',
                  width: 60,
                  padZero: true,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 4, bottom: 8),
                  child: Text(
                    'kg',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (diff != null) ...[
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  diff >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 16,
                  color: diff >= 0 ? AppColors.error : AppColors.success,
                ),
                Text(
                  '${diff.abs().toStringAsFixed(2)}kg',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: diff >= 0 ? AppColors.error : AppColors.success,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              l10n.weightMoodLabel,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_moodKeys.length, (i) {
              final key = _moodKeys[i];
              final emoji = _moodEmojis[i];
              final label = moodLabels[i];
              final sel = _mood == key;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: GestureDetector(
                  onTap: () => setState(() => _mood = sel ? null : key),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: sel
                          ? AppColors.primary.withValues(alpha: 0.15)
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: sel ? AppColors.primary : AppColors.divider,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(emoji, style: const TextStyle(fontSize: 24)),
                        const SizedBox(height: 2),
                        Text(
                          label,
                          style: TextStyle(
                            fontSize: 11,
                            color: sel
                                ? AppColors.primaryDark
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFAB47BC),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: Text(
                l10n.commonSave,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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

  Widget _buildWheel({
    required FixedExtentScrollController controller,
    required int count,
    required ValueChanged<int> onChanged,
    required String suffix,
    double width = 50,
    bool padZero = false,
  }) {
    return SizedBox(
      width: width,
      child: ListWheelScrollView.useDelegate(
        controller: controller,
        itemExtent: 44,
        physics: const FixedExtentScrollPhysics(),
        perspective: 0.005,
        diameterRatio: 1.5,
        onSelectedItemChanged: onChanged,
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: count,
          builder: (_, index) {
            final label =
                padZero ? index.toString().padLeft(2, '0') : '$index';
            return Center(
              child: Text(
                '$label$suffix',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onBackground,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
