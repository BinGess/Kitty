import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/providers/current_cat_provider.dart';
import '../../../../core/providers/database_provider.dart';

class ExcretionRecordSheet extends ConsumerStatefulWidget {
  const ExcretionRecordSheet({super.key});

  @override
  ConsumerState<ExcretionRecordSheet> createState() =>
      _ExcretionRecordSheetState();
}

class _ExcretionRecordSheetState extends ConsumerState<ExcretionRecordSheet>
    with SingleTickerProviderStateMixin {
  late final TabController _tabCtrl;
  int? _bristolScale;
  int? _urineAmount;
  bool _hasAnomaly = false;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
    _tabCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  bool get _isPoop => _tabCtrl.index == 0;
  bool get _canSave =>
      (_isPoop && _bristolScale != null) ||
      (!_isPoop && _urineAmount != null);

  Future<void> _save() async {
    final cat = ref.read(currentCatProvider);
    if (cat == null) {
      _showError('请先添加一只猫咪');
      return;
    }
    try {
      final dao = ref.read(healthDaoProvider);
      await dao.insertExcretionRecord(ExcretionRecordsCompanion(
        catId: Value(cat.id),
        excretionType: Value(_isPoop ? 'poop' : 'urine'),
        bristolScale: Value(_isPoop ? _bristolScale : null),
        urineAmount: Value(_isPoop ? null : _urineAmount),
        hasBlood: Value(_hasAnomaly),
        hasAnomaly: Value(_hasAnomaly),
        recordedAt: Value(DateTime.now()),
      ));
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      _showError('保存失败：$e');
    }
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _handle(),
          const SizedBox(height: 12),
          const Text('🐾 排泄记录',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onBackground)),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
            ),
            child: TabBar(
              controller: _tabCtrl,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              labelColor: AppColors.primaryDark,
              unselectedLabelColor: AppColors.textSecondary,
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(text: '粑粑 💩'),
                Tab(text: '尿尿 💧'),
              ],
            ),
          ),
          const SizedBox(height: 24),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: _isPoop ? _poopSelector() : _urineSelector(),
          ),
          const SizedBox(height: 20),
          _anomalyCheckbox(),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _canSave ? _save : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppColors.divider,
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

  Widget _poopSelector() {
    const items = [
      (1, '🔵', '干燥球状', '偏硬，注意饮水'),
      (2, '🟢', '完美香蕉', '健康标准'),
      (3, '🟡', '软便无形', '消化不良'),
      (4, '🔴', '水样拉稀', '建议就医'),
    ];

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: items.map((item) {
        final sel = _bristolScale == item.$1;
        return GestureDetector(
          onTap: () => setState(() => _bristolScale = item.$1),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: (MediaQuery.of(context).size.width - 58) / 2,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: sel
                  ? _poopColor(item.$1).withValues(alpha: 0.1)
                  : AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: sel ? _poopColor(item.$1) : AppColors.divider,
                width: sel ? 2 : 1,
              ),
            ),
            child: Column(
              children: [
                Text(item.$2, style: const TextStyle(fontSize: 28)),
                const SizedBox(height: 6),
                Text(
                  item.$3,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: sel ? _poopColor(item.$1) : AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.$4,
                  style: const TextStyle(
                      fontSize: 10, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Color _poopColor(int scale) {
    switch (scale) {
      case 1:
        return AppColors.warning;
      case 2:
        return AppColors.success;
      case 3:
        return AppColors.primary;
      case 4:
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  Widget _urineSelector() {
    const items = [
      (1, '小团', 48.0),
      (2, '中团', 64.0),
      (3, '大团', 80.0),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: items.map((item) {
        final sel = _urineAmount == item.$1;
        return GestureDetector(
          onTap: () => setState(() => _urineAmount = item.$1),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            child: Column(
              children: [
                Container(
                  width: item.$3,
                  height: item.$3,
                  decoration: BoxDecoration(
                    color: sel
                        ? AppColors.info.withValues(alpha: 0.2)
                        : AppColors.info.withValues(alpha: 0.06),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: sel ? AppColors.info : AppColors.divider,
                      width: sel ? 2.5 : 1,
                    ),
                  ),
                  child: Icon(
                    Icons.water_drop,
                    size: item.$3 * 0.4,
                    color: sel ? AppColors.info : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.$2,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
                    color: sel ? AppColors.info : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _anomalyCheckbox() {
    return GestureDetector(
      onTap: () => setState(() => _hasAnomaly = !_hasAnomaly),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: _hasAnomaly
              ? AppColors.error.withValues(alpha: 0.08)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _hasAnomaly ? AppColors.error : AppColors.divider,
          ),
        ),
        child: Row(
          children: [
            Icon(
              _hasAnomaly
                  ? Icons.check_box
                  : Icons.check_box_outline_blank,
              color: _hasAnomaly ? AppColors.error : AppColors.textSecondary,
              size: 22,
            ),
            const SizedBox(width: 10),
            Text(
              '发现异常（血丝/异物）',
              style: TextStyle(
                fontSize: 14,
                fontWeight: _hasAnomaly ? FontWeight.w600 : FontWeight.w400,
                color: _hasAnomaly ? AppColors.error : AppColors.onSurface,
              ),
            ),
            if (_hasAnomaly) ...[
              const Spacer(),
              const Icon(Icons.warning_amber,
                  size: 18, color: AppColors.error),
            ],
          ],
        ),
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
}
