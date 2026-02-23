import 'package:flutter/material.dart';

abstract class AppColors {
  // Brand palette
  static const Color background = Color(0xFFFFF9F2);
  static const Color primary = Color(0xFFFFB266);
  static const Color primaryLight = Color(0xFFFFD4A8);
  static const Color primaryDark = Color(0xFFE6994D);

  // Semantic
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFFFF3E6);
  static const Color onBackground = Color(0xFF3D2C1E);
  static const Color onSurface = Color(0xFF5C4033);
  static const Color textSecondary = Color(0xFFA68B6B);
  static const Color divider = Color(0xFFEEE0D0);

  // Status
  static const Color success = Color(0xFF7BC67E);
  static const Color warning = Color(0xFFFFD666);
  static const Color error = Color(0xFFFF8A80);
  static const Color info = Color(0xFF81D4FA);

  // Game high-contrast (cat vision optimized)
  static const Color gameLaser = Color(0xFFFF0000);
  static const Color gameLaserGlow = Color(0xFFFF4444);
  static const Color gameMouse = Color(0xFFFFD700);
  static const Color gameMouseAccent = Color(0xFFFFA726);
  static const Color gameRainbow = Color(0xFF9C27B0);
  static const Color gameRainbowAccent = Color(0xFF7B1FA2);
  static const Color gameBackground = Color(0xFF000000);
}
