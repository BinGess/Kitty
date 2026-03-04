import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database/app_database.dart';
import 'current_cat_provider.dart';
import 'play_strategy_provider.dart';

final playRewardServiceProvider = Provider<PlayRewardService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  final strategyService = ref.watch(playStrategyServiceProvider);
  return PlayRewardService(prefs, strategyService);
});

class PlayRewardService {
  static const String _storagePrefix = 'cat_play_reward_v1';

  final SharedPreferences _prefs;
  final PlayStrategyService _strategyService;

  PlayRewardService(this._prefs, this._strategyService);

  Future<PlayRewardStats> getTodayStats(Cat cat) async {
    final mode = await _strategyService.getMode(cat.id);
    final plan = _strategyService.resolvePlan(cat: cat, mode: mode);
    final raw = _readRawStats(cat.id, _todayKey());
    return _buildStats(plan, raw, lastRewardMl: 0, lastLoggedMl: 0);
  }

  Future<PlayRewardStats> recordSession({
    required Cat cat,
    required String gameId,
    required bool captured,
    required Duration sessionDuration,
  }) async {
    final mode = await _strategyService.getMode(cat.id);
    final plan = _strategyService.resolvePlan(cat: cat, mode: mode);
    final dateKey = _todayKey();
    final raw = _readRawStats(cat.id, dateKey);

    final sessions = (raw['sessions'] as int? ?? 0) + 1;
    final captures = (raw['captures'] as int? ?? 0) + (captured ? 1 : 0);
    final rewardStep = plan.rewardWaterMlPerCapture;
    final rewardWaterMl =
        (raw['reward_water_ml'] as int? ?? 0) + (captured ? rewardStep : 0);
    final loggedWaterMl = raw['logged_water_ml'] as int? ?? 0;

    final next = <String, dynamic>{
      'sessions': sessions,
      'captures': captures,
      'reward_water_ml': rewardWaterMl,
      'logged_water_ml': loggedWaterMl,
      'last_game_id': gameId,
      'last_session_seconds': sessionDuration.inSeconds,
      'updated_at': DateTime.now().toIso8601String(),
    };

    await _prefs.setString(_prefsKey(cat.id, dateKey), jsonEncode(next));
    return _buildStats(
      plan,
      next,
      lastRewardMl: captured ? rewardStep : 0,
      lastLoggedMl: 0,
    );
  }

  Future<PlayRewardStats> acknowledgeHydration({
    required Cat cat,
    int? amountMl,
  }) async {
    final mode = await _strategyService.getMode(cat.id);
    final plan = _strategyService.resolvePlan(cat: cat, mode: mode);
    final dateKey = _todayKey();
    final raw = _readRawStats(cat.id, dateKey);

    final rewardTotal = raw['reward_water_ml'] as int? ?? 0;
    final logged = raw['logged_water_ml'] as int? ?? 0;
    final pending = (rewardTotal - logged).clamp(0, rewardTotal);
    if (pending <= 0) {
      return _buildStats(plan, raw, lastRewardMl: 0, lastLoggedMl: 0);
    }

    final toLog = amountMl == null
        ? pending
        : amountMl.clamp(1, pending).toInt();
    final next = <String, dynamic>{
      ...raw,
      'logged_water_ml': logged + toLog,
      'updated_at': DateTime.now().toIso8601String(),
    };
    await _prefs.setString(_prefsKey(cat.id, dateKey), jsonEncode(next));
    return _buildStats(plan, next, lastRewardMl: 0, lastLoggedMl: toLog);
  }

  Future<List<PlayRewardDailyStats>> getRecentDailyStats(
    Cat cat, {
    int days = 7,
  }) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final result = <PlayRewardDailyStats>[];

    for (int offset = days - 1; offset >= 0; offset--) {
      final date = today.subtract(Duration(days: offset));
      final raw = _readRawStats(cat.id, _dateKey(date));
      final rewardTotal = raw['reward_water_ml'] as int? ?? 0;
      final logged = raw['logged_water_ml'] as int? ?? 0;
      final pending = (rewardTotal - logged).clamp(0, rewardTotal);
      result.add(
        PlayRewardDailyStats(
          date: date,
          rewardWaterMl: rewardTotal,
          loggedWaterMl: logged,
          pendingWaterMl: pending,
          captures: raw['captures'] as int? ?? 0,
          sessions: raw['sessions'] as int? ?? 0,
        ),
      );
    }

    return result;
  }

  PlayRewardStats _buildStats(
    PlayStrategyPlan plan,
    Map<String, dynamic> raw, {
    required int lastRewardMl,
    required int lastLoggedMl,
  }) {
    final rewardTotal = raw['reward_water_ml'] as int? ?? 0;
    final logged = raw['logged_water_ml'] as int? ?? 0;
    final pending = (rewardTotal - logged).clamp(0, rewardTotal);

    return PlayRewardStats(
      sessionsToday: raw['sessions'] as int? ?? 0,
      capturesToday: raw['captures'] as int? ?? 0,
      captureGoal: plan.captureGoal,
      rewardWaterMlToday: rewardTotal,
      rewardWaterLoggedMlToday: logged,
      rewardWaterPendingMl: pending,
      nextRewardWaterMl: plan.rewardWaterMlPerCapture,
      lastRewardMl: lastRewardMl,
      lastLoggedMl: lastLoggedMl,
      lastGameId: raw['last_game_id'] as String?,
      modeLabel: plan.mode.labelZh,
      modeDescription: plan.reasoning,
    );
  }

  Map<String, dynamic> _readRawStats(int catId, String dateKey) {
    final text = _prefs.getString(_prefsKey(catId, dateKey));
    if (text == null || text.isEmpty) return {};
    try {
      final json = jsonDecode(text);
      if (json is Map<String, dynamic>) return json;
      if (json is Map) {
        return Map<String, dynamic>.from(json);
      }
      return {};
    } catch (_) {
      return {};
    }
  }

  String _todayKey() {
    return _dateKey(DateTime.now());
  }

  String _dateKey(DateTime date) {
    final mm = date.month.toString().padLeft(2, '0');
    final dd = date.day.toString().padLeft(2, '0');
    return '${date.year}$mm$dd';
  }

  String _prefsKey(int catId, String dateKey) {
    return '$_storagePrefix:${catId}_$dateKey';
  }
}

class PlayRewardStats {
  final int sessionsToday;
  final int capturesToday;
  final int captureGoal;
  final int rewardWaterMlToday;
  final int rewardWaterLoggedMlToday;
  final int rewardWaterPendingMl;
  final int nextRewardWaterMl;
  final int lastRewardMl;
  final int lastLoggedMl;
  final String? lastGameId;
  final String modeLabel;
  final String modeDescription;

  const PlayRewardStats({
    required this.sessionsToday,
    required this.capturesToday,
    required this.captureGoal,
    required this.rewardWaterMlToday,
    required this.rewardWaterLoggedMlToday,
    required this.rewardWaterPendingMl,
    required this.nextRewardWaterMl,
    required this.lastRewardMl,
    required this.lastLoggedMl,
    required this.lastGameId,
    required this.modeLabel,
    required this.modeDescription,
  });

  bool get captureGoalReached => capturesToday >= captureGoal;

  double get captureProgress {
    if (captureGoal <= 0) return 1;
    return (capturesToday / captureGoal).clamp(0, 1).toDouble();
  }
}

class PlayRewardDailyStats {
  final DateTime date;
  final int rewardWaterMl;
  final int loggedWaterMl;
  final int pendingWaterMl;
  final int captures;
  final int sessions;

  const PlayRewardDailyStats({
    required this.date,
    required this.rewardWaterMl,
    required this.loggedWaterMl,
    required this.pendingWaterMl,
    required this.captures,
    required this.sessions,
  });
}
