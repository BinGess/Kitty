// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '猫咪说';

  @override
  String get tabSounds => '声音';

  @override
  String get tabTest => '性格';

  @override
  String get tabHealth => '健康';

  @override
  String get tabGames => '游戏';

  @override
  String get tabMore => '更多';

  @override
  String get soundsPageTitle => '猫咪语言';

  @override
  String get soundsTitle => '猫鸣模拟器';

  @override
  String get soundCategoryCalling => '呼唤';

  @override
  String get soundCategoryEmotion => '情感';

  @override
  String get soundCategoryEnvironment => '环境';

  @override
  String get soundsSubtitleEmotion => '猫咪的情绪表达';

  @override
  String get soundsSubtitleCalling => '召唤猫咪与环境音';

  @override
  String get soundLooping => '循环中';

  @override
  String get testTitle => '16喵格测试';

  @override
  String get testSubtitle => '测测你家猫的隐藏性格';

  @override
  String get testBasicMode => '基础版 (12题)';

  @override
  String get testAdvancedMode => '进阶版 (24题)';

  @override
  String get testBasicModeDesc => '快速了解猫咪基本性格倾向';

  @override
  String get testAdvancedModeDesc => '更全面的性格分析，识别双重性格';

  @override
  String get testTheoryDesc => '基于 MBTI 理论，通过观察猫咪的日常行为\n揭示它独特的性格密码';

  @override
  String get testTip => '回答时请基于猫咪的日常表现，没有对错之分哦~';

  @override
  String testQuestionCount(int count) {
    return '$count题';
  }

  @override
  String get testAnalyzing => '正在分析猫咪性格...';

  @override
  String testProgressLabel(int current, int total) {
    return '第$current题 / 共$total题';
  }

  @override
  String get analyzingTitle => '正在分析中...';

  @override
  String get analyzingStep1 => '分析行为模式...';

  @override
  String get analyzingStep2 => '识别性格维度...';

  @override
  String get analyzingStep3 => '计算匹配度...';

  @override
  String get analyzingStep4 => '生成性格报告...';

  @override
  String get testResultTitle => '测试结果';

  @override
  String get testResultDualPersonality => '具有双重性格特质';

  @override
  String get testResultDimAnalysis => '维度分析';

  @override
  String get testResultDescription => '性格描述';

  @override
  String get testResultAdvice => '喂养建议';

  @override
  String get testResultRetake => '重新测试';

  @override
  String get testResultPoster => '生成海报';

  @override
  String get healthDashboardTitle => '猫咪健康';

  @override
  String get healthTitle => '健康记录';

  @override
  String get healthPreparing => '正在准备...';

  @override
  String get healthTodayRecords => '今日记录';

  @override
  String get healthSwitchCat => '切换猫咪';

  @override
  String get healthWeightOutOfGoalWarning => '体重已超出档案目标区间，建议近期增加称重和饮食观察。';

  @override
  String get healthWeight => '体重';

  @override
  String get healthWater => '饮水';

  @override
  String get healthDiet => '饮食';

  @override
  String get healthExcretion => '排泄';

  @override
  String get healthNoChange => '暂无变化';

  @override
  String healthWaterTarget(String target) {
    return '目标 ${target}ml';
  }

  @override
  String get healthDietDone => '已完成';

  @override
  String get healthDietInProgress => '进行中';

  @override
  String healthDietMealsUnit(int count) {
    return '/$count次';
  }

  @override
  String healthTimelineWeight(String value) {
    return '称重 ${value}kg';
  }

  @override
  String healthTimelineDiet(String value) {
    return '干饭时刻 ${value}g';
  }

  @override
  String healthTimelineWater(String value) {
    return '饮水 ${value}ml';
  }

  @override
  String get healthTimelinePoop => '排便';

  @override
  String get healthTimelineUrine => '排尿';

  @override
  String get healthTimelineEmpty => '今天还没有记录\n点击右下角 + 开始记录吧';

  @override
  String get healthTimelineDeleteTitle => '确认删除';

  @override
  String get healthTimelineDeleteContent => '确定要删除这条记录吗？';

  @override
  String healthWeightGoalRange(String min, String max) {
    return '目标 $min-${max}kg';
  }

  @override
  String healthWeightGoalMin(String min) {
    return '目标 >= ${min}kg';
  }

  @override
  String healthWeightGoalMax(String max) {
    return '目标 <= ${max}kg';
  }

  @override
  String get healthWeightExceeded => '（当前超出）';

  @override
  String healthWeightAlert(String percent) {
    return '近30天体重变化超过$percent%';
  }

  @override
  String get weightSheetTitle => '⚖️ 体重记录';

  @override
  String weightLastRecord(String weight, String date) {
    return '上次记录：${weight}kg（$date）';
  }

  @override
  String get weightLastRecordToday => '今天';

  @override
  String weightDaysAgo(int days) {
    return '$days天前';
  }

  @override
  String get weightMoodLabel => '称重配合度';

  @override
  String get weightMoodCooperative => '配合';

  @override
  String get weightMoodNeutral => '一般';

  @override
  String get weightMoodResistant => '暴躁';

  @override
  String get weightOutOfGoalTitle => '超出目标区间';

  @override
  String weightOutOfGoalContent(String weight) {
    return '当前体重 ${weight}kg 已超出档案目标，是否继续保存？';
  }

  @override
  String get weightContinueSave => '继续保存';

  @override
  String weightGoalRange(String min, String max) {
    return '目标区间 $min - $max kg';
  }

  @override
  String weightGoalMinLimit(String min) {
    return '目标下限 $min kg';
  }

  @override
  String weightGoalMaxLimit(String max) {
    return '目标上限 $max kg';
  }

  @override
  String get weightGoalExceeded => '（当前超出）';

  @override
  String get dietSheetTitle => '🍚 饮食记录';

  @override
  String dietTodayMeals(int current, int target) {
    return '今日喂食：$current/$target 次（保存后）';
  }

  @override
  String get dietBrandSection => '品牌/种类';

  @override
  String get dietFoodTypeSection => '食物类型';

  @override
  String get dietAmountSection => '进食量 (g)';

  @override
  String get dietSameAsLast => '同前一次记录';

  @override
  String get dietTapToChangeTime => '点击修改时间';

  @override
  String dietConfirmLargeAmount(String amount) {
    return '输入的数值较大（${amount}g），确定吗？';
  }

  @override
  String get waterSheetTitle => '💧 饮水记录';

  @override
  String get waterQuickSmall => '小口';

  @override
  String get waterQuickHalf => '半杯';

  @override
  String get waterQuickOne => '一杯';

  @override
  String get waterQuickFull => '满碗';

  @override
  String waterTodayTarget(String current, String target) {
    return '今日目标：$current/${target}ml';
  }

  @override
  String get excretionSheetTitle => '🐾 排泄记录';

  @override
  String get excretionTabPoop => '粑粑 💩';

  @override
  String get excretionTabUrine => '尿尿 💧';

  @override
  String get excretionPoop1Name => '干燥球状';

  @override
  String get excretionPoop1Desc => '偏硬，注意饮水';

  @override
  String get excretionPoop2Name => '完美香蕉';

  @override
  String get excretionPoop2Desc => '健康标准';

  @override
  String get excretionPoop3Name => '软便无形';

  @override
  String get excretionPoop3Desc => '消化不良';

  @override
  String get excretionPoop4Name => '水样拉稀';

  @override
  String get excretionPoop4Desc => '建议就医';

  @override
  String get excretionUrineSmall => '小团';

  @override
  String get excretionUrineMedium => '中团';

  @override
  String get excretionUrineLarge => '大团';

  @override
  String get excretionAnomaly => '发现异常（血丝/异物）';

  @override
  String get gamesTitle => '互动游戏';

  @override
  String get gamesPageTitle => '玩个游戏';

  @override
  String get gameLaser => '激光点';

  @override
  String get gameMouseHunt => '抓老鼠';

  @override
  String get gameRainbow => '追彩虹';

  @override
  String get gameExitHint => '长按角落3秒退出';

  @override
  String get moreTitle => '更多';

  @override
  String get moreCatProfile => '猫咪档案';

  @override
  String get moreCatProfileSubtitle => '管理你的猫咪信息';

  @override
  String get moreSettings => '设置';

  @override
  String get moreSettingsSubtitle => '应用设置';

  @override
  String get moreAbout => '关于';

  @override
  String get moreAboutSubtitle => '版本信息与反馈';

  @override
  String get moreTheater => '喵剧场';

  @override
  String get moreAI => 'AI 识别';

  @override
  String get settingsPageTitle => '设置';

  @override
  String get settingsGameSection => '游戏设置';

  @override
  String gameSettingsTitle(String gameName) {
    return '$gameName 设置';
  }

  @override
  String get gameSettingsSpeedFrequency => '出现频率';

  @override
  String get gameSettingsSpeedMovement => '移动速度';

  @override
  String get gameSettingsSound => '音效';

  @override
  String get gameSettingsSoundDesc => '游戏过程中播放音效';

  @override
  String get gameSettingsVibration => '震动反馈';

  @override
  String get gameSettingsVibrationDesc => '猫咪触碰目标时震动';

  @override
  String get gameSettingsDescription => '游戏说明';

  @override
  String get gameSettingsStart => '开始游戏';

  @override
  String get posterTitle => '我的猫咪性格报告';

  @override
  String get posterSave => '保存到相册';

  @override
  String get posterSaveComingSoon => '海报保存功能开发中...';

  @override
  String get posterShare => '分享给好友';

  @override
  String get posterShareComingSoon => '分享功能开发中...';

  @override
  String get posterFooter => '猫咪语言 · 16喵格测试';

  @override
  String get settingsLanguageSection => '语言';

  @override
  String get settingsLanguageDesc => '选择应用显示语言';

  @override
  String get settingsLanguageChinese => '中文';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageSystem => '跟随系统';

  @override
  String get aboutPageTitle => '关于';

  @override
  String get aboutAppName => '猫咪说';

  @override
  String get aboutFeedbackEmail => '反馈邮箱';

  @override
  String get aboutPrivacyPolicy => '隐私协议';

  @override
  String get aboutPrivacyPolicySubtitle => '点击查看详细隐私政策';

  @override
  String get aboutCannotOpenLink => '无法打开链接';

  @override
  String get splashTagline => '瞄~瞄~';

  @override
  String get splashAppName => '猫咪说';

  @override
  String get splashSlogan => '懂猫，听猫咪说';

  @override
  String get catProfileTitle => '猫咪档案';

  @override
  String get catProfileEmpty => '还没有猫咪';

  @override
  String get catProfileAddFirst => '点击右下角添加你的第一只猫咪';

  @override
  String get catProfileManage => '管理你的猫咪信息';

  @override
  String get catAdded => '已添加猫咪档案';

  @override
  String get catUpdated => '已更新猫咪档案';

  @override
  String get catDeleted => '已删除猫咪档案';

  @override
  String get catMinimumOne => '至少保留一只猫咪档案';

  @override
  String get catCannotDeleteTitle => '无法删除';

  @override
  String get catCannotDeleteContent => '该猫咪已有健康记录，请先处理历史记录后再删除。';

  @override
  String get catGotIt => '知道了';

  @override
  String get catDeleteTitle => '删除猫咪档案';

  @override
  String catDeleteConfirm(String name) {
    return '确认删除「$name」吗？';
  }

  @override
  String catSwitched(String name) {
    return '已切换到 $name';
  }

  @override
  String catLoadFailed(String error) {
    return '加载失败：$error';
  }

  @override
  String get catAddButton => '添加猫咪';

  @override
  String get catCurrentBadge => '当前';

  @override
  String get catNoBreed => '未设置品种';

  @override
  String get catUnknownAge => '未知年龄';

  @override
  String catAgeMonths(int months) {
    return '$months 个月';
  }

  @override
  String catAgeYears(int years) {
    return '$years 岁';
  }

  @override
  String catAgeYearsMonths(int years, int months) {
    return '$years 岁 $months 个月';
  }

  @override
  String get catSexMale => '公猫';

  @override
  String get catSexFemale => '母猫';

  @override
  String get catSexUnknown => '性别未知';

  @override
  String get catNeutered => '已绝育';

  @override
  String get catNotNeutered => '未绝育';

  @override
  String catWeightGoalRange(String min, String max) {
    return '体重目标 $min-$max kg';
  }

  @override
  String catWeightGoalMin(String min) {
    return '体重目标 ≥ $min kg';
  }

  @override
  String catWeightGoalMax(String max) {
    return '体重目标 ≤ $max kg';
  }

  @override
  String catDailyTargets(String water, int meals) {
    return '目标饮水 $water ml / 日 · 目标喂食 $meals 次 / 日';
  }

  @override
  String get catLoadingTrend => '加载健康趋势中...';

  @override
  String catTrend7DaysWater(String amount) {
    return '近7天日均饮水 ${amount}ml';
  }

  @override
  String catTrendMeals(int count) {
    return '喂食 $count 次';
  }

  @override
  String get catTrendWeightNoData => '体重 无数据';

  @override
  String catTrendWeightChange(String change) {
    return '体重 ${change}kg';
  }

  @override
  String get catFormBasicInfo => '基础信息';

  @override
  String get catFormName => '猫咪名称 *';

  @override
  String get catFormNameHint => '请输入猫咪名称';

  @override
  String get catFormNameRequired => '请输入猫咪名称';

  @override
  String get catFormBreed => '品种';

  @override
  String get catFormBreedHint => '例如：英短、美短';

  @override
  String get catFormSex => '性别';

  @override
  String get catFormSexUnknown => '未知';

  @override
  String get catFormSexMale => '公猫';

  @override
  String get catFormSexFemale => '母猫';

  @override
  String get catFormBirthDate => '出生日期';

  @override
  String get catFormBirthDateNotSet => '未设置';

  @override
  String get catFormNeutered => '已绝育';

  @override
  String get catFormHealthGoals => '健康目标';

  @override
  String get catFormWeightMin => '体重目标下限 (kg)';

  @override
  String get catFormWeightMinHint => '例如：3.5';

  @override
  String get catFormWeightMax => '体重目标上限 (kg)';

  @override
  String get catFormWeightMaxHint => '例如：5.0';

  @override
  String get catFormWaterTarget => '每日饮水目标 (ml)';

  @override
  String get catFormWaterHint => '例如：200';

  @override
  String get catFormMealsTarget => '每日喂食目标 (次)';

  @override
  String get catFormMealsHint => '例如：3';

  @override
  String get catFormSave => '保存修改';

  @override
  String get catFormCreate => '创建档案';

  @override
  String get catFormEditTitle => '编辑猫咪档案';

  @override
  String get catFormNewTitle => '新增猫咪档案';

  @override
  String get catFormInvalidWater => '请填写正确的饮水目标';

  @override
  String get catFormInvalidMeals => '请填写正确的喂食次数（1-20）';

  @override
  String get catFormInvalidWeight => '请填写正确的体重目标（kg）';

  @override
  String get catFormWeightRangeError => '体重区间下限不能大于上限';

  @override
  String get commonSave => '保存';

  @override
  String get commonCancel => '取消';

  @override
  String get commonDelete => '删除';

  @override
  String get commonConfirm => '确认';

  @override
  String get commonEdit => '编辑';

  @override
  String get commonNoCat => '请先添加一只猫咪';

  @override
  String commonSaveFailed(String error) {
    return '保存失败：$error';
  }

  @override
  String get commonTip => '提示';

  @override
  String get commonOk => '确定';
}
