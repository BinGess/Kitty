class PersonalityType {
  final String code;       // e.g. "ENFP"
  final String title;      // e.g. "快乐小天使"
  final List<String> tags; // e.g. ["#社牛", "#话痨"]
  final String description;
  final String advice;
  final String quote;

  const PersonalityType({
    required this.code,
    required this.title,
    required this.tags,
    required this.description,
    required this.advice,
    required this.quote,
  });
}

class TestResult {
  final PersonalityType personality;
  final Map<String, int> dimensionScores; // e.g. {"EI": 3, "NS": 1}
  final Map<String, int> maxScores;       // e.g. {"EI": 3, "NS": 3} for basic
  final bool hasDualPersonality;          // advanced mode: score=3 on a dimension

  const TestResult({
    required this.personality,
    required this.dimensionScores,
    required this.maxScores,
    this.hasDualPersonality = false,
  });

  /// Get percentage for each dimension (for radar chart)
  double getLeftPercent(String dim) {
    final score = dimensionScores[dim] ?? 0;
    final max = maxScores[dim] ?? 3;
    return score / max;
  }
}
