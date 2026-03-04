enum Dimension {
  EI(
    'E',
    'I',
    zhLeftName: '外向',
    zhRightName: '内向',
    enLeftName: 'Extraverted',
    enRightName: 'Introverted',
    jaLeftName: '外向型',
    jaRightName: '内向型',
  ),
  NS(
    'N',
    'S',
    zhLeftName: '直觉',
    zhRightName: '实感',
    enLeftName: 'Intuitive',
    enRightName: 'Sensing',
    jaLeftName: '直観型',
    jaRightName: '感覚型',
  ),
  FT(
    'F',
    'T',
    zhLeftName: '情感',
    zhRightName: '理性',
    enLeftName: 'Feeling',
    enRightName: 'Thinking',
    jaLeftName: '感情型',
    jaRightName: '思考型',
  ),
  PJ(
    'P',
    'J',
    zhLeftName: '随性',
    zhRightName: '规律',
    enLeftName: 'Perceiving',
    enRightName: 'Judging',
    jaLeftName: '柔軟型',
    jaRightName: '計画型',
  );

  final String leftLabel;
  final String rightLabel;
  final String zhLeftName;
  final String zhRightName;
  final String enLeftName;
  final String enRightName;
  final String jaLeftName;
  final String jaRightName;

  const Dimension(
    this.leftLabel,
    this.rightLabel, {
    required this.zhLeftName,
    required this.zhRightName,
    required this.enLeftName,
    required this.enRightName,
    required this.jaLeftName,
    required this.jaRightName,
  });

  String leftName(String languageCode) {
    if (languageCode == 'en') return enLeftName;
    if (languageCode == 'ja') return jaLeftName;
    return zhLeftName;
  }

  String rightName(String languageCode) {
    if (languageCode == 'en') return enRightName;
    if (languageCode == 'ja') return jaRightName;
    return zhRightName;
  }
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
  basic(12),
  advanced(24);

  final int questionCount;

  const TestMode(this.questionCount);
}
