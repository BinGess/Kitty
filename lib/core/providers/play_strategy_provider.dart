import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database/app_database.dart';
import 'current_cat_provider.dart';

enum PlayIntensityMode { auto, gentle, balanced, active }

extension PlayIntensityModeX on PlayIntensityMode {
  String get labelZh {
    return switch (this) {
      PlayIntensityMode.auto => '自动',
      PlayIntensityMode.gentle => '温和',
      PlayIntensityMode.balanced => '标准',
      PlayIntensityMode.active => '活跃',
    };
  }

  String get descriptionZh {
    return switch (this) {
      PlayIntensityMode.auto => '根据年龄、性格和目标体重自动调节',
      PlayIntensityMode.gentle => '低刺激、低频次，适合敏感或高龄猫咪',
      PlayIntensityMode.balanced => '日常推荐强度，兼顾互动和休息',
      PlayIntensityMode.active => '高频互动，适合精力充沛的猫咪',
    };
  }
}

final playStrategyServiceProvider = Provider<PlayStrategyService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return PlayStrategyService(prefs);
});

class PlayStrategyPlan {
  final PlayIntensityMode mode;
  final int captureGoal;
  final int rewardWaterMlPerCapture;
  final int reminderIntervalMinutes;
  final String reasoning;

  const PlayStrategyPlan({
    required this.mode,
    required this.captureGoal,
    required this.rewardWaterMlPerCapture,
    required this.reminderIntervalMinutes,
    required this.reasoning,
  });
}

class PlayStrategyService {
  static const String _modePrefix = 'cat_play_mode_v1';

  final SharedPreferences _prefs;

  PlayStrategyService(this._prefs);

  Future<PlayIntensityMode> getMode(int catId) async {
    final raw = _prefs.getString(_modeKey(catId));
    return _parseMode(raw);
  }

  Future<void> setMode(int catId, PlayIntensityMode mode) async {
    await _prefs.setString(_modeKey(catId), mode.name);
  }

  PlayStrategyPlan resolvePlan({
    required Cat cat,
    required PlayIntensityMode mode,
  }) {
    final resolvedMode = mode == PlayIntensityMode.auto ? _autoMode(cat) : mode;

    final baseGoal = _baseCaptureGoalByAge(cat.birthDate);
    final personalityDelta = _personalityGoalDelta(cat.personalityCode);
    final weightDelta = _weightGoalDelta(
      cat.weightGoalMinKg,
      cat.weightGoalMaxKg,
    );
    final modeDelta = switch (resolvedMode) {
      PlayIntensityMode.gentle => -1,
      PlayIntensityMode.balanced => 0,
      PlayIntensityMode.active => 1,
      PlayIntensityMode.auto => 0,
    };
    final captureGoal = (baseGoal + personalityDelta + weightDelta + modeDelta)
        .clamp(2, 8);

    final ratio = switch (resolvedMode) {
      PlayIntensityMode.gentle => 0.06,
      PlayIntensityMode.balanced => 0.08,
      PlayIntensityMode.active => 0.11,
      PlayIntensityMode.auto => 0.08,
    };
    final reminderIntervalMinutes = switch (resolvedMode) {
      PlayIntensityMode.gentle => 180,
      PlayIntensityMode.balanced => 120,
      PlayIntensityMode.active => 90,
      PlayIntensityMode.auto => 120,
    };
    final targetWater = cat.targetWaterMl > 0 ? cat.targetWaterMl : 200.0;
    final rewardWaterMlPerCapture = math.max(
      10,
      math.min(45, (targetWater * ratio).round()),
    );

    final autoPrefix = mode == PlayIntensityMode.auto
        ? '自动档（按${resolvedMode.labelZh}强度）'
        : '${resolvedMode.labelZh}档';
    final reasoning =
        '$autoPrefix：推荐每日收尾目标 $captureGoal 次，每次补水建议 '
        '+${rewardWaterMlPerCapture}ml，提醒节奏约每 $reminderIntervalMinutes 分钟';

    return PlayStrategyPlan(
      mode: resolvedMode,
      captureGoal: captureGoal,
      rewardWaterMlPerCapture: rewardWaterMlPerCapture,
      reminderIntervalMinutes: reminderIntervalMinutes,
      reasoning: reasoning,
    );
  }

  PlayIntensityMode _autoMode(Cat cat) {
    final ageMonths = _ageInMonths(cat.birthDate);
    if (ageMonths != null) {
      if (ageMonths < 12) return PlayIntensityMode.active;
      if (ageMonths >= 120) return PlayIntensityMode.gentle;
    }

    final code = cat.personalityCode?.toUpperCase();
    if (code != null && code.length == 4) {
      final extrovert = code[0] == 'E';
      final perceiving = code[3] == 'P';
      if (extrovert || perceiving) return PlayIntensityMode.active;
      return PlayIntensityMode.balanced;
    }
    return PlayIntensityMode.balanced;
  }

  int _baseCaptureGoalByAge(DateTime? birthDate) {
    final ageMonths = _ageInMonths(birthDate);
    if (ageMonths == null) return 4;
    if (ageMonths < 12) return 6;
    if (ageMonths >= 96) return 3;
    return 4;
  }

  int _personalityGoalDelta(String? code) {
    final normalized = code?.toUpperCase();
    if (normalized == null || normalized.length != 4) return 0;
    int delta = 0;
    if (normalized[0] == 'E') delta += 1;
    if (normalized[0] == 'I') delta -= 1;
    if (normalized[3] == 'P') delta += 1;
    return delta.clamp(-1, 2);
  }

  int _weightGoalDelta(double? minKg, double? maxKg) {
    final target = _averageWeightGoal(minKg, maxKg);
    if (target == null) return 0;
    if (target >= 6.0) return 1;
    if (target <= 2.6) return -1;
    return 0;
  }

  double? _averageWeightGoal(double? minKg, double? maxKg) {
    if (minKg != null && maxKg != null) return (minKg + maxKg) / 2;
    return minKg ?? maxKg;
  }

  int? _ageInMonths(DateTime? birthDate) {
    if (birthDate == null) return null;
    final now = DateTime.now();
    int months =
        (now.year - birthDate.year) * 12 + (now.month - birthDate.month);
    if (now.day < birthDate.day) {
      months -= 1;
    }
    return months < 0 ? 0 : months;
  }

  String _modeKey(int catId) => '$_modePrefix:$catId';

  PlayIntensityMode _parseMode(String? raw) {
    for (final m in PlayIntensityMode.values) {
      if (m.name == raw) return m;
    }
    return PlayIntensityMode.auto;
  }
}
