import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/providers/current_cat_provider.dart';
import '../../../../core/providers/database_provider.dart';

final catListProvider = StreamProvider.autoDispose<List<Cat>>((ref) {
  return ref.watch(catDaoProvider).watchAllCats();
});

final catHealthTrendProvider = FutureProvider.autoDispose
    .family<_CatHealthTrend, int>((ref, catId) async {
      final dao = ref.watch(healthDaoProvider);
      final since = DateTime.now().subtract(const Duration(days: 7));
      final waterTotal = await dao.getWaterTotalSince(catId, since);
      final mealCount = await dao.getDietCountSince(catId, since);
      final weights = await dao.getWeightTrendData(catId, 7);
      final weightChange = weights.length >= 2
          ? weights.last.weightKg - weights.first.weightKg
          : null;

      return _CatHealthTrend(
        avgWaterPerDayMl: waterTotal / 7,
        mealsCount: mealCount,
        weightChangeKg: weightChange,
      );
    });

class CatListScreen extends ConsumerStatefulWidget {
  const CatListScreen({super.key});

  @override
  ConsumerState<CatListScreen> createState() => _CatListScreenState();
}

class _CatListScreenState extends ConsumerState<CatListScreen> {
  Future<void> _openForm({Cat? cat}) async {
    final result = await Navigator.of(context).push<_CatFormResult>(
      MaterialPageRoute(builder: (_) => _CatFormScreen(initial: cat)),
    );

    if (!mounted || result == null) return;

    final catDao = ref.read(catDaoProvider);
    final currentNotifier = ref.read(currentCatProvider.notifier);

    if (cat == null) {
      final id = await catDao.insertCat(
        CatsCompanion.insert(
          name: result.name,
          breed: Value(result.breed),
          birthDate: Value(result.birthDate),
          sex: Value(result.sex),
          isNeutered: Value(result.isNeutered),
          weightGoalMinKg: Value(result.weightGoalMinKg),
          weightGoalMaxKg: Value(result.weightGoalMaxKg),
          targetWaterMl: Value(result.targetWaterMl),
          targetMealsPerDay: Value(result.targetMealsPerDay),
        ),
      );
      final created = await catDao.getCatById(id);
      if (created != null) {
        await currentNotifier.select(created);
      }
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('已添加猫咪档案')));
      return;
    }

    await catDao.updateCat(
      cat.copyWith(
        name: result.name,
        breed: Value(result.breed),
        birthDate: Value(result.birthDate),
        sex: result.sex,
        isNeutered: result.isNeutered,
        weightGoalMinKg: Value(result.weightGoalMinKg),
        weightGoalMaxKg: Value(result.weightGoalMaxKg),
        targetWaterMl: result.targetWaterMl,
        targetMealsPerDay: result.targetMealsPerDay,
        updatedAt: DateTime.now(),
      ),
    );

    await currentNotifier.refresh();
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('已更新猫咪档案')));
  }

  Future<void> _deleteCat(Cat cat, int totalCount) async {
    if (totalCount <= 1) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('至少保留一只猫咪档案')));
      return;
    }

    final healthDao = ref.read(healthDaoProvider);
    final hasRecords = await healthDao.hasAnyRecordsForCat(cat.id);
    if (hasRecords) {
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('无法删除'),
          content: const Text('该猫咪已有健康记录，请先处理历史记录后再删除。'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('知道了'),
            ),
          ],
        ),
      );
      return;
    }

    if (!mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('删除猫咪档案'),
        content: Text('确认删除「${cat.name}」吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('删除'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    await ref.read(catDaoProvider).deleteCat(cat.id);
    await ref.read(currentCatProvider.notifier).ensureValidSelection();
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('已删除猫咪档案')));
  }

  Future<void> _selectCat(Cat cat) async {
    await ref.read(currentCatProvider.notifier).select(cat);
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('已切换到 ${cat.name}')));
  }

  @override
  Widget build(BuildContext context) {
    final catsAsync = ref.watch(catListProvider);
    final currentCat = ref.watch(currentCatProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 62,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/more');
            }
          },
        ),
        title: const Text('猫咪档案'),
        centerTitle: true,
      ),
      body: catsAsync.when(
        data: (cats) {
          if (cats.isEmpty) {
            return const _CatEmptyState();
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(
              AppDimensions.spacingM,
              AppDimensions.spacingM,
              AppDimensions.spacingM,
              96,
            ),
            itemCount: cats.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: AppDimensions.spacingS),
            itemBuilder: (_, index) {
              final cat = cats[index];
              final isCurrent = currentCat?.id == cat.id;
              return _CatCard(
                cat: cat,
                isCurrent: isCurrent,
                onTap: () => _selectCat(cat),
                onEdit: () => _openForm(cat: cat),
                onDelete: () => _deleteCat(cat, cats.length),
              );
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (err, _) => Center(
          child: Text(
            '加载失败：$err',
            style: const TextStyle(color: AppColors.textSecondary),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add),
        label: const Text('添加猫咪'),
      ),
    );
  }
}

class _CatCard extends ConsumerWidget {
  final Cat cat;
  final bool isCurrent;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CatCard({
    required this.cat,
    required this.isCurrent,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ageText = _formatAge(cat.birthDate);
    final breedText = (cat.breed ?? '').trim().isEmpty ? '未设置品种' : cat.breed!;
    final sexText = _sexLabel(cat.sex);
    final neuteredText = cat.isNeutered ? '已绝育' : '未绝育';
    final weightGoalText = _formatWeightGoal(cat);
    final trendAsync = ref.watch(catHealthTrendProvider(cat.id));

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        side: BorderSide(
          color: isCurrent ? AppColors.primary : AppColors.divider,
          width: isCurrent ? 1.5 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spacingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      cat.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onBackground,
                      ),
                    ),
                  ),
                  if (isCurrent)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text(
                        '当前',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppDimensions.spacingXS),
              Text(
                '$breedText · $ageText',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '$sexText · $neuteredText',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              if (weightGoalText != null) ...[
                const SizedBox(height: 2),
                Text(
                  weightGoalText,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
              const SizedBox(height: AppDimensions.spacingS),
              Text(
                '目标饮水 ${cat.targetWaterMl.toStringAsFixed(0)} ml / 日 · '
                '目标喂食 ${cat.targetMealsPerDay} 次 / 日',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingS),
              trendAsync.when(
                data: (trend) => _CatHealthTrendPanel(trend: trend),
                loading: () => const SizedBox(
                  height: 20,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '加载健康趋势中...',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
                error: (_, stackTrace) => const SizedBox.shrink(),
              ),
              const SizedBox(height: AppDimensions.spacingS),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: const Text('编辑'),
                  ),
                  const SizedBox(width: 4),
                  TextButton.icon(
                    onPressed: onDelete,
                    icon: const Icon(
                      Icons.delete_outline,
                      size: 18,
                      color: AppColors.error,
                    ),
                    label: const Text(
                      '删除',
                      style: TextStyle(color: AppColors.error),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _formatAge(DateTime? birthDate) {
    if (birthDate == null) return '未知年龄';
    final now = DateTime.now();
    int months =
        (now.year - birthDate.year) * 12 + (now.month - birthDate.month);
    if (now.day < birthDate.day) {
      months -= 1;
    }
    if (months < 0) return '未知年龄';
    if (months < 12) return '$months 个月';
    final years = months ~/ 12;
    final restMonths = months % 12;
    if (restMonths == 0) return '$years 岁';
    return '$years 岁 $restMonths 个月';
  }

  static String _sexLabel(String sex) {
    switch (sex) {
      case 'male':
        return '公猫';
      case 'female':
        return '母猫';
      default:
        return '性别未知';
    }
  }

  static String? _formatWeightGoal(Cat cat) {
    final min = cat.weightGoalMinKg;
    final max = cat.weightGoalMaxKg;
    if (min == null && max == null) return null;
    if (min != null && max != null) {
      return '体重目标 ${min.toStringAsFixed(1)}-${max.toStringAsFixed(1)} kg';
    }
    if (min != null) {
      return '体重目标 ≥ ${min.toStringAsFixed(1)} kg';
    }
    return '体重目标 ≤ ${max!.toStringAsFixed(1)} kg';
  }
}

class _CatHealthTrendPanel extends StatelessWidget {
  final _CatHealthTrend trend;

  const _CatHealthTrendPanel({required this.trend});

  @override
  Widget build(BuildContext context) {
    final weight = trend.weightChangeKg;
    final weightText = weight == null
        ? '体重 无数据'
        : '体重 ${weight >= 0 ? '+' : '-'}${weight.abs().toStringAsFixed(2)}kg';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '近7天日均饮水 ${trend.avgWaterPerDayMl.toStringAsFixed(0)}ml',
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              '喂食 ${trend.mealsCount} 次',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              weightText,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 11,
                color: weight == null
                    ? AppColors.textSecondary
                    : (weight >= 0 ? AppColors.error : AppColors.success),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CatHealthTrend {
  final double avgWaterPerDayMl;
  final int mealsCount;
  final double? weightChangeKg;

  const _CatHealthTrend({
    required this.avgWaterPerDayMl,
    required this.mealsCount,
    required this.weightChangeKg,
  });
}

class _CatEmptyState extends StatelessWidget {
  const _CatEmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.pets, size: 64, color: AppColors.primary),
          SizedBox(height: 16),
          Text('还没有猫咪', style: TextStyle(fontSize: 20)),
          SizedBox(height: 8),
          Text(
            '点击右下角添加你的第一只猫咪',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _CatFormScreen extends StatefulWidget {
  final Cat? initial;

  const _CatFormScreen({this.initial});

  @override
  State<_CatFormScreen> createState() => _CatFormScreenState();
}

class _CatFormScreenState extends State<_CatFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _breedController;
  late final TextEditingController _waterController;
  late final TextEditingController _mealsController;
  late final TextEditingController _weightMinController;
  late final TextEditingController _weightMaxController;
  DateTime? _birthDate;
  String _sex = 'unknown';
  bool _isNeutered = false;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    _nameController = TextEditingController(text: initial?.name ?? '');
    _breedController = TextEditingController(text: initial?.breed ?? '');
    _waterController = TextEditingController(
      text: (initial?.targetWaterMl ?? 200).toStringAsFixed(0),
    );
    _mealsController = TextEditingController(
      text: (initial?.targetMealsPerDay ?? 3).toString(),
    );
    _weightMinController = TextEditingController(
      text: initial?.weightGoalMinKg?.toStringAsFixed(1) ?? '',
    );
    _weightMaxController = TextEditingController(
      text: initial?.weightGoalMaxKg?.toStringAsFixed(1) ?? '',
    );
    _birthDate = initial?.birthDate;
    _sex = initial?.sex ?? 'unknown';
    _isNeutered = initial?.isNeutered ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _waterController.dispose();
    _mealsController.dispose();
    _weightMinController.dispose();
    _weightMaxController.dispose();
    super.dispose();
  }

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(now.year - 1, now.month, now.day),
      firstDate: DateTime(2000, 1, 1),
      lastDate: now,
    );
    if (picked != null) {
      setState(() => _birthDate = picked);
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final water = double.tryParse(_waterController.text.trim());
    final meals = int.tryParse(_mealsController.text.trim());
    final weightMin = _parseOptionalDouble(_weightMinController.text);
    final weightMax = _parseOptionalDouble(_weightMaxController.text);
    if (water == null || water <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请填写正确的饮水目标')));
      return;
    }
    if (meals == null || meals <= 0 || meals > 20) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请填写正确的喂食次数（1-20）')));
      return;
    }
    if (weightMin == -1 || weightMax == -1) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请填写正确的体重目标（kg）')));
      return;
    }
    if (weightMin != null && weightMax != null && weightMin > weightMax) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('体重区间下限不能大于上限')));
      return;
    }

    Navigator.pop(
      context,
      _CatFormResult(
        name: _nameController.text.trim(),
        breed: _breedController.text.trim().isEmpty
            ? null
            : _breedController.text.trim(),
        birthDate: _birthDate,
        sex: _sex,
        isNeutered: _isNeutered,
        weightGoalMinKg: weightMin,
        weightGoalMaxKg: weightMax,
        targetWaterMl: water,
        targetMealsPerDay: meals,
      ),
    );
  }

  double? _parseOptionalDouble(String raw) {
    final text = raw.trim();
    if (text.isEmpty) return null;
    final parsed = double.tryParse(text);
    if (parsed == null || parsed <= 0) return -1;
    return parsed;
  }

  InputDecoration _formDecoration({required String hint}) {
    OutlineInputBorder border(Color color) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: color),
    );

    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 15, color: AppColors.textSecondary),
      filled: true,
      fillColor: AppColors.surfaceVariant,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: border(Colors.transparent),
      enabledBorder: border(Colors.transparent),
      focusedBorder: border(AppColors.primary.withValues(alpha: 0.7)),
      errorBorder: border(AppColors.error),
      focusedErrorBorder: border(AppColors.error),
    );
  }

  Widget _fieldLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 2, bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initial != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(isEdit ? '编辑猫咪档案' : '新增猫咪档案'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppDimensions.spacingL,
            AppDimensions.spacingM,
            AppDimensions.spacingL,
            MediaQuery.of(context).viewInsets.bottom + AppDimensions.spacingM,
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '基础信息',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _fieldLabel('猫咪名称 *'),
                  TextFormField(
                    controller: _nameController,
                    decoration: _formDecoration(hint: '请输入猫咪名称'),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return '请输入猫咪名称';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  _fieldLabel('品种'),
                  TextFormField(
                    controller: _breedController,
                    decoration: _formDecoration(hint: '例如：英短、美短'),
                  ),
                  const SizedBox(height: 12),
                  _fieldLabel('性别'),
                  DropdownButtonFormField<String>(
                    initialValue: _sex,
                    decoration: _formDecoration(hint: '请选择性别'),
                    style: const TextStyle(
                      fontSize: 17,
                      color: AppColors.onBackground,
                    ),
                    items: const [
                      DropdownMenuItem(value: 'unknown', child: Text('未知')),
                      DropdownMenuItem(value: 'male', child: Text('公猫')),
                      DropdownMenuItem(value: 'female', child: Text('母猫')),
                    ],
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => _sex = value);
                    },
                  ),
                  const SizedBox(height: 12),
                  _fieldLabel('出生日期'),
                  InkWell(
                    onTap: _pickBirthDate,
                    borderRadius: BorderRadius.circular(16),
                    child: InputDecorator(
                      decoration: _formDecoration(hint: '请选择出生日期'),
                      child: Text(
                        _birthDate == null
                            ? '未设置'
                            : '${_birthDate!.year}-${_birthDate!.month.toString().padLeft(2, '0')}-${_birthDate!.day.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          fontSize: 17,
                          color: _birthDate == null
                              ? AppColors.textSecondary
                              : AppColors.onBackground,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Text(
                          '已绝育',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.onSurface,
                          ),
                        ),
                        const Spacer(),
                        Switch.adaptive(
                          value: _isNeutered,
                          onChanged: (value) =>
                              setState(() => _isNeutered = value),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingM),
                  const Text(
                    '健康目标',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _fieldLabel('体重目标下限 (kg)'),
                            TextFormField(
                              controller: _weightMinController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              decoration: _formDecoration(hint: '例如：3.5'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppDimensions.spacingS),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _fieldLabel('体重目标上限 (kg)'),
                            TextFormField(
                              controller: _weightMaxController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              decoration: _formDecoration(hint: '例如：5.0'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _fieldLabel('每日饮水目标 (ml)'),
                  TextFormField(
                    controller: _waterController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: _formDecoration(hint: '例如：200'),
                  ),
                  const SizedBox(height: 12),
                  _fieldLabel('每日喂食目标 (次)'),
                  TextFormField(
                    controller: _mealsController,
                    keyboardType: TextInputType.number,
                    decoration: _formDecoration(hint: '例如：3'),
                  ),
                  const SizedBox(height: AppDimensions.spacingL),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _submit,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                      child: Text(isEdit ? '保存修改' : '创建档案'),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CatFormResult {
  final String name;
  final String? breed;
  final DateTime? birthDate;
  final String sex;
  final bool isNeutered;
  final double? weightGoalMinKg;
  final double? weightGoalMaxKg;
  final double targetWaterMl;
  final int targetMealsPerDay;

  const _CatFormResult({
    required this.name,
    required this.breed,
    required this.birthDate,
    required this.sex,
    required this.isNeutered,
    required this.weightGoalMinKg,
    required this.weightGoalMaxKg,
    required this.targetWaterMl,
    required this.targetMealsPerDay,
  });
}
