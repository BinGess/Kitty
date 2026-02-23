import '../data/models/question.dart';
import '../data/models/personality_type.dart';
import '../data/repositories/result_repository.dart';

class ScoringEngine {
  /// Calculate test result from answers.
  /// [answers] is a map of question number to selected score (0 or 1).
  /// [mode] determines the threshold for each dimension.
  static TestResult calculate({
    required Map<int, int> answers,
    required TestMode mode,
  }) {
    // Sum scores per dimension
    final dimensionScores = <String, int>{};
    final dimensionMaxes = <String, int>{};

    for (final dim in Dimension.values) {
      dimensionScores[dim.name] = 0;
      dimensionMaxes[dim.name] = 0;
    }

    // Count questions per dimension
    final questions = mode == TestMode.basic
        ? _basicQuestionDimensions
        : _allQuestionDimensions;

    for (final entry in questions.entries) {
      final questionNumber = entry.key;
      final dimension = entry.value;
      final score = answers[questionNumber] ?? 0;

      dimensionScores[dimension.name] =
          (dimensionScores[dimension.name] ?? 0) + score;
      dimensionMaxes[dimension.name] =
          (dimensionMaxes[dimension.name] ?? 0) + 1;
    }

    // Determine MBTI code
    final code = StringBuffer();
    bool hasDual = false;

    for (final dim in Dimension.values) {
      final score = dimensionScores[dim.name]!;
      final max = dimensionMaxes[dim.name]!;
      final threshold = max / 2;

      if (score > threshold) {
        code.write(dim.leftLabel); // E, N, F, P
      } else if (score < threshold) {
        code.write(dim.rightLabel); // I, S, T, J
      } else {
        // Exactly on threshold — mark dual personality, default to left
        code.write(dim.leftLabel);
        hasDual = true;
      }
    }

    final personality = ResultRepository.getType(code.toString());

    return TestResult(
      personality: personality,
      dimensionScores: dimensionScores,
      maxScores: dimensionMaxes,
      hasDualPersonality: hasDual,
    );
  }

  // Question number → Dimension mapping for basic mode (1-12)
  static const _basicQuestionDimensions = {
    1: Dimension.EI,
    2: Dimension.EI,
    3: Dimension.EI,
    4: Dimension.NS,
    5: Dimension.NS,
    6: Dimension.NS,
    7: Dimension.FT,
    8: Dimension.FT,
    9: Dimension.FT,
    10: Dimension.PJ,
    11: Dimension.PJ,
    12: Dimension.PJ,
  };

  // Question number → Dimension mapping for advanced mode (1-24)
  static const _allQuestionDimensions = {
    ..._basicQuestionDimensions,
    13: Dimension.EI,
    14: Dimension.EI,
    15: Dimension.EI,
    16: Dimension.NS,
    17: Dimension.NS,
    18: Dimension.NS,
    19: Dimension.FT,
    20: Dimension.FT,
    21: Dimension.FT,
    22: Dimension.PJ,
    23: Dimension.PJ,
    24: Dimension.PJ,
  };
}
