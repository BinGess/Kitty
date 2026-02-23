import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/database/app_database.dart';
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
  String? _lastDate;

  final _intCtrl = FixedExtentScrollController(initialItem: 4);
  final _decCtrl = FixedExtentScrollController(initialItem: 50);

  static const _moods = [
    ('😊', '配合'),
    ('😐', '一般'),
    ('😾', '暴躁'),
  ];

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
      if (last != null && mounted) {
        final days = DateTime.now().difference(last.recordedAt).inDays;
        setState(() {
          _lastWeight = last.weightKg;
          _lastDate = days == 0 ? '今天' : '$days天前';
          _intPart = last.weightKg.floor();
          _decPart = ((last.weightKg - _intPart) * 100).round();
          _intCtrl.jumpToItem(_intPart);
          _decCtrl.jumpToItem(_decPart);
        });
      }
    } catch (_) {}
  }

  double get _currentWeight => _intPart + _decPart / 100.0;

  Future<void> _save() async {
    final cat = ref.read(currentCatProvider);
    if (cat == null) {
      _showError('请先添加一只猫咪');
      return;
    }
    try {
      final dao = ref.read(healthDaoProvider);
      await dao.insertWeightRecord(WeightRecordsCompanion(
        catId: Value(cat.id),
        weightKg: Value(_currentWeight),
        moodAnnotation: Value(_mood),
        recordedAt: Value(DateTime.now()),
      ));
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      _showError('保存失败：$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final diff = _lastWeight != null ? _currentWeight - _lastWeight! : null;

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
          const Text('⚖️ 体重记录',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onBackground)),
          if (_lastWeight != null) ...[
            const SizedBox(height: 6),
            Text(
              '上次记录：${_lastWeight!.toStringAsFixed(2)}kg（$_lastDate）',
              style: const TextStyle(
                  fontSize: 12, color: AppColors.textSecondary),
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
                  child: Text('.',
                      style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onBackground)),
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
                  child: Text('kg',
                      style: TextStyle(
                          fontSize: 18, color: AppColors.textSecondary)),
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
          const Align(
            alignment: Alignment.centerLeft,
            child: Text('称重配合度',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary)),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _moods.map((m) {
              final sel = _mood == m.$2;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: GestureDetector(
                  onTap: () => setState(() => _mood = sel ? null : m.$2),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                        Text(m.$1, style: const TextStyle(fontSize: 24)),
                        const SizedBox(height: 2),
                        Text(
                          m.$2,
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
            }).toList(),
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
                    borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: const Text('保存',
                  style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  void _showError(String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('提示'),
        content: Text(message),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('确定'),
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
