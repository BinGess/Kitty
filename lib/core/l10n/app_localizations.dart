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
  /// **'猫咪语言'**
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

  /// No description provided for @testTitle.
  ///
  /// In zh, this message translates to:
  /// **'16喵格测试'**
  String get testTitle;

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

  /// No description provided for @testSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'测测你家猫的隐藏性格'**
  String get testSubtitle;

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

  /// No description provided for @healthTitle.
  ///
  /// In zh, this message translates to:
  /// **'健康记录'**
  String get healthTitle;

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

  /// No description provided for @healthWeightAlert.
  ///
  /// In zh, this message translates to:
  /// **'近30天体重变化超过{percent}%'**
  String healthWeightAlert(String percent);

  /// No description provided for @gamesTitle.
  ///
  /// In zh, this message translates to:
  /// **'互动游戏'**
  String get gamesTitle;

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

  /// No description provided for @moreSettings.
  ///
  /// In zh, this message translates to:
  /// **'设置'**
  String get moreSettings;

  /// No description provided for @catProfileEmpty.
  ///
  /// In zh, this message translates to:
  /// **'还没有猫咪'**
  String get catProfileEmpty;

  /// No description provided for @catProfileAddFirst.
  ///
  /// In zh, this message translates to:
  /// **'点击添加你的第一只猫咪'**
  String get catProfileAddFirst;

  /// No description provided for @catProfileManage.
  ///
  /// In zh, this message translates to:
  /// **'管理你的猫咪信息'**
  String get catProfileManage;

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
