import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In zh, this message translates to:
  /// **'猫咪说'**
  String get appTitle;

  /// No description provided for @tabSounds.
  ///
  /// In zh, this message translates to:
  /// **'声音'**
  String get tabSounds;

  /// No description provided for @tabTest.
  ///
  /// In zh, this message translates to:
  /// **'性格'**
  String get tabTest;

  /// No description provided for @tabHealth.
  ///
  /// In zh, this message translates to:
  /// **'健康'**
  String get tabHealth;

  /// No description provided for @tabGames.
  ///
  /// In zh, this message translates to:
  /// **'游戏'**
  String get tabGames;

  /// No description provided for @tabMore.
  ///
  /// In zh, this message translates to:
  /// **'更多'**
  String get tabMore;

  /// No description provided for @soundsPageTitle.
  ///
  /// In zh, this message translates to:
  /// **'猫咪语言'**
  String get soundsPageTitle;

  /// No description provided for @soundsTitle.
  ///
  /// In zh, this message translates to:
  /// **'猫鸣模拟器'**
  String get soundsTitle;

  /// No description provided for @soundCategoryCalling.
  ///
  /// In zh, this message translates to:
  /// **'呼唤'**
  String get soundCategoryCalling;

  /// No description provided for @soundCategoryEmotion.
  ///
  /// In zh, this message translates to:
  /// **'情感'**
  String get soundCategoryEmotion;

  /// No description provided for @soundCategoryEnvironment.
  ///
  /// In zh, this message translates to:
  /// **'环境'**
  String get soundCategoryEnvironment;

  /// No description provided for @soundsSubtitleEmotion.
  ///
  /// In zh, this message translates to:
  /// **'猫咪的情绪表达'**
  String get soundsSubtitleEmotion;

  /// No description provided for @soundsSubtitleCalling.
  ///
  /// In zh, this message translates to:
  /// **'召唤猫咪与环境音'**
  String get soundsSubtitleCalling;

  /// No description provided for @soundLooping.
  ///
  /// In zh, this message translates to:
  /// **'循环中'**
  String get soundLooping;

  /// No description provided for @testTitle.
  ///
  /// In zh, this message translates to:
  /// **'16喵格测试'**
  String get testTitle;

  /// No description provided for @testSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'测测你家猫的隐藏性格'**
  String get testSubtitle;

  /// No description provided for @testBasicMode.
  ///
  /// In zh, this message translates to:
  /// **'基础版 (12题)'**
  String get testBasicMode;

  /// No description provided for @testAdvancedMode.
  ///
  /// In zh, this message translates to:
  /// **'进阶版 (24题)'**
  String get testAdvancedMode;

  /// No description provided for @testBasicModeDesc.
  ///
  /// In zh, this message translates to:
  /// **'快速了解猫咪基本性格倾向'**
  String get testBasicModeDesc;

  /// No description provided for @testAdvancedModeDesc.
  ///
  /// In zh, this message translates to:
  /// **'更全面的性格分析，识别双重性格'**
  String get testAdvancedModeDesc;

  /// No description provided for @testTheoryDesc.
  ///
  /// In zh, this message translates to:
  /// **'基于 MBTI 理论，通过观察猫咪的日常行为\n揭示它独特的性格密码'**
  String get testTheoryDesc;

  /// No description provided for @testTip.
  ///
  /// In zh, this message translates to:
  /// **'回答时请基于猫咪的日常表现，没有对错之分哦~'**
  String get testTip;

  /// No description provided for @testQuestionCount.
  ///
  /// In zh, this message translates to:
  /// **'{count}题'**
  String testQuestionCount(int count);

  /// No description provided for @testAnalyzing.
  ///
  /// In zh, this message translates to:
  /// **'正在分析猫咪性格...'**
  String get testAnalyzing;

  /// No description provided for @testProgressLabel.
  ///
  /// In zh, this message translates to:
  /// **'第{current}题 / 共{total}题'**
  String testProgressLabel(int current, int total);

  /// No description provided for @analyzingTitle.
  ///
  /// In zh, this message translates to:
  /// **'正在分析中...'**
  String get analyzingTitle;

  /// No description provided for @analyzingStep1.
  ///
  /// In zh, this message translates to:
  /// **'分析行为模式...'**
  String get analyzingStep1;

  /// No description provided for @analyzingStep2.
  ///
  /// In zh, this message translates to:
  /// **'识别性格维度...'**
  String get analyzingStep2;

  /// No description provided for @analyzingStep3.
  ///
  /// In zh, this message translates to:
  /// **'计算匹配度...'**
  String get analyzingStep3;

  /// No description provided for @analyzingStep4.
  ///
  /// In zh, this message translates to:
  /// **'生成性格报告...'**
  String get analyzingStep4;

  /// No description provided for @testResultTitle.
  ///
  /// In zh, this message translates to:
  /// **'测试结果'**
  String get testResultTitle;

  /// No description provided for @testResultDualPersonality.
  ///
  /// In zh, this message translates to:
  /// **'具有双重性格特质'**
  String get testResultDualPersonality;

  /// No description provided for @testResultDimAnalysis.
  ///
  /// In zh, this message translates to:
  /// **'维度分析'**
  String get testResultDimAnalysis;

  /// No description provided for @testResultDescription.
  ///
  /// In zh, this message translates to:
  /// **'性格描述'**
  String get testResultDescription;

  /// No description provided for @testResultAdvice.
  ///
  /// In zh, this message translates to:
  /// **'喂养建议'**
  String get testResultAdvice;

  /// No description provided for @testResultRetake.
  ///
  /// In zh, this message translates to:
  /// **'重新测试'**
  String get testResultRetake;

  /// No description provided for @testResultPoster.
  ///
  /// In zh, this message translates to:
  /// **'生成海报'**
  String get testResultPoster;

  /// No description provided for @healthDashboardTitle.
  ///
  /// In zh, this message translates to:
  /// **'猫咪健康'**
  String get healthDashboardTitle;

  /// No description provided for @healthTitle.
  ///
  /// In zh, this message translates to:
  /// **'健康记录'**
  String get healthTitle;

  /// No description provided for @healthPreparing.
  ///
  /// In zh, this message translates to:
  /// **'正在准备...'**
  String get healthPreparing;

  /// No description provided for @healthTodayRecords.
  ///
  /// In zh, this message translates to:
  /// **'今日记录'**
  String get healthTodayRecords;

  /// No description provided for @healthSwitchCat.
  ///
  /// In zh, this message translates to:
  /// **'切换猫咪'**
  String get healthSwitchCat;

  /// No description provided for @healthWeightOutOfGoalWarning.
  ///
  /// In zh, this message translates to:
  /// **'体重已超出档案目标区间，建议近期增加称重和饮食观察。'**
  String get healthWeightOutOfGoalWarning;

  /// No description provided for @healthWeight.
  ///
  /// In zh, this message translates to:
  /// **'体重'**
  String get healthWeight;

  /// No description provided for @healthWater.
  ///
  /// In zh, this message translates to:
  /// **'饮水'**
  String get healthWater;

  /// No description provided for @healthDiet.
  ///
  /// In zh, this message translates to:
  /// **'饮食'**
  String get healthDiet;

  /// No description provided for @healthExcretion.
  ///
  /// In zh, this message translates to:
  /// **'排泄'**
  String get healthExcretion;

  /// No description provided for @healthNoChange.
  ///
  /// In zh, this message translates to:
  /// **'暂无变化'**
  String get healthNoChange;

  /// No description provided for @healthWaterTarget.
  ///
  /// In zh, this message translates to:
  /// **'目标 {target}ml'**
  String healthWaterTarget(String target);

  /// No description provided for @healthDietDone.
  ///
  /// In zh, this message translates to:
  /// **'已完成'**
  String get healthDietDone;

  /// No description provided for @healthDietInProgress.
  ///
  /// In zh, this message translates to:
  /// **'进行中'**
  String get healthDietInProgress;

  /// No description provided for @healthDietMealsUnit.
  ///
  /// In zh, this message translates to:
  /// **'/{count}次'**
  String healthDietMealsUnit(int count);

  /// No description provided for @healthTimelineWeight.
  ///
  /// In zh, this message translates to:
  /// **'称重 {value}kg'**
  String healthTimelineWeight(String value);

  /// No description provided for @healthTimelineDiet.
  ///
  /// In zh, this message translates to:
  /// **'干饭时刻 {value}g'**
  String healthTimelineDiet(String value);

  /// No description provided for @healthTimelineWater.
  ///
  /// In zh, this message translates to:
  /// **'饮水 {value}ml'**
  String healthTimelineWater(String value);

  /// No description provided for @healthTimelinePoop.
  ///
  /// In zh, this message translates to:
  /// **'排便'**
  String get healthTimelinePoop;

  /// No description provided for @healthTimelineUrine.
  ///
  /// In zh, this message translates to:
  /// **'排尿'**
  String get healthTimelineUrine;

  /// No description provided for @healthTimelineEmpty.
  ///
  /// In zh, this message translates to:
  /// **'今天还没有记录\n点击右下角 + 开始记录吧'**
  String get healthTimelineEmpty;

  /// No description provided for @healthTimelineDeleteTitle.
  ///
  /// In zh, this message translates to:
  /// **'确认删除'**
  String get healthTimelineDeleteTitle;

  /// No description provided for @healthTimelineDeleteContent.
  ///
  /// In zh, this message translates to:
  /// **'确定要删除这条记录吗？'**
  String get healthTimelineDeleteContent;

  /// No description provided for @healthWeightGoalRange.
  ///
  /// In zh, this message translates to:
  /// **'目标 {min}-{max}kg'**
  String healthWeightGoalRange(String min, String max);

  /// No description provided for @healthWeightGoalMin.
  ///
  /// In zh, this message translates to:
  /// **'目标 >= {min}kg'**
  String healthWeightGoalMin(String min);

  /// No description provided for @healthWeightGoalMax.
  ///
  /// In zh, this message translates to:
  /// **'目标 <= {max}kg'**
  String healthWeightGoalMax(String max);

  /// No description provided for @healthWeightExceeded.
  ///
  /// In zh, this message translates to:
  /// **'（当前超出）'**
  String get healthWeightExceeded;

  /// No description provided for @healthWeightAlert.
  ///
  /// In zh, this message translates to:
  /// **'近30天体重变化超过{percent}%'**
  String healthWeightAlert(String percent);

  /// No description provided for @weightSheetTitle.
  ///
  /// In zh, this message translates to:
  /// **'⚖️ 体重记录'**
  String get weightSheetTitle;

  /// No description provided for @weightLastRecord.
  ///
  /// In zh, this message translates to:
  /// **'上次记录：{weight}kg（{date}）'**
  String weightLastRecord(String weight, String date);

  /// No description provided for @weightLastRecordToday.
  ///
  /// In zh, this message translates to:
  /// **'今天'**
  String get weightLastRecordToday;

  /// No description provided for @weightDaysAgo.
  ///
  /// In zh, this message translates to:
  /// **'{days}天前'**
  String weightDaysAgo(int days);

  /// No description provided for @weightMoodLabel.
  ///
  /// In zh, this message translates to:
  /// **'称重配合度'**
  String get weightMoodLabel;

  /// No description provided for @weightMoodCooperative.
  ///
  /// In zh, this message translates to:
  /// **'配合'**
  String get weightMoodCooperative;

  /// No description provided for @weightMoodNeutral.
  ///
  /// In zh, this message translates to:
  /// **'一般'**
  String get weightMoodNeutral;

  /// No description provided for @weightMoodResistant.
  ///
  /// In zh, this message translates to:
  /// **'暴躁'**
  String get weightMoodResistant;

  /// No description provided for @weightOutOfGoalTitle.
  ///
  /// In zh, this message translates to:
  /// **'超出目标区间'**
  String get weightOutOfGoalTitle;

  /// No description provided for @weightOutOfGoalContent.
  ///
  /// In zh, this message translates to:
  /// **'当前体重 {weight}kg 已超出档案目标，是否继续保存？'**
  String weightOutOfGoalContent(String weight);

  /// No description provided for @weightContinueSave.
  ///
  /// In zh, this message translates to:
  /// **'继续保存'**
  String get weightContinueSave;

  /// No description provided for @weightGoalRange.
  ///
  /// In zh, this message translates to:
  /// **'目标区间 {min} - {max} kg'**
  String weightGoalRange(String min, String max);

  /// No description provided for @weightGoalMinLimit.
  ///
  /// In zh, this message translates to:
  /// **'目标下限 {min} kg'**
  String weightGoalMinLimit(String min);

  /// No description provided for @weightGoalMaxLimit.
  ///
  /// In zh, this message translates to:
  /// **'目标上限 {max} kg'**
  String weightGoalMaxLimit(String max);

  /// No description provided for @weightGoalExceeded.
  ///
  /// In zh, this message translates to:
  /// **'（当前超出）'**
  String get weightGoalExceeded;

  /// No description provided for @dietSheetTitle.
  ///
  /// In zh, this message translates to:
  /// **'🍚 饮食记录'**
  String get dietSheetTitle;

  /// No description provided for @dietTodayMeals.
  ///
  /// In zh, this message translates to:
  /// **'今日喂食：{current}/{target} 次（保存后）'**
  String dietTodayMeals(int current, int target);

  /// No description provided for @dietBrandSection.
  ///
  /// In zh, this message translates to:
  /// **'品牌/种类'**
  String get dietBrandSection;

  /// No description provided for @dietFoodTypeSection.
  ///
  /// In zh, this message translates to:
  /// **'食物类型'**
  String get dietFoodTypeSection;

  /// No description provided for @dietAmountSection.
  ///
  /// In zh, this message translates to:
  /// **'进食量 (g)'**
  String get dietAmountSection;

  /// No description provided for @dietSameAsLast.
  ///
  /// In zh, this message translates to:
  /// **'同前一次记录'**
  String get dietSameAsLast;

  /// No description provided for @dietTapToChangeTime.
  ///
  /// In zh, this message translates to:
  /// **'点击修改时间'**
  String get dietTapToChangeTime;

  /// No description provided for @dietConfirmLargeAmount.
  ///
  /// In zh, this message translates to:
  /// **'输入的数值较大（{amount}g），确定吗？'**
  String dietConfirmLargeAmount(String amount);

  /// No description provided for @waterSheetTitle.
  ///
  /// In zh, this message translates to:
  /// **'💧 饮水记录'**
  String get waterSheetTitle;

  /// No description provided for @waterQuickSmall.
  ///
  /// In zh, this message translates to:
  /// **'小口'**
  String get waterQuickSmall;

  /// No description provided for @waterQuickHalf.
  ///
  /// In zh, this message translates to:
  /// **'半杯'**
  String get waterQuickHalf;

  /// No description provided for @waterQuickOne.
  ///
  /// In zh, this message translates to:
  /// **'一杯'**
  String get waterQuickOne;

  /// No description provided for @waterQuickFull.
  ///
  /// In zh, this message translates to:
  /// **'满碗'**
  String get waterQuickFull;

  /// No description provided for @waterTodayTarget.
  ///
  /// In zh, this message translates to:
  /// **'今日目标：{current}/{target}ml'**
  String waterTodayTarget(String current, String target);

  /// No description provided for @excretionSheetTitle.
  ///
  /// In zh, this message translates to:
  /// **'🐾 排泄记录'**
  String get excretionSheetTitle;

  /// No description provided for @excretionTabPoop.
  ///
  /// In zh, this message translates to:
  /// **'粑粑 💩'**
  String get excretionTabPoop;

  /// No description provided for @excretionTabUrine.
  ///
  /// In zh, this message translates to:
  /// **'尿尿 💧'**
  String get excretionTabUrine;

  /// No description provided for @excretionPoop1Name.
  ///
  /// In zh, this message translates to:
  /// **'干燥球状'**
  String get excretionPoop1Name;

  /// No description provided for @excretionPoop1Desc.
  ///
  /// In zh, this message translates to:
  /// **'偏硬，注意饮水'**
  String get excretionPoop1Desc;

  /// No description provided for @excretionPoop2Name.
  ///
  /// In zh, this message translates to:
  /// **'完美香蕉'**
  String get excretionPoop2Name;

  /// No description provided for @excretionPoop2Desc.
  ///
  /// In zh, this message translates to:
  /// **'健康标准'**
  String get excretionPoop2Desc;

  /// No description provided for @excretionPoop3Name.
  ///
  /// In zh, this message translates to:
  /// **'软便无形'**
  String get excretionPoop3Name;

  /// No description provided for @excretionPoop3Desc.
  ///
  /// In zh, this message translates to:
  /// **'消化不良'**
  String get excretionPoop3Desc;

  /// No description provided for @excretionPoop4Name.
  ///
  /// In zh, this message translates to:
  /// **'水样拉稀'**
  String get excretionPoop4Name;

  /// No description provided for @excretionPoop4Desc.
  ///
  /// In zh, this message translates to:
  /// **'建议就医'**
  String get excretionPoop4Desc;

  /// No description provided for @excretionUrineSmall.
  ///
  /// In zh, this message translates to:
  /// **'小团'**
  String get excretionUrineSmall;

  /// No description provided for @excretionUrineMedium.
  ///
  /// In zh, this message translates to:
  /// **'中团'**
  String get excretionUrineMedium;

  /// No description provided for @excretionUrineLarge.
  ///
  /// In zh, this message translates to:
  /// **'大团'**
  String get excretionUrineLarge;

  /// No description provided for @excretionAnomaly.
  ///
  /// In zh, this message translates to:
  /// **'发现异常（血丝/异物）'**
  String get excretionAnomaly;

  /// No description provided for @gamesTitle.
  ///
  /// In zh, this message translates to:
  /// **'互动游戏'**
  String get gamesTitle;

  /// No description provided for @gamesPageTitle.
  ///
  /// In zh, this message translates to:
  /// **'玩个游戏'**
  String get gamesPageTitle;

  /// No description provided for @gameLaser.
  ///
  /// In zh, this message translates to:
  /// **'激光点'**
  String get gameLaser;

  /// No description provided for @gameMouseHunt.
  ///
  /// In zh, this message translates to:
  /// **'抓老鼠'**
  String get gameMouseHunt;

  /// No description provided for @gameRainbow.
  ///
  /// In zh, this message translates to:
  /// **'追彩虹'**
  String get gameRainbow;

  /// No description provided for @gameExitHint.
  ///
  /// In zh, this message translates to:
  /// **'长按角落3秒退出'**
  String get gameExitHint;

  /// No description provided for @moreTitle.
  ///
  /// In zh, this message translates to:
  /// **'更多'**
  String get moreTitle;

  /// No description provided for @moreCatProfile.
  ///
  /// In zh, this message translates to:
  /// **'猫咪档案'**
  String get moreCatProfile;

  /// No description provided for @moreCatProfileSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'管理你的猫咪信息'**
  String get moreCatProfileSubtitle;

  /// No description provided for @moreSettings.
  ///
  /// In zh, this message translates to:
  /// **'设置'**
  String get moreSettings;

  /// No description provided for @moreSettingsSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'应用设置'**
  String get moreSettingsSubtitle;

  /// No description provided for @moreAbout.
  ///
  /// In zh, this message translates to:
  /// **'关于'**
  String get moreAbout;

  /// No description provided for @moreAboutSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'版本信息与反馈'**
  String get moreAboutSubtitle;

  /// No description provided for @moreTheater.
  ///
  /// In zh, this message translates to:
  /// **'喵剧场'**
  String get moreTheater;

  /// No description provided for @moreAI.
  ///
  /// In zh, this message translates to:
  /// **'AI 识别'**
  String get moreAI;

  /// No description provided for @settingsPageTitle.
  ///
  /// In zh, this message translates to:
  /// **'设置'**
  String get settingsPageTitle;

  /// No description provided for @settingsGameSection.
  ///
  /// In zh, this message translates to:
  /// **'游戏设置'**
  String get settingsGameSection;

  /// No description provided for @gameSettingsTitle.
  ///
  /// In zh, this message translates to:
  /// **'{gameName} 设置'**
  String gameSettingsTitle(String gameName);

  /// No description provided for @gameSettingsSpeedFrequency.
  ///
  /// In zh, this message translates to:
  /// **'出现频率'**
  String get gameSettingsSpeedFrequency;

  /// No description provided for @gameSettingsSpeedMovement.
  ///
  /// In zh, this message translates to:
  /// **'移动速度'**
  String get gameSettingsSpeedMovement;

  /// No description provided for @gameSettingsSound.
  ///
  /// In zh, this message translates to:
  /// **'音效'**
  String get gameSettingsSound;

  /// No description provided for @gameSettingsSoundDesc.
  ///
  /// In zh, this message translates to:
  /// **'游戏过程中播放音效'**
  String get gameSettingsSoundDesc;

  /// No description provided for @gameSettingsVibration.
  ///
  /// In zh, this message translates to:
  /// **'震动反馈'**
  String get gameSettingsVibration;

  /// No description provided for @gameSettingsVibrationDesc.
  ///
  /// In zh, this message translates to:
  /// **'猫咪触碰目标时震动'**
  String get gameSettingsVibrationDesc;

  /// No description provided for @gameSettingsDescription.
  ///
  /// In zh, this message translates to:
  /// **'游戏说明'**
  String get gameSettingsDescription;

  /// No description provided for @gameSettingsStart.
  ///
  /// In zh, this message translates to:
  /// **'开始游戏'**
  String get gameSettingsStart;

  /// No description provided for @posterTitle.
  ///
  /// In zh, this message translates to:
  /// **'我的猫咪性格报告'**
  String get posterTitle;

  /// No description provided for @posterSave.
  ///
  /// In zh, this message translates to:
  /// **'保存到相册'**
  String get posterSave;

  /// No description provided for @posterSaveComingSoon.
  ///
  /// In zh, this message translates to:
  /// **'海报保存功能开发中...'**
  String get posterSaveComingSoon;

  /// No description provided for @posterShare.
  ///
  /// In zh, this message translates to:
  /// **'分享给好友'**
  String get posterShare;

  /// No description provided for @posterShareComingSoon.
  ///
  /// In zh, this message translates to:
  /// **'分享功能开发中...'**
  String get posterShareComingSoon;

  /// No description provided for @posterFooter.
  ///
  /// In zh, this message translates to:
  /// **'猫咪语言 · 16喵格测试'**
  String get posterFooter;

  /// No description provided for @settingsLanguageSection.
  ///
  /// In zh, this message translates to:
  /// **'语言'**
  String get settingsLanguageSection;

  /// No description provided for @settingsLanguageDesc.
  ///
  /// In zh, this message translates to:
  /// **'选择应用显示语言'**
  String get settingsLanguageDesc;

  /// No description provided for @settingsLanguageChinese.
  ///
  /// In zh, this message translates to:
  /// **'中文'**
  String get settingsLanguageChinese;

  /// No description provided for @settingsLanguageEnglish.
  ///
  /// In zh, this message translates to:
  /// **'English'**
  String get settingsLanguageEnglish;

  /// No description provided for @settingsLanguageSystem.
  ///
  /// In zh, this message translates to:
  /// **'跟随系统'**
  String get settingsLanguageSystem;

  /// No description provided for @aboutPageTitle.
  ///
  /// In zh, this message translates to:
  /// **'关于'**
  String get aboutPageTitle;

  /// No description provided for @aboutAppName.
  ///
  /// In zh, this message translates to:
  /// **'猫咪说'**
  String get aboutAppName;

  /// No description provided for @aboutFeedbackEmail.
  ///
  /// In zh, this message translates to:
  /// **'反馈邮箱'**
  String get aboutFeedbackEmail;

  /// No description provided for @aboutPrivacyPolicy.
  ///
  /// In zh, this message translates to:
  /// **'隐私协议'**
  String get aboutPrivacyPolicy;

  /// No description provided for @aboutPrivacyPolicySubtitle.
  ///
  /// In zh, this message translates to:
  /// **'点击查看详细隐私政策'**
  String get aboutPrivacyPolicySubtitle;

  /// No description provided for @aboutCannotOpenLink.
  ///
  /// In zh, this message translates to:
  /// **'无法打开链接'**
  String get aboutCannotOpenLink;

  /// No description provided for @splashTagline.
  ///
  /// In zh, this message translates to:
  /// **'瞄~瞄~'**
  String get splashTagline;

  /// No description provided for @splashAppName.
  ///
  /// In zh, this message translates to:
  /// **'猫咪说'**
  String get splashAppName;

  /// No description provided for @splashSlogan.
  ///
  /// In zh, this message translates to:
  /// **'懂猫，听猫咪说'**
  String get splashSlogan;

  /// No description provided for @catProfileTitle.
  ///
  /// In zh, this message translates to:
  /// **'猫咪档案'**
  String get catProfileTitle;

  /// No description provided for @catProfileEmpty.
  ///
  /// In zh, this message translates to:
  /// **'还没有猫咪'**
  String get catProfileEmpty;

  /// No description provided for @catProfileAddFirst.
  ///
  /// In zh, this message translates to:
  /// **'点击右下角添加你的第一只猫咪'**
  String get catProfileAddFirst;

  /// No description provided for @catProfileManage.
  ///
  /// In zh, this message translates to:
  /// **'管理你的猫咪信息'**
  String get catProfileManage;

  /// No description provided for @catAdded.
  ///
  /// In zh, this message translates to:
  /// **'已添加猫咪档案'**
  String get catAdded;

  /// No description provided for @catUpdated.
  ///
  /// In zh, this message translates to:
  /// **'已更新猫咪档案'**
  String get catUpdated;

  /// No description provided for @catDeleted.
  ///
  /// In zh, this message translates to:
  /// **'已删除猫咪档案'**
  String get catDeleted;

  /// No description provided for @catMinimumOne.
  ///
  /// In zh, this message translates to:
  /// **'至少保留一只猫咪档案'**
  String get catMinimumOne;

  /// No description provided for @catCannotDeleteTitle.
  ///
  /// In zh, this message translates to:
  /// **'无法删除'**
  String get catCannotDeleteTitle;

  /// No description provided for @catCannotDeleteContent.
  ///
  /// In zh, this message translates to:
  /// **'该猫咪已有健康记录，请先处理历史记录后再删除。'**
  String get catCannotDeleteContent;

  /// No description provided for @catGotIt.
  ///
  /// In zh, this message translates to:
  /// **'知道了'**
  String get catGotIt;

  /// No description provided for @catDeleteTitle.
  ///
  /// In zh, this message translates to:
  /// **'删除猫咪档案'**
  String get catDeleteTitle;

  /// No description provided for @catDeleteConfirm.
  ///
  /// In zh, this message translates to:
  /// **'确认删除「{name}」吗？'**
  String catDeleteConfirm(String name);

  /// No description provided for @catSwitched.
  ///
  /// In zh, this message translates to:
  /// **'已切换到 {name}'**
  String catSwitched(String name);

  /// No description provided for @catLoadFailed.
  ///
  /// In zh, this message translates to:
  /// **'加载失败：{error}'**
  String catLoadFailed(String error);

  /// No description provided for @catAddButton.
  ///
  /// In zh, this message translates to:
  /// **'添加猫咪'**
  String get catAddButton;

  /// No description provided for @catCurrentBadge.
  ///
  /// In zh, this message translates to:
  /// **'当前'**
  String get catCurrentBadge;

  /// No description provided for @catNoBreed.
  ///
  /// In zh, this message translates to:
  /// **'未设置品种'**
  String get catNoBreed;

  /// No description provided for @catUnknownAge.
  ///
  /// In zh, this message translates to:
  /// **'未知年龄'**
  String get catUnknownAge;

  /// No description provided for @catAgeMonths.
  ///
  /// In zh, this message translates to:
  /// **'{months} 个月'**
  String catAgeMonths(int months);

  /// No description provided for @catAgeYears.
  ///
  /// In zh, this message translates to:
  /// **'{years} 岁'**
  String catAgeYears(int years);

  /// No description provided for @catAgeYearsMonths.
  ///
  /// In zh, this message translates to:
  /// **'{years} 岁 {months} 个月'**
  String catAgeYearsMonths(int years, int months);

  /// No description provided for @catSexMale.
  ///
  /// In zh, this message translates to:
  /// **'公猫'**
  String get catSexMale;

  /// No description provided for @catSexFemale.
  ///
  /// In zh, this message translates to:
  /// **'母猫'**
  String get catSexFemale;

  /// No description provided for @catSexUnknown.
  ///
  /// In zh, this message translates to:
  /// **'性别未知'**
  String get catSexUnknown;

  /// No description provided for @catNeutered.
  ///
  /// In zh, this message translates to:
  /// **'已绝育'**
  String get catNeutered;

  /// No description provided for @catNotNeutered.
  ///
  /// In zh, this message translates to:
  /// **'未绝育'**
  String get catNotNeutered;

  /// No description provided for @catWeightGoalRange.
  ///
  /// In zh, this message translates to:
  /// **'体重目标 {min}-{max} kg'**
  String catWeightGoalRange(String min, String max);

  /// No description provided for @catWeightGoalMin.
  ///
  /// In zh, this message translates to:
  /// **'体重目标 ≥ {min} kg'**
  String catWeightGoalMin(String min);

  /// No description provided for @catWeightGoalMax.
  ///
  /// In zh, this message translates to:
  /// **'体重目标 ≤ {max} kg'**
  String catWeightGoalMax(String max);

  /// No description provided for @catDailyTargets.
  ///
  /// In zh, this message translates to:
  /// **'目标饮水 {water} ml / 日 · 目标喂食 {meals} 次 / 日'**
  String catDailyTargets(String water, int meals);

  /// No description provided for @catLoadingTrend.
  ///
  /// In zh, this message translates to:
  /// **'加载健康趋势中...'**
  String get catLoadingTrend;

  /// No description provided for @catTrend7DaysWater.
  ///
  /// In zh, this message translates to:
  /// **'近7天日均饮水 {amount}ml'**
  String catTrend7DaysWater(String amount);

  /// No description provided for @catTrendMeals.
  ///
  /// In zh, this message translates to:
  /// **'喂食 {count} 次'**
  String catTrendMeals(int count);

  /// No description provided for @catTrendWeightNoData.
  ///
  /// In zh, this message translates to:
  /// **'体重 无数据'**
  String get catTrendWeightNoData;

  /// No description provided for @catTrendWeightChange.
  ///
  /// In zh, this message translates to:
  /// **'体重 {change}kg'**
  String catTrendWeightChange(String change);

  /// No description provided for @catFormBasicInfo.
  ///
  /// In zh, this message translates to:
  /// **'基础信息'**
  String get catFormBasicInfo;

  /// No description provided for @catFormName.
  ///
  /// In zh, this message translates to:
  /// **'猫咪名称 *'**
  String get catFormName;

  /// No description provided for @catFormNameHint.
  ///
  /// In zh, this message translates to:
  /// **'请输入猫咪名称'**
  String get catFormNameHint;

  /// No description provided for @catFormNameRequired.
  ///
  /// In zh, this message translates to:
  /// **'请输入猫咪名称'**
  String get catFormNameRequired;

  /// No description provided for @catFormBreed.
  ///
  /// In zh, this message translates to:
  /// **'品种'**
  String get catFormBreed;

  /// No description provided for @catFormBreedHint.
  ///
  /// In zh, this message translates to:
  /// **'例如：英短、美短'**
  String get catFormBreedHint;

  /// No description provided for @catFormSex.
  ///
  /// In zh, this message translates to:
  /// **'性别'**
  String get catFormSex;

  /// No description provided for @catFormSexUnknown.
  ///
  /// In zh, this message translates to:
  /// **'未知'**
  String get catFormSexUnknown;

  /// No description provided for @catFormSexMale.
  ///
  /// In zh, this message translates to:
  /// **'公猫'**
  String get catFormSexMale;

  /// No description provided for @catFormSexFemale.
  ///
  /// In zh, this message translates to:
  /// **'母猫'**
  String get catFormSexFemale;

  /// No description provided for @catFormBirthDate.
  ///
  /// In zh, this message translates to:
  /// **'出生日期'**
  String get catFormBirthDate;

  /// No description provided for @catFormBirthDateNotSet.
  ///
  /// In zh, this message translates to:
  /// **'未设置'**
  String get catFormBirthDateNotSet;

  /// No description provided for @catFormNeutered.
  ///
  /// In zh, this message translates to:
  /// **'已绝育'**
  String get catFormNeutered;

  /// No description provided for @catFormHealthGoals.
  ///
  /// In zh, this message translates to:
  /// **'健康目标'**
  String get catFormHealthGoals;

  /// No description provided for @catFormWeightMin.
  ///
  /// In zh, this message translates to:
  /// **'体重目标下限 (kg)'**
  String get catFormWeightMin;

  /// No description provided for @catFormWeightMinHint.
  ///
  /// In zh, this message translates to:
  /// **'例如：3.5'**
  String get catFormWeightMinHint;

  /// No description provided for @catFormWeightMax.
  ///
  /// In zh, this message translates to:
  /// **'体重目标上限 (kg)'**
  String get catFormWeightMax;

  /// No description provided for @catFormWeightMaxHint.
  ///
  /// In zh, this message translates to:
  /// **'例如：5.0'**
  String get catFormWeightMaxHint;

  /// No description provided for @catFormWaterTarget.
  ///
  /// In zh, this message translates to:
  /// **'每日饮水目标 (ml)'**
  String get catFormWaterTarget;

  /// No description provided for @catFormWaterHint.
  ///
  /// In zh, this message translates to:
  /// **'例如：200'**
  String get catFormWaterHint;

  /// No description provided for @catFormMealsTarget.
  ///
  /// In zh, this message translates to:
  /// **'每日喂食目标 (次)'**
  String get catFormMealsTarget;

  /// No description provided for @catFormMealsHint.
  ///
  /// In zh, this message translates to:
  /// **'例如：3'**
  String get catFormMealsHint;

  /// No description provided for @catFormSave.
  ///
  /// In zh, this message translates to:
  /// **'保存修改'**
  String get catFormSave;

  /// No description provided for @catFormCreate.
  ///
  /// In zh, this message translates to:
  /// **'创建档案'**
  String get catFormCreate;

  /// No description provided for @catFormEditTitle.
  ///
  /// In zh, this message translates to:
  /// **'编辑猫咪档案'**
  String get catFormEditTitle;

  /// No description provided for @catFormNewTitle.
  ///
  /// In zh, this message translates to:
  /// **'新增猫咪档案'**
  String get catFormNewTitle;

  /// No description provided for @catFormInvalidWater.
  ///
  /// In zh, this message translates to:
  /// **'请填写正确的饮水目标'**
  String get catFormInvalidWater;

  /// No description provided for @catFormInvalidMeals.
  ///
  /// In zh, this message translates to:
  /// **'请填写正确的喂食次数（1-20）'**
  String get catFormInvalidMeals;

  /// No description provided for @catFormInvalidWeight.
  ///
  /// In zh, this message translates to:
  /// **'请填写正确的体重目标（kg）'**
  String get catFormInvalidWeight;

  /// No description provided for @catFormWeightRangeError.
  ///
  /// In zh, this message translates to:
  /// **'体重区间下限不能大于上限'**
  String get catFormWeightRangeError;

  /// No description provided for @commonSave.
  ///
  /// In zh, this message translates to:
  /// **'保存'**
  String get commonSave;

  /// No description provided for @commonCancel.
  ///
  /// In zh, this message translates to:
  /// **'取消'**
  String get commonCancel;

  /// No description provided for @commonDelete.
  ///
  /// In zh, this message translates to:
  /// **'删除'**
  String get commonDelete;

  /// No description provided for @commonConfirm.
  ///
  /// In zh, this message translates to:
  /// **'确认'**
  String get commonConfirm;

  /// No description provided for @commonEdit.
  ///
  /// In zh, this message translates to:
  /// **'编辑'**
  String get commonEdit;

  /// No description provided for @commonNoCat.
  ///
  /// In zh, this message translates to:
  /// **'请先添加一只猫咪'**
  String get commonNoCat;

  /// No description provided for @commonSaveFailed.
  ///
  /// In zh, this message translates to:
  /// **'保存失败：{error}'**
  String commonSaveFailed(String error);

  /// No description provided for @commonTip.
  ///
  /// In zh, this message translates to:
  /// **'提示'**
  String get commonTip;

  /// No description provided for @commonOk.
  ///
  /// In zh, this message translates to:
  /// **'确定'**
  String get commonOk;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
