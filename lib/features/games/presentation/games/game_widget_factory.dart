import 'package:flutter/material.dart';
import '../../data/models/game_item.dart';
import '../../domain/game_config.dart';
import 'catch_mouse/catch_mouse_game.dart';
import 'feather_wand/feather_wand_game.dart';
import 'hole_ambush/hole_ambush_game.dart';
import 'laser/laser_dot_game.dart';
import 'rainbow/rainbow_chase_game.dart';
import 'shadow_peek/shadow_peek_game.dart';

/// 根据 gameId 创建对应的游戏 Widget
Widget buildGameWidget({required GameMode mode, required GameConfig config}) {
  switch (mode) {
    case GameMode.laser:
      return LaserDotGame(config: config);
    case GameMode.shadowPeek:
      return ShadowPeekGame(config: config);
    case GameMode.catchMouse:
      return CatchMouseGame(config: config);
    case GameMode.rainbow:
      return RainbowChaseGame(config: config);
    case GameMode.holeAmbush:
      return HoleAmbushGame(config: config);
    case GameMode.featherWand:
      return FeatherWandGame(config: config);
  }
}
