import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/providers/current_cat_provider.dart';
import '../../../../core/providers/database_provider.dart';

class DietRecordSheet extends ConsumerStatefulWidget {
  const DietRecordSheet({super.key});

  @override
  ConsumerState<DietRecordSheet> createState() => _DietRecordSheetState();
}

class _DietRecordSheetState extends ConsumerState<DietRecordSheet> {
  double _amount = 50;
  String _selectedBrand = '渴望';
  String _foodType = '主粮';
  DateTime _time = DateTime.now();
  bool _loadedLast = false;
  int _todayMeals = 0;
  int _mealTarget = 3;

  static const _brands = ['渴望', '巅峰', '皇家', '自制', '零食', '其他'];
  static const _types = ['主粮', '罐头', '零食', '冻干'];

  @override
  void initState() {
    super.initState();
    _loadLastRecord();
  }

  Future<void> _loadLastRecord() async {
    try {
      final cat = ref.read(currentCatProvider);
      if (cat == null) return;
      final dao = ref.read(healthDaoProvider);
      final last = await dao.getLatestDietRecord(cat.id);
      final today = await dao.getTodayDietRecords(cat.id);
      if (!mounted) return;
      setState(() {
        _todayMeals = today.length;
        _mealTarget = cat.targetMealsPerDay;
      });
      if (last != null) {
        setState(() {
          _amount = last.amountGrams;
          _selectedBrand = last.brandTag ?? _selectedBrand;
          _foodType = last.foodType;
          _loadedLast = true;
        });
      }
    } catch (_) {}
  }

  Future<void> _save() async {
    final cat = ref.read(currentCatProvider);
    if (cat == null) {
      _showError('请先添加一只猫咪');
      return;
    }

    if (_amount > 500) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('确认'),
          content: Text('输入的数值较大（${_amount.toStringAsFixed(0)}g），确定吗？'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('确定'),
            ),
          ],
        ),
      );
      if (confirm != true) return;
    }

    try {
      final dao = ref.read(healthDaoProvider);
      await dao.insertDietRecord(
        DietRecordsCompanion(
          catId: Value(cat.id),
          brandTag: Value(_selectedBrand),
          amountGrams: Value(_amount),
          foodType: Value(_foodType),
          recordedAt: Value(_time),
        ),
      );
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      _showError('保存失败：$e');
    }
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

  @override
  Widget build(BuildContext context) {
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
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _handle(),
            const SizedBox(height: 12),
            const Text(
              '🍚 饮食记录',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.onBackground,
              ),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: _mealTarget > 0
                    ? ((_todayMeals + 1) / _mealTarget).clamp(0.0, 1.0)
                    : 0.0,
                minHeight: 8,
                backgroundColor: AppColors.divider,
                valueColor: const AlwaysStoppedAnimation(AppColors.primary),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '今日喂食：${_todayMeals + 1}/$_mealTarget 次（保存后）',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            _sectionLabel('品牌/种类'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _brands.map((b) {
                final sel = b == _selectedBrand;
                return ChoiceChip(
                  label: Text(b),
                  selected: sel,
                  onSelected: (_) => setState(() => _selectedBrand = b),
                  selectedColor: AppColors.primary.withValues(alpha: 0.2),
                  backgroundColor: AppColors.surface,
                  labelStyle: TextStyle(
                    color: sel ? AppColors.primaryDark : AppColors.onSurface,
                    fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: sel ? AppColors.primary : AppColors.divider,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            _sectionLabel('食物类型'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _types.map((t) {
                final sel = t == _foodType;
                return ChoiceChip(
                  label: Text(t),
                  selected: sel,
                  onSelected: (_) => setState(() => _foodType = t),
                  selectedColor: AppColors.primary.withValues(alpha: 0.2),
                  backgroundColor: AppColors.surface,
                  labelStyle: TextStyle(
                    color: sel ? AppColors.primaryDark : AppColors.onSurface,
                    fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: sel ? AppColors.primary : AppColors.divider,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            _sectionLabel('进食量 (g)'),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _stepButton(Icons.remove, () {
                  if (_amount > 5) setState(() => _amount -= 5);
                }),
                const SizedBox(width: 24),
                Text(
                  '${_amount.toStringAsFixed(0)}g',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onBackground,
                  ),
                ),
                const SizedBox(width: 24),
                _stepButton(Icons.add, () {
                  setState(() => _amount += 5);
                }),
              ],
            ),
            if (_loadedLast)
              const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  '同前一次记录',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            const SizedBox(height: 20),
            _timeSelector(),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  '保存',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
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

  Widget _sectionLabel(String text) => Align(
    alignment: Alignment.centerLeft,
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
      ),
    ),
  );

  Widget _stepButton(IconData icon, VoidCallback onTap) => Material(
    color: AppColors.surface,
    shape: const CircleBorder(),
    child: InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 44,
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.divider),
        ),
        child: Icon(icon, color: AppColors.primary),
      ),
    ),
  );

  Widget _timeSelector() => GestureDetector(
    onTap: () async {
      final picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_time),
      );
      if (picked != null) {
        setState(() {
          _time = DateTime(
            _time.year,
            _time.month,
            _time.day,
            picked.hour,
            picked.minute,
          );
        });
      }
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.access_time,
            size: 18,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: 8),
          Text(
            '${_time.hour.toString().padLeft(2, '0')}:${_time.minute.toString().padLeft(2, '0')}',
            style: const TextStyle(fontSize: 15, color: AppColors.onBackground),
          ),
          const Spacer(),
          const Text(
            '点击修改时间',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
        ],
      ),
    ),
  );
}
