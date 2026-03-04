import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/l10n/app_localizations.dart';

enum GameMode {
  laser(
    id: 'laser',
    icon: Icons.flashlight_on,
    previewIcon: Icons.adjust,
    color: AppColors.gameLaser,
    accentColor: AppColors.gameLaserGlow,
    backgroundColor: AppColors.gameBackground,
    cardGradientStart: Color(0xFF2D0A0A),
    cardGradientEnd: Color(0xFF1A0000),
    difficultyLevel: 1,
    emoji: '🔴',
  ),
  shadowPeek(
    id: 'shadow_peek',
    icon: Icons.grass,
    previewIcon: Icons.pest_control_rodent,
    color: Color(0xFF4CAF50),
    accentColor: Color(0xFF8BC34A),
    backgroundColor: Color(0xFF2E7D32),
    cardGradientStart: Color(0xFF1B5E20),
    cardGradientEnd: Color(0xFF2E7D32),
    difficultyLevel: 1,
    emoji: '🌿',
  ),
  catchMouse(
    id: 'catch_mouse',
    icon: Icons.cruelty_free,
    previewIcon: Icons.pest_control,
    color: AppColors.gameMouse,
    accentColor: AppColors.gameMouseAccent,
    backgroundColor: AppColors.gameBackground,
    cardGradientStart: Color(0xFF2D2200),
    cardGradientEnd: Color(0xFF1A1400),
    difficultyLevel: 2,
    emoji: '🐭',
  ),
  rainbow(
    id: 'rainbow',
    icon: Icons.auto_awesome,
    previewIcon: Icons.blur_on,
    color: AppColors.gameRainbow,
    accentColor: AppColors.gameRainbowAccent,
    backgroundColor: Color(0xFF1A0033),
    cardGradientStart: Color(0xFF1A0033),
    cardGradientEnd: Color(0xFF0D001A),
    difficultyLevel: 1,
    emoji: '🌈',
  ),
  holeAmbush(
    id: 'hole_ambush',
    icon: Icons.grid_view_rounded,
    previewIcon: Icons.ads_click,
    color: Color(0xFFFF8A65),
    accentColor: Color(0xFFFFB74D),
    backgroundColor: Color(0xFF2B1C13),
    cardGradientStart: Color(0xFF4E342E),
    cardGradientEnd: Color(0xFF2B1C13),
    difficultyLevel: 2,
    emoji: '🕳️',
  ),
  featherWand(
    id: 'feather_wand',
    icon: Icons.air,
    previewIcon: Icons.waving_hand_rounded,
    color: Color(0xFF26A69A),
    accentColor: Color(0xFF80CBC4),
    backgroundColor: Color(0xFF0E3A3A),
    cardGradientStart: Color(0xFF134E4A),
    cardGradientEnd: Color(0xFF0E3A3A),
    difficultyLevel: 2,
    emoji: '🪶',
  );

  final String id;
  final IconData icon;
  final IconData previewIcon;
  final Color color;
  final Color accentColor;
  final Color backgroundColor;
  final Color cardGradientStart;
  final Color cardGradientEnd;
  final int difficultyLevel;
  final String emoji;

  const GameMode({
    required this.id,
    required this.icon,
    required this.previewIcon,
    required this.color,
    required this.accentColor,
    required this.backgroundColor,
    required this.cardGradientStart,
    required this.cardGradientEnd,
    required this.difficultyLevel,
    required this.emoji,
  });
}

extension GameModeLocalizedText on GameMode {
  String title(AppLocalizations l10n) {
    switch (this) {
      case GameMode.laser:
        return l10n.gameLaser;
      case GameMode.shadowPeek:
        return l10n.gameShadowPeek;
      case GameMode.catchMouse:
        return l10n.gameMouseHunt;
      case GameMode.rainbow:
        return l10n.gameRainbow;
      case GameMode.holeAmbush:
        return '洞洞伏击';
      case GameMode.featherWand:
        return '羽毛逗杆';
    }
  }

  String subtitle(AppLocalizations l10n) {
    switch (this) {
      case GameMode.laser:
        return l10n.gameLaserSubtitle;
      case GameMode.shadowPeek:
        return l10n.gameShadowPeekSubtitle;
      case GameMode.catchMouse:
        return l10n.gameCatchMouseSubtitle;
      case GameMode.rainbow:
        return l10n.gameRainbowSubtitle;
      case GameMode.holeAmbush:
        return '猎物会随机从洞口探头';
      case GameMode.featherWand:
        return '模拟逗猫棒的飘动轨迹';
    }
  }

  String description(AppLocalizations l10n) {
    switch (this) {
      case GameMode.laser:
        return l10n.gameLaserDescription;
      case GameMode.shadowPeek:
        return l10n.gameShadowPeekDescription;
      case GameMode.catchMouse:
        return l10n.gameCatchMouseDescription;
      case GameMode.rainbow:
        return l10n.gameRainbowDescription;
      case GameMode.holeAmbush:
        return '猎物会在不同洞口快速探头，拍到即得分，适合高互动节奏。';
      case GameMode.featherWand:
        return '羽毛会像逗猫棒一样在屏幕上游走，适合猫咪追击、扑抓和拍打。';
    }
  }

  String difficulty(AppLocalizations l10n) {
    switch (difficultyLevel) {
      case 1:
        return l10n.gameDifficultyEasy;
      case 2:
        return l10n.gameDifficultyMedium;
      default:
        return l10n.gameDifficultyHard;
    }
  }

  String tips(AppLocalizations l10n) {
    switch (this) {
      case GameMode.laser:
        return l10n.gameLaserTips;
      case GameMode.shadowPeek:
        return l10n.gameShadowPeekTips;
      case GameMode.catchMouse:
        return l10n.gameCatchMouseTips;
      case GameMode.rainbow:
        return l10n.gameRainbowTips;
      case GameMode.holeAmbush:
        return '盯住洞口，看到猎物露头时快速拍击';
      case GameMode.featherWand:
        return '观察羽毛移动方向，提前拦截更容易命中';
    }
  }
}
