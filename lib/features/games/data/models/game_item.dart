import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

enum GameMode {
  laser(
    id: 'laser',
    title: '激光逗猫',
    subtitle: '经典红点追逐游戏',
    description: '模拟激光笔在屏幕上移动，吸引猫咪追逐。红色高亮光点在黑色背景上缓慢移动，偶尔加速或暂停。',
    icon: Icons.flashlight_on,
    previewIcon: Icons.adjust,
    color: AppColors.gameLaser,
    accentColor: AppColors.gameLaserGlow,
    backgroundColor: AppColors.gameBackground,
    cardGradientStart: Color(0xFF2D0A0A),
    cardGradientEnd: Color(0xFF1A0000),
    difficulty: '简单',
    difficultyLevel: 1,
    tips: '将手机平放在地上，让猫咪自由追逐红点',
    emoji: '🔴',
  ),
  shadowPeek(
    id: 'shadow_peek',
    title: '影子藏猫猫',
    subtitle: '草丛纸箱里的惊喜',
    description: '屏幕主体为草丛或纸箱，小鸟、小蛇偶尔露出一部分并伴随轻微响声。点击遮挡物，物体会迅速逃窜至下一个掩体。',
    icon: Icons.grass,
    previewIcon: Icons.pest_control_rodent,
    color: Color(0xFF4CAF50),
    accentColor: Color(0xFF8BC34A),
    backgroundColor: Color(0xFF2E7D32),
    cardGradientStart: Color(0xFF1B5E20),
    cardGradientEnd: Color(0xFF2E7D32),
    difficulty: '简单',
    difficultyLevel: 1,
    tips: '点击草丛或纸箱，看看谁在躲猫猫',
    emoji: '🌿',
  ),
  catchMouse(
    id: 'catch_mouse',
    title: '捕鼠/捕鱼大战',
    subtitle: '拟真老鼠或鱼游走，拍击即捕获',
    description: '拟真的老鼠或鱼在屏幕游走，猫咪拍击即为捕获。击中时播放吱吱/水花声，物体消失并产生散开粒子特效，3秒后随机刷新。',
    icon: Icons.cruelty_free,
    previewIcon: Icons.pest_control,
    color: AppColors.gameMouse,
    accentColor: AppColors.gameMouseAccent,
    backgroundColor: AppColors.gameBackground,
    cardGradientStart: Color(0xFF2D2200),
    cardGradientEnd: Color(0xFF1A1400),
    difficulty: '中等',
    difficultyLevel: 2,
    tips: '拍击老鼠或鱼即可捕获，享受吱吱声与粒子特效',
    emoji: '🐭',
  ),
  rainbow(
    id: 'rainbow',
    title: '彩虹追逐',
    subtitle: '缤纷色彩流动效果',
    description: '屏幕上出现缓慢移动的彩虹光带，配合柔和的颜色过渡，适合长时间安抚或吸引注意力。',
    icon: Icons.auto_awesome,
    previewIcon: Icons.blur_on,
    color: AppColors.gameRainbow,
    accentColor: AppColors.gameRainbowAccent,
    backgroundColor: Color(0xFF1A0033),
    cardGradientStart: Color(0xFF1A0033),
    cardGradientEnd: Color(0xFF0D001A),
    difficulty: '简单',
    difficultyLevel: 1,
    tips: '适合安静时刻，帮助猫咪放松心情',
    emoji: '🌈',
  );

  final String id;
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final IconData previewIcon;
  final Color color;
  final Color accentColor;
  final Color backgroundColor;
  final Color cardGradientStart;
  final Color cardGradientEnd;
  final String difficulty;
  final int difficultyLevel;
  final String tips;
  final String emoji;

  const GameMode({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.previewIcon,
    required this.color,
    required this.accentColor,
    required this.backgroundColor,
    required this.cardGradientStart,
    required this.cardGradientEnd,
    required this.difficulty,
    required this.difficultyLevel,
    required this.tips,
    required this.emoji,
  });
}
