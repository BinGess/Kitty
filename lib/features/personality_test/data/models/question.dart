enum Dimension {
  EI(
    'E',
    'I',
    zhLeftName: '外向',
    zhRightName: '内向',
    enLeftName: 'Extraverted',
    enRightName: 'Introverted',
  ),
  NS(
    'N',
    'S',
    zhLeftName: '直觉',
    zhRightName: '实感',
    enLeftName: 'Intuitive',
    enRightName: 'Sensing',
  ),
  FT(
    'F',
    'T',
    zhLeftName: '情感',
    zhRightName: '理性',
    enLeftName: 'Feeling',
    enRightName: 'Thinking',
  ),
  PJ(
    'P',
    'J',
    zhLeftName: '随性',
    zhRightName: '规律',
    enLeftName: 'Perceiving',
    enRightName: 'Judging',
  );

  final String leftLabel;
  final String rightLabel;
  final String zhLeftName;
  final String zhRightName;
  final String enLeftName;
  final String enRightName;

  const Dimension(
    this.leftLabel,
    this.rightLabel, {
    required this.zhLeftName,
    required this.zhRightName,
    required this.enLeftName,
    required this.enRightName,
  });

  String leftName(String languageCode) =>
      languageCode == 'en' ? enLeftName : zhLeftName;

  String rightName(String languageCode) =>
      languageCode == 'en' ? enRightName : zhRightName;
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
