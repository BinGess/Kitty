// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'MeowTalk';

  @override
  String get tabSounds => 'Sounds';

  @override
  String get tabTest => 'Test';

  @override
  String get tabHealth => 'Health';

  @override
  String get tabGames => 'Games';

  @override
  String get tabMore => 'More';

  @override
  String get soundsTitle => 'Cat Sound Simulator';

  @override
  String get soundCategoryCalling => 'Calling';

  @override
  String get soundCategoryEmotion => 'Emotion';

  @override
  String get soundCategoryEnvironment => 'Environment';

  @override
  String get testTitle => '16 Cat Personalities';

  @override
  String get testBasicMode => 'Basic (12 questions)';

  @override
  String get testAdvancedMode => 'Advanced (24 questions)';

  @override
  String get testSubtitle => 'Discover your cat\'s hidden personality';

  @override
  String get testAnalyzing => 'Analyzing cat personality...';

  @override
  String testProgressLabel(int current, int total) {
    return 'Question $current / $total';
  }

  @override
  String get healthTitle => 'Health Tracking';

  @override
  String get healthWeight => 'Weight';

  @override
  String get healthWater => 'Water';

  @override
  String get healthDiet => 'Diet';

  @override
  String get healthExcretion => 'Excretion';

  @override
  String healthWeightAlert(String percent) {
    return 'Weight changed more than $percent% in 30 days';
  }

  @override
  String get gamesTitle => 'Interactive Games';

  @override
  String get gameLaser => 'Laser Dot';

  @override
  String get gameMouseHunt => 'Mouse Hunt';

  @override
  String get gameRainbow => 'Rainbow Chase';

  @override
  String get gameExitHint => 'Long press corner for 3s to exit';

  @override
  String get moreTitle => 'More';

  @override
  String get moreCatProfile => 'Cat Profiles';

  @override
  String get moreTheater => 'Cat Theater';

  @override
  String get moreAI => 'AI Recognition';

  @override
  String get moreSettings => 'Settings';

  @override
  String get catProfileEmpty => 'No cats yet';

  @override
  String get catProfileAddFirst => 'Tap to add your first cat';

  @override
  String get catProfileManage => 'Manage your cat profiles';

  @override
  String get commonSave => 'Save';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get commonEdit => 'Edit';
}
