import 'dart:convert';

import '../../../../core/database/app_database.dart';
import '../../games/data/models/game_item.dart';
import '../data/models/personality_type.dart';
import '../data/models/question.dart';
import '../data/repositories/result_repository.dart';

class CatPersonalityProfile {
  final TestResult result;
  final TestMode mode;
  final DateTime testedAt;

  const CatPersonalityProfile({
    required this.result,
    required this.mode,
    required this.testedAt,
  });

  static CatPersonalityProfile? fromCat(Cat cat, {String languageCode = 'zh'}) {
    final code = cat.personalityCode;
    if (code == null || code.length != 4) return null;

    final mode = _parseMode(cat.personalityTestMode);
    final max = mode == TestMode.advanced ? 6 : 3;
    final fallbackScores = _buildFallbackScores(code, max: max);

    final dimensionScores = _decodeScoreMap(
      cat.personalityDimensionScores,
      fallback: fallbackScores,
    );
    final maxScores = _decodeScoreMap(
      cat.personalityMaxScores,
      fallback: {for (final dim in Dimension.values) dim.name: max},
    );

    final result = TestResult(
      personality: ResultRepository.getType(code, languageCode: languageCode),
      dimensionScores: dimensionScores,
      maxScores: maxScores,
      hasDualPersonality: cat.personalityHasDual,
      languageCode: _normalizeLanguageCode(languageCode),
    );

    return CatPersonalityProfile(
      result: result,
      mode: mode,
      testedAt: cat.personalityTestedAt ?? cat.updatedAt,
    );
  }

  static String encodeScoreMap(Map<String, int> scores) {
    return jsonEncode(scores);
  }

  static String _normalizeLanguageCode(String languageCode) {
    return switch (languageCode) {
      'en' => 'en',
      'ja' => 'ja',
      _ => 'zh',
    };
  }

  static TestMode _parseMode(String? raw) {
    return raw == TestMode.advanced.name ? TestMode.advanced : TestMode.basic;
  }

  static Map<String, int> _decodeScoreMap(
    String? raw, {
    required Map<String, int> fallback,
  }) {
    if (raw == null || raw.trim().isEmpty) {
      return fallback;
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) {
        return fallback;
      }
      return {
        for (final dim in Dimension.values)
          dim.name: (decoded[dim.name] as num?)?.toInt() ?? fallback[dim.name]!,
      };
    } catch (_) {
      return fallback;
    }
  }

  static Map<String, int> _buildFallbackScores(
    String code, {
    required int max,
  }) {
    final chars = code.toUpperCase().split('');
    final scores = <String, int>{};

    for (int i = 0; i < Dimension.values.length; i++) {
      final dim = Dimension.values[i];
      final selected = i < chars.length ? chars[i] : dim.leftLabel;
      scores[dim.name] = selected == dim.leftLabel ? max : 0;
    }

    return scores;
  }
}

class PersonalityRecommendationEngine {
  static Set<String> recommendedSoundIds(String code) {
    final normalized = code.toUpperCase();
    if (normalized.length != 4) return {};

    final ids = <String>{};

    final isExtrovert = normalized[0] == 'E';
    final isIntuitive = normalized[1] == 'N';
    final isFeeling = normalized[2] == 'F';
    final isPerceiving = normalized[3] == 'P';

    if (isExtrovert) {
      ids.addAll([
        'can_opener',
        'food_shaking',
        'bird_sounds',
        'mouse_sounds',
        'ambient_bird_sounds',
        'ambient_mouse_sounds',
        'music_nature_ambience',
        'music_soft_interaction',
      ]);
    } else {
      ids.addAll([
        'purr',
        'white_noise',
        'water',
        'whimper',
        'ambient_white_noise',
        'ambient_water',
        'ambient_feather',
        'music_cat_specific',
        'music_noise_blend',
        'music_ambient_drone',
        'music_slow_classical',
      ]);
    }

    if (isIntuitive) {
      ids.addAll(['squeaky_toys', 'comeback', 'bell']);
    } else {
      ids.addAll(['can_open', 'squeaky_toy', 'water']);
    }

    if (isFeeling) {
      ids.addAll(['purr', 'meow', 'comeback']);
    } else {
      ids.addAll(['hiss', 'chattering', 'mouse_sounds']);
    }

    if (isPerceiving) {
      ids.addAll(['bird_sounds', 'plastic_bag']);
    } else {
      ids.addAll(['food_shaking', 'can_open']);
    }

    return ids;
  }

  static List<GameMode> sortedGameModes(
    Iterable<GameMode> allModes,
    String? code,
  ) {
    final modes = allModes.toList();
    final recommended = recommendedGameIds(code);

    if (recommended.isEmpty) return modes;

    final recommendedModes = <GameMode>[];
    final others = <GameMode>[];

    for (final mode in modes) {
      if (recommended.contains(mode.id)) {
        recommendedModes.add(mode);
      } else {
        others.add(mode);
      }
    }

    return [...recommendedModes, ...others];
  }

  static Set<String> recommendedGameIds(String? code) {
    if (code == null || code.length != 4) return {};
    final normalized = code.toUpperCase();
    final isPerceiving = normalized[3] == 'P';
    final isExtrovert = normalized[0] == 'E';

    if (isPerceiving) {
      return {'rainbow', 'feather_wand', 'hole_ambush'};
    }

    if (isExtrovert) {
      return {'catch_mouse', 'hole_ambush', 'feather_wand'};
    }

    return {'shadow_peek', 'catch_mouse'};
  }
}
