import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/l10n/app_localizations.dart';
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
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.catAdded)));
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
    ).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.catUpdated)));
  }

  Future<void> _deleteCat(Cat cat, int totalCount) async {
    if (totalCount <= 1) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.catMinimumOne)));
      return;
    }

    final healthDao = ref.read(healthDaoProvider);
    final hasRecords = await healthDao.hasAnyRecordsForCat(cat.id);
    if (hasRecords) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      await showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(l10n.catCannotDeleteTitle),
          content: Text(l10n.catCannotDeleteContent),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.catGotIt),
            ),
          ],
        ),
      );
      return;
    }

    if (!mounted) return;
    final l10nDelete = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10nDelete.catDeleteTitle),
        content: Text(l10nDelete.catDeleteConfirm(cat.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10nDelete.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10nDelete.commonDelete),
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
    ).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.catDeleted)));
  }

  Future<void> _selectCat(Cat cat) async {
    await ref.read(currentCatProvider.notifier).select(cat);
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.catSwitched(cat.name))));
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
        title: Text(AppLocalizations.of(context)!.catProfileTitle),
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
            AppLocalizations.of(context)!.catLoadFailed(err.toString()),
            style: const TextStyle(color: AppColors.textSecondary),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add),
        label: Text(AppLocalizations.of(context)!.catAddButton),
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
    final l10n = AppLocalizations.of(context)!;
    final ageText = _formatAge(cat.birthDate, l10n);
    final breedText = (cat.breed ?? '').trim().isEmpty ? l10n.catNoBreed : cat.breed!;
    final sexText = _sexLabel(cat.sex, l10n);
    final neuteredText = cat.isNeutered ? l10n.catNeutered : l10n.catNotNeutered;
    final weightGoalText = _formatWeightGoal(cat, l10n);
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
                      child: Text(
                        l10n.catCurrentBadge,
                        style: const TextStyle(
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
                l10n.catDailyTargets(
                  cat.targetWaterMl.toStringAsFixed(0),
                  cat.targetMealsPerDay,
                ),
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingS),
              trendAsync.when(
                data: (trend) => _CatHealthTrendPanel(trend: trend),
                loading: () => SizedBox(
                  height: 20,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      l10n.catLoadingTrend,
                      style: const TextStyle(
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
                    label: Text(l10n.commonEdit),
                  ),
                  const SizedBox(width: 4),
                  TextButton.icon(
                    onPressed: onDelete,
                    icon: const Icon(
                      Icons.delete_outline,
                      size: 18,
                      color: AppColors.error,
                    ),
                    label: Text(
                      l10n.commonDelete,
                      style: const TextStyle(color: AppColors.error),
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

  static String _formatAge(DateTime? birthDate, AppLocalizations l10n) {
    if (birthDate == null) return l10n.catUnknownAge;
    final now = DateTime.now();
    int months =
        (now.year - birthDate.year) * 12 + (now.month - birthDate.month);
    if (now.day < birthDate.day) {
      months -= 1;
    }
    if (months < 0) return l10n.catUnknownAge;
    if (months < 12) return l10n.catAgeMonths(months);
    final years = months ~/ 12;
    final restMonths = months % 12;
    if (restMonths == 0) return l10n.catAgeYears(years);
    return l10n.catAgeYearsMonths(years, restMonths);
  }

  static String _sexLabel(String sex, AppLocalizations l10n) {
    switch (sex) {
      case 'male':
        return l10n.catSexMale;
      case 'female':
        return l10n.catSexFemale;
      default:
        return l10n.catSexUnknown;
    }
  }

  static String? _formatWeightGoal(Cat cat, AppLocalizations l10n) {
    final min = cat.weightGoalMinKg;
    final max = cat.weightGoalMaxKg;
    if (min == null && max == null) return null;
    if (min != null && max != null) {
      return l10n.catWeightGoalRange(min.toStringAsFixed(1), max.toStringAsFixed(1));
    }
    if (min != null) {
      return l10n.catWeightGoalMin(min.toStringAsFixed(1));
    }
    return l10n.catWeightGoalMax(max!.toStringAsFixed(1));
  }
}

class _CatHealthTrendPanel extends StatelessWidget {
  final _CatHealthTrend trend;

  const _CatHealthTrendPanel({required this.trend});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final weight = trend.weightChangeKg;
    final weightText = weight == null
        ? l10n.catTrendWeightNoData
        : l10n.catTrendWeightChange('${weight >= 0 ? '+' : '-'}${weight.abs().toStringAsFixed(2)}');

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
              l10n.catTrend7DaysWater(trend.avgWaterPerDayMl.toStringAsFixed(0)),
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              l10n.catTrendMeals(trend.mealsCount),
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
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.pets, size: 64, color: AppColors.primary),
          const SizedBox(height: 16),
          Text(l10n.catProfileEmpty, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 8),
          Text(
            l10n.catProfileAddFirst,
            style: const TextStyle(color: AppColors.textSecondary),
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
    final l10n = AppLocalizations.of(context)!;

    final water = double.tryParse(_waterController.text.trim());
    final meals = int.tryParse(_mealsController.text.trim());
    final weightMin = _parseOptionalDouble(_weightMinController.text);
    final weightMax = _parseOptionalDouble(_weightMaxController.text);
    if (water == null || water <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.catFormInvalidWater)));
      return;
    }
    if (meals == null || meals <= 0 || meals > 20) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.catFormInvalidMeals)));
      return;
    }
    if (weightMin == -1 || weightMax == -1) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.catFormInvalidWeight)));
      return;
    }
    if (weightMin != null && weightMax != null && weightMin > weightMax) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.catFormWeightRangeError)));
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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(isEdit ? l10n.catFormEditTitle : l10n.catFormNewTitle),
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
                  Text(
                    l10n.catFormBasicInfo,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _fieldLabel(l10n.catFormName),
                  TextFormField(
                    controller: _nameController,
                    decoration: _formDecoration(hint: l10n.catFormNameHint),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return l10n.catFormNameRequired;
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  _fieldLabel(l10n.catFormBreed),
                  TextFormField(
                    controller: _breedController,
                    decoration: _formDecoration(hint: l10n.catFormBreedHint),
                  ),
                  const SizedBox(height: 12),
                  _fieldLabel(l10n.catFormSex),
                  DropdownButtonFormField<String>(
                    initialValue: _sex,
                    decoration: _formDecoration(hint: l10n.catFormSex),
                    style: const TextStyle(
                      fontSize: 17,
                      color: AppColors.onBackground,
                    ),
                    items: [
                      DropdownMenuItem(value: 'unknown', child: Text(l10n.catFormSexUnknown)),
                      DropdownMenuItem(value: 'male', child: Text(l10n.catFormSexMale)),
                      DropdownMenuItem(value: 'female', child: Text(l10n.catFormSexFemale)),
                    ],
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => _sex = value);
                    },
                  ),
                  const SizedBox(height: 12),
                  _fieldLabel(l10n.catFormBirthDate),
                  InkWell(
                    onTap: _pickBirthDate,
                    borderRadius: BorderRadius.circular(16),
                    child: InputDecorator(
                      decoration: _formDecoration(hint: l10n.catFormBirthDate),
                      child: Text(
                        _birthDate == null
                            ? l10n.catFormBirthDateNotSet
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
                        Text(
                          l10n.catFormNeutered,
                          style: const TextStyle(
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
                  Text(
                    l10n.catFormHealthGoals,
                    style: const TextStyle(
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
                            _fieldLabel(l10n.catFormWeightMin),
                            TextFormField(
                              controller: _weightMinController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              decoration: _formDecoration(hint: l10n.catFormWeightMinHint),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppDimensions.spacingS),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _fieldLabel(l10n.catFormWeightMax),
                            TextFormField(
                              controller: _weightMaxController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              decoration: _formDecoration(hint: l10n.catFormWeightMaxHint),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _fieldLabel(l10n.catFormWaterTarget),
                  TextFormField(
                    controller: _waterController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: _formDecoration(hint: l10n.catFormWaterHint),
                  ),
                  const SizedBox(height: 12),
                  _fieldLabel(l10n.catFormMealsTarget),
                  TextFormField(
                    controller: _mealsController,
                    keyboardType: TextInputType.number,
                    decoration: _formDecoration(hint: l10n.catFormMealsHint),
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
                      child: Text(isEdit ? l10n.catFormSave : l10n.catFormCreate),
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
