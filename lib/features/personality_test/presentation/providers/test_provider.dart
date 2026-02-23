import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/question.dart';
import '../../data/models/personality_type.dart';
import '../../data/repositories/question_repository.dart';
import '../../domain/scoring_engine.dart';

enum TestPhase { intro, inProgress, analyzing, result }

class TestState {
  final TestPhase phase;
  final TestMode mode;
  final List<Question> questions;
  final int currentIndex;
  final Map<int, int> answers; // questionNumber → score
  final TestResult? result;

  const TestState({
    this.phase = TestPhase.intro,
    this.mode = TestMode.basic,
    this.questions = const [],
    this.currentIndex = 0,
    this.answers = const {},
    this.result,
  });

  TestState copyWith({
    TestPhase? phase,
    TestMode? mode,
    List<Question>? questions,
    int? currentIndex,
    Map<int, int>? answers,
    TestResult? result,
  }) {
    return TestState(
      phase: phase ?? this.phase,
      mode: mode ?? this.mode,
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      answers: answers ?? this.answers,
      result: result ?? this.result,
    );
  }

  Question? get currentQuestion =>
      currentIndex < questions.length ? questions[currentIndex] : null;

  double get progress =>
      questions.isEmpty ? 0 : (currentIndex + 1) / questions.length;

  bool get isLastQuestion => currentIndex >= questions.length - 1;
}

final testProvider =
    NotifierProvider<TestNotifier, TestState>(TestNotifier.new);

class TestNotifier extends Notifier<TestState> {
  @override
  TestState build() => const TestState();

  void startTest(TestMode mode) {
    final questions = QuestionRepository.getQuestions(mode);
    state = TestState(
      phase: TestPhase.inProgress,
      mode: mode,
      questions: questions,
      currentIndex: 0,
      answers: {},
    );
  }

  void answerQuestion(int score) {
    final question = state.currentQuestion;
    if (question == null) return;

    final newAnswers = {...state.answers, question.number: score};

    if (state.isLastQuestion) {
      // All questions answered → go to analyzing phase
      state = state.copyWith(
        answers: newAnswers,
        phase: TestPhase.analyzing,
      );
    } else {
      // Move to next question
      state = state.copyWith(
        answers: newAnswers,
        currentIndex: state.currentIndex + 1,
      );
    }
  }

  void finishAnalyzing() {
    final result = ScoringEngine.calculate(
      answers: state.answers,
      mode: state.mode,
    );
    state = state.copyWith(
      phase: TestPhase.result,
      result: result,
    );
  }

  void reset() {
    state = const TestState();
  }

  void goBack() {
    if (state.currentIndex > 0) {
      state = state.copyWith(currentIndex: state.currentIndex - 1);
    }
  }
}
