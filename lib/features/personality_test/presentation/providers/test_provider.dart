import '../../../../core/providers/current_cat_provider.dart';
import '../../../../core/providers/database_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/cat_personality_profile.dart';
import '../../data/models/question.dart';
import '../../data/models/personality_type.dart';
import '../../data/repositories/question_repository.dart';
import '../../domain/scoring_engine.dart';

enum TestPhase { intro, inProgress, analyzing, result }

class TestState {
  final TestPhase phase;
  final TestMode mode;
  final String languageCode;
  final List<Question> questions;
  final int currentIndex;
  final Map<int, int> answers; // questionNumber → score
  final TestResult? result;
  final int? testCatId;
  final bool hasTriedPersistingResult;
  final bool isResultPersisted;

  const TestState({
    this.phase = TestPhase.intro,
    this.mode = TestMode.basic,
    this.languageCode = 'zh',
    this.questions = const [],
    this.currentIndex = 0,
    this.answers = const {},
    this.result,
    this.testCatId,
    this.hasTriedPersistingResult = false,
    this.isResultPersisted = false,
  });

  TestState copyWith({
    TestPhase? phase,
    TestMode? mode,
    String? languageCode,
    List<Question>? questions,
    int? currentIndex,
    Map<int, int>? answers,
    TestResult? result,
    int? testCatId,
    bool? hasTriedPersistingResult,
    bool? isResultPersisted,
  }) {
    return TestState(
      phase: phase ?? this.phase,
      mode: mode ?? this.mode,
      languageCode: languageCode ?? this.languageCode,
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      answers: answers ?? this.answers,
      result: result ?? this.result,
      testCatId: testCatId ?? this.testCatId,
      hasTriedPersistingResult:
          hasTriedPersistingResult ?? this.hasTriedPersistingResult,
      isResultPersisted: isResultPersisted ?? this.isResultPersisted,
    );
  }

  Question? get currentQuestion =>
      currentIndex < questions.length ? questions[currentIndex] : null;

  double get progress =>
      questions.isEmpty ? 0 : (currentIndex + 1) / questions.length;

  bool get isLastQuestion => currentIndex >= questions.length - 1;
}

final testProvider = NotifierProvider<TestNotifier, TestState>(
  TestNotifier.new,
);

class TestNotifier extends Notifier<TestState> {
  @override
  TestState build() => const TestState();

  void startTest(TestMode mode, {int? catId, required String languageCode}) {
    final normalizedLanguageCode = languageCode == 'en' ? 'en' : 'zh';
    final questions = QuestionRepository.getQuestions(
      mode,
      languageCode: normalizedLanguageCode,
    );
    state = TestState(
      phase: TestPhase.inProgress,
      mode: mode,
      languageCode: normalizedLanguageCode,
      questions: questions,
      currentIndex: 0,
      answers: {},
      testCatId: catId,
    );
  }

  void answerQuestion(int score) {
    final question = state.currentQuestion;
    if (question == null) return;

    final newAnswers = {...state.answers, question.number: score};

    if (state.isLastQuestion) {
      // All questions answered → go to analyzing phase
      state = state.copyWith(answers: newAnswers, phase: TestPhase.analyzing);
    } else {
      // Move to next question
      state = state.copyWith(
        answers: newAnswers,
        currentIndex: state.currentIndex + 1,
      );
    }
  }

  Future<void> finishAnalyzing() async {
    final testCatId = state.testCatId ?? ref.read(currentCatProvider)?.id;
    final result = ScoringEngine.calculate(
      answers: state.answers,
      mode: state.mode,
      languageCode: state.languageCode,
    );
    state = state.copyWith(
      phase: TestPhase.result,
      result: result,
      hasTriedPersistingResult: false,
      isResultPersisted: false,
    );

    if (testCatId == null) {
      state = state.copyWith(
        hasTriedPersistingResult: true,
        isResultPersisted: false,
      );
      return;
    }

    try {
      final saved = await ref
          .read(catDaoProvider)
          .updatePersonalityResult(
            catId: testCatId,
            code: result.personality.code,
            hasDualPersonality: result.hasDualPersonality,
            mode: state.mode.name,
            dimensionScoresJson: CatPersonalityProfile.encodeScoreMap(
              result.dimensionScores,
            ),
            maxScoresJson: CatPersonalityProfile.encodeScoreMap(
              result.maxScores,
            ),
          );

      if (saved) {
        final currentCat = ref.read(currentCatProvider);
        if (currentCat?.id == testCatId) {
          await ref.read(currentCatProvider.notifier).refresh();
        }
      }

      state = state.copyWith(
        hasTriedPersistingResult: true,
        isResultPersisted: saved,
      );
    } catch (_) {
      state = state.copyWith(
        hasTriedPersistingResult: true,
        isResultPersisted: false,
      );
    }
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
