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
  String get soundsPageTitle => 'Cat Language';

  @override
  String get soundsTitle => 'Cat Sound Simulator';

  @override
  String get soundCategoryCalling => 'Calling';

  @override
  String get soundCategoryEmotion => 'Emotion';

  @override
  String get soundCategoryEnvironment => 'Environment';

  @override
  String get soundsSubtitleEmotion => 'Cat\'s Emotional Expressions';

  @override
  String get soundsSubtitleCalling => 'Calling & Environment Sounds';

  @override
  String get soundLooping => 'Looping';

  @override
  String get testTitle => '16 Cat Personalities';

  @override
  String get testSubtitle => 'Discover your cat\'s hidden personality';

  @override
  String get testBasicMode => 'Basic (12 questions)';

  @override
  String get testAdvancedMode => 'Advanced (24 questions)';

  @override
  String get testBasicModeDesc =>
      'Quickly understand your cat\'s basic personality';

  @override
  String get testAdvancedModeDesc =>
      'More comprehensive analysis, identify dual personality';

  @override
  String get testTheoryDesc =>
      'Based on MBTI theory, reveal your cat\'s unique personality\nthrough daily behavior observations';

  @override
  String get testTip =>
      'Answer based on your cat\'s daily behavior, there are no right or wrong answers~';

  @override
  String testQuestionCount(int count) {
    return '$count questions';
  }

  @override
  String get testAnalyzing => 'Analyzing cat personality...';

  @override
  String testProgressLabel(int current, int total) {
    return 'Question $current / $total';
  }

  @override
  String get analyzingTitle => 'Analyzing...';

  @override
  String get analyzingStep1 => 'Analyzing behavior patterns...';

  @override
  String get analyzingStep2 => 'Identifying personality dimensions...';

  @override
  String get analyzingStep3 => 'Calculating match score...';

  @override
  String get analyzingStep4 => 'Generating personality report...';

  @override
  String get testResultTitle => 'Test Result';

  @override
  String get testResultDualPersonality => 'Has dual personality traits';

  @override
  String get testResultDimAnalysis => 'Dimension Analysis';

  @override
  String get testResultDescription => 'Personality Description';

  @override
  String get testResultAdvice => 'Care Advice';

  @override
  String get testResultRetake => 'Retake Test';

  @override
  String get testResultPoster => 'Share Poster';

  @override
  String get healthDashboardTitle => 'Cat Health';

  @override
  String get healthTitle => 'Health Tracking';

  @override
  String get healthPreparing => 'Preparing...';

  @override
  String get healthTodayRecords => 'Today\'s Records';

  @override
  String get healthSwitchCat => 'Switch Cat';

  @override
  String get healthWeightOutOfGoalWarning =>
      'Weight is outside the target range. Consider more frequent weighing and diet monitoring.';

  @override
  String get healthWeight => 'Weight';

  @override
  String get healthWater => 'Water';

  @override
  String get healthDiet => 'Diet';

  @override
  String get healthExcretion => 'Excretion';

  @override
  String get healthNoChange => 'No change';

  @override
  String healthWaterTarget(String target) {
    return 'Target ${target}ml';
  }

  @override
  String get healthDietDone => 'Completed';

  @override
  String get healthDietInProgress => 'In progress';

  @override
  String healthDietMealsUnit(int count) {
    return '/${count}x';
  }

  @override
  String healthTimelineWeight(String value) {
    return 'Weigh ${value}kg';
  }

  @override
  String healthTimelineDiet(String value) {
    return 'Meal ${value}g';
  }

  @override
  String healthTimelineWater(String value) {
    return 'Water ${value}ml';
  }

  @override
  String get healthTimelinePoop => 'Poop';

  @override
  String get healthTimelineUrine => 'Urine';

  @override
  String get healthTimelineEmpty =>
      'No records today\nTap + to start recording';

  @override
  String get healthTimelineDeleteTitle => 'Confirm Delete';

  @override
  String get healthTimelineDeleteContent => 'Delete this record?';

  @override
  String healthWeightGoalRange(String min, String max) {
    return 'Goal $min-${max}kg';
  }

  @override
  String healthWeightGoalMin(String min) {
    return 'Goal >= ${min}kg';
  }

  @override
  String healthWeightGoalMax(String max) {
    return 'Goal <= ${max}kg';
  }

  @override
  String get healthWeightExceeded => ' (exceeded)';

  @override
  String healthWeightAlert(String percent) {
    return 'Weight changed more than $percent% in 30 days';
  }

  @override
  String get weightSheetTitle => '⚖️ Weight Record';

  @override
  String weightLastRecord(String weight, String date) {
    return 'Last: ${weight}kg ($date)';
  }

  @override
  String get weightLastRecordToday => 'Today';

  @override
  String weightDaysAgo(int days) {
    return '$days days ago';
  }

  @override
  String get weightMoodLabel => 'Weighing Cooperation';

  @override
  String get weightMoodCooperative => 'Cooperative';

  @override
  String get weightMoodNeutral => 'Neutral';

  @override
  String get weightMoodResistant => 'Resistant';

  @override
  String get weightOutOfGoalTitle => 'Outside Target Range';

  @override
  String weightOutOfGoalContent(String weight) {
    return 'Current weight ${weight}kg is outside the target. Continue saving?';
  }

  @override
  String get weightContinueSave => 'Continue Saving';

  @override
  String weightGoalRange(String min, String max) {
    return 'Goal range $min - $max kg';
  }

  @override
  String weightGoalMinLimit(String min) {
    return 'Goal lower limit $min kg';
  }

  @override
  String weightGoalMaxLimit(String max) {
    return 'Goal upper limit $max kg';
  }

  @override
  String get weightGoalExceeded => ' (exceeded)';

  @override
  String get dietSheetTitle => '🍚 Diet Record';

  @override
  String dietTodayMeals(int current, int target) {
    return 'Today\'s meals: $current/$target (after saving)';
  }

  @override
  String get dietBrandSection => 'Brand/Type';

  @override
  String get dietFoodTypeSection => 'Food Type';

  @override
  String get dietAmountSection => 'Amount (g)';

  @override
  String get dietSameAsLast => 'Same as last record';

  @override
  String get dietTapToChangeTime => 'Tap to change time';

  @override
  String dietConfirmLargeAmount(String amount) {
    return 'The amount is large (${amount}g), are you sure?';
  }

  @override
  String get waterSheetTitle => '💧 Water Record';

  @override
  String get waterQuickSmall => 'Sip';

  @override
  String get waterQuickHalf => 'Half Cup';

  @override
  String get waterQuickOne => 'One Cup';

  @override
  String get waterQuickFull => 'Full Bowl';

  @override
  String waterTodayTarget(String current, String target) {
    return 'Today\'s target: $current/${target}ml';
  }

  @override
  String get excretionSheetTitle => '🐾 Excretion Record';

  @override
  String get excretionTabPoop => 'Poop 💩';

  @override
  String get excretionTabUrine => 'Urine 💧';

  @override
  String get excretionPoop1Name => 'Dry Pellets';

  @override
  String get excretionPoop1Desc => 'Hard, increase water intake';

  @override
  String get excretionPoop2Name => 'Perfect Banana';

  @override
  String get excretionPoop2Desc => 'Healthy standard';

  @override
  String get excretionPoop3Name => 'Soft Formless';

  @override
  String get excretionPoop3Desc => 'Poor digestion';

  @override
  String get excretionPoop4Name => 'Watery Diarrhea';

  @override
  String get excretionPoop4Desc => 'See a vet';

  @override
  String get excretionUrineSmall => 'Small';

  @override
  String get excretionUrineMedium => 'Medium';

  @override
  String get excretionUrineLarge => 'Large';

  @override
  String get excretionAnomaly => 'Found anomaly (blood/foreign matter)';

  @override
  String get gamesTitle => 'Interactive Games';

  @override
  String get gamesPageTitle => 'Let\'s Play';

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
  String get moreCatProfileSubtitle => 'Manage cat information';

  @override
  String get moreSettings => 'Settings';

  @override
  String get moreSettingsSubtitle => 'App Settings';

  @override
  String get moreAbout => 'About';

  @override
  String get moreAboutSubtitle => 'Version info & feedback';

  @override
  String get moreTheater => 'Cat Theater';

  @override
  String get moreAI => 'AI Recognition';

  @override
  String get settingsPageTitle => 'Settings';

  @override
  String get settingsGameSection => 'Game Settings';

  @override
  String gameSettingsTitle(String gameName) {
    return '$gameName Settings';
  }

  @override
  String get gameSettingsSpeedFrequency => 'Appearance Frequency';

  @override
  String get gameSettingsSpeedMovement => 'Movement Speed';

  @override
  String get gameSettingsSound => 'Sound Effects';

  @override
  String get gameSettingsSoundDesc => 'Play sounds during gameplay';

  @override
  String get gameSettingsVibration => 'Haptic Feedback';

  @override
  String get gameSettingsVibrationDesc => 'Vibrate when cat touches target';

  @override
  String get gameSettingsDescription => 'How to Play';

  @override
  String get gameSettingsStart => 'Start Game';

  @override
  String get posterTitle => 'My Cat\'s Personality Report';

  @override
  String get posterSave => 'Save to Album';

  @override
  String get posterSaveComingSoon => 'Save feature coming soon...';

  @override
  String get posterShare => 'Share with Friends';

  @override
  String get posterShareComingSoon => 'Share feature coming soon...';

  @override
  String get posterFooter => 'Cat Language · 16 Purr-sonality Test';

  @override
  String get settingsLanguageSection => 'Language';

  @override
  String get settingsLanguageDesc => 'Choose app display language';

  @override
  String get settingsLanguageChinese => '中文';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageSystem => 'Follow System';

  @override
  String get aboutPageTitle => 'About';

  @override
  String get aboutAppName => 'MeowTalk';

  @override
  String get aboutFeedbackEmail => 'Feedback Email';

  @override
  String get aboutPrivacyPolicy => 'Privacy Policy';

  @override
  String get aboutPrivacyPolicySubtitle => 'Tap to view privacy policy';

  @override
  String get aboutCannotOpenLink => 'Cannot open link';

  @override
  String get splashTagline => 'Meow~';

  @override
  String get splashAppName => 'MeowTalk';

  @override
  String get splashSlogan => 'Understand your cat, hear what they say';

  @override
  String get catProfileTitle => 'Cat Profiles';

  @override
  String get catProfileEmpty => 'No cats yet';

  @override
  String get catProfileAddFirst => 'Tap the + button to add your first cat';

  @override
  String get catProfileManage => 'Manage your cat profiles';

  @override
  String get catAdded => 'Cat profile added';

  @override
  String get catUpdated => 'Cat profile updated';

  @override
  String get catDeleted => 'Cat profile deleted';

  @override
  String get catMinimumOne => 'At least one cat profile is required';

  @override
  String get catCannotDeleteTitle => 'Cannot Delete';

  @override
  String get catCannotDeleteContent =>
      'This cat has health records. Please handle those records first.';

  @override
  String get catGotIt => 'Got it';

  @override
  String get catDeleteTitle => 'Delete Cat Profile';

  @override
  String catDeleteConfirm(String name) {
    return 'Confirm deletion of \"$name\"?';
  }

  @override
  String catSwitched(String name) {
    return 'Switched to $name';
  }

  @override
  String catLoadFailed(String error) {
    return 'Load failed: $error';
  }

  @override
  String get catAddButton => 'Add Cat';

  @override
  String get catCurrentBadge => 'Current';

  @override
  String get catNoBreed => 'No breed set';

  @override
  String get catUnknownAge => 'Unknown age';

  @override
  String catAgeMonths(int months) {
    return '$months months';
  }

  @override
  String catAgeYears(int years) {
    return '$years years old';
  }

  @override
  String catAgeYearsMonths(int years, int months) {
    return '$years years $months months';
  }

  @override
  String get catSexMale => 'Male';

  @override
  String get catSexFemale => 'Female';

  @override
  String get catSexUnknown => 'Unknown sex';

  @override
  String get catNeutered => 'Neutered';

  @override
  String get catNotNeutered => 'Not neutered';

  @override
  String catWeightGoalRange(String min, String max) {
    return 'Weight goal $min-$max kg';
  }

  @override
  String catWeightGoalMin(String min) {
    return 'Weight goal ≥ $min kg';
  }

  @override
  String catWeightGoalMax(String max) {
    return 'Weight goal ≤ $max kg';
  }

  @override
  String catDailyTargets(String water, int meals) {
    return 'Water $water ml/day · Meals $meals times/day';
  }

  @override
  String get catLoadingTrend => 'Loading health trends...';

  @override
  String catTrend7DaysWater(String amount) {
    return '7-day avg water ${amount}ml';
  }

  @override
  String catTrendMeals(int count) {
    return 'Fed $count times';
  }

  @override
  String get catTrendWeightNoData => 'Weight: No data';

  @override
  String catTrendWeightChange(String change) {
    return 'Weight ${change}kg';
  }

  @override
  String get catFormBasicInfo => 'Basic Info';

  @override
  String get catFormName => 'Cat Name *';

  @override
  String get catFormNameHint => 'Enter cat name';

  @override
  String get catFormNameRequired => 'Please enter a cat name';

  @override
  String get catFormBreed => 'Breed';

  @override
  String get catFormBreedHint => 'e.g. British Shorthair';

  @override
  String get catFormSex => 'Sex';

  @override
  String get catFormSexUnknown => 'Unknown';

  @override
  String get catFormSexMale => 'Male';

  @override
  String get catFormSexFemale => 'Female';

  @override
  String get catFormBirthDate => 'Birth Date';

  @override
  String get catFormBirthDateNotSet => 'Not set';

  @override
  String get catFormNeutered => 'Neutered';

  @override
  String get catFormHealthGoals => 'Health Goals';

  @override
  String get catFormWeightMin => 'Min Weight Goal (kg)';

  @override
  String get catFormWeightMinHint => 'e.g. 3.5';

  @override
  String get catFormWeightMax => 'Max Weight Goal (kg)';

  @override
  String get catFormWeightMaxHint => 'e.g. 5.0';

  @override
  String get catFormWaterTarget => 'Daily Water Target (ml)';

  @override
  String get catFormWaterHint => 'e.g. 200';

  @override
  String get catFormMealsTarget => 'Daily Meals Target';

  @override
  String get catFormMealsHint => 'e.g. 3';

  @override
  String get catFormSave => 'Save Changes';

  @override
  String get catFormCreate => 'Create Profile';

  @override
  String get catFormEditTitle => 'Edit Cat Profile';

  @override
  String get catFormNewTitle => 'New Cat Profile';

  @override
  String get catFormInvalidWater => 'Please enter a valid water target';

  @override
  String get catFormInvalidMeals => 'Please enter a valid meal count (1-20)';

  @override
  String get catFormInvalidWeight => 'Please enter a valid weight goal (kg)';

  @override
  String get catFormWeightRangeError => 'Min weight goal cannot exceed max';

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

  @override
  String get commonNoCat => 'Please add a cat first';

  @override
  String commonSaveFailed(String error) {
    return 'Save failed: $error';
  }

  @override
  String get commonTip => 'Notice';

  @override
  String get commonOk => 'OK';
}
