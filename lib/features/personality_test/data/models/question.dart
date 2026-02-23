enum Dimension {
  EI('E', 'I', '外向', '内向'),
  NS('N', 'S', '直觉', '实感'),
  FT('F', 'T', '情感', '理性'),
  PJ('P', 'J', '随性', '规律');

  final String leftLabel;
  final String rightLabel;
  final String leftName;
  final String rightName;

  const Dimension(this.leftLabel, this.rightLabel, this.leftName, this.rightName);
}

class QuestionOption {
  final String text;
  final int score; // 1 = left attribute, 0 = right attribute

  const QuestionOption({required this.text, required this.score});
}

class Question {
  final int number;
  final Dimension dimension;
  final String text;
  final QuestionOption optionA;
  final QuestionOption optionB;

  const Question({
    required this.number,
    required this.dimension,
    required this.text,
    required this.optionA,
    required this.optionB,
  });
}

enum TestMode {
  basic(12, '基础版', '12道题快速测试'),
  advanced(24, '进阶版', '24道题深度分析');

  final int questionCount;
  final String label;
  final String description;

  const TestMode(this.questionCount, this.label, this.description);
}
