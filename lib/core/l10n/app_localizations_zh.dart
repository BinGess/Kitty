// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '猫咪语言';

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
  String get soundsTitle => '猫鸣模拟器';

  @override
  String get soundCategoryCalling => '呼唤';

  @override
  String get soundCategoryEmotion => '情感';

  @override
  String get soundCategoryEnvironment => '环境';

  @override
  String get testTitle => '16喵格测试';

  @override
  String get testBasicMode => '基础版 (12题)';

  @override
  String get testAdvancedMode => '进阶版 (24题)';

  @override
  String get testSubtitle => '测测你家猫的隐藏性格';

  @override
  String get testAnalyzing => '正在分析猫咪性格...';

  @override
  String testProgressLabel(int current, int total) {
    return '第$current题 / 共$total题';
  }

  @override
  String get healthTitle => '健康记录';

  @override
  String get healthWeight => '体重';

  @override
  String get healthWater => '饮水';

  @override
  String get healthDiet => '饮食';

  @override
  String get healthExcretion => '排泄';

  @override
  String healthWeightAlert(String percent) {
    return '近30天体重变化超过$percent%';
  }

  @override
  String get gamesTitle => '互动游戏';

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
  String get moreTheater => '喵剧场';

  @override
  String get moreAI => 'AI 识别';

  @override
  String get moreSettings => '设置';

  @override
  String get catProfileEmpty => '还没有猫咪';

  @override
  String get catProfileAddFirst => '点击添加你的第一只猫咪';

  @override
  String get catProfileManage => '管理你的猫咪信息';

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
}
