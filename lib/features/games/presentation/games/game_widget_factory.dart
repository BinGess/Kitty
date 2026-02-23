import 'package:flutter/material.dart';
import '../../data/models/game_item.dart';
import '../../domain/game_config.dart';
import 'catch_mouse/catch_mouse_game.dart';
import 'laser/laser_dot_game.dart';
import 'shadow_peek/shadow_peek_game.dart';

/// 根据 gameId 创建对应的游戏 Widget
Widget buildGameWidget({
  required GameMode mode,
  required GameConfig config,
}) {
  switch (mode) {
    case GameMode.laser:
      return LaserDotGame(config: config);
    case GameMode.shadowPeek:
      return ShadowPeekGame(config: config);
    case GameMode.catchMouse:
      return CatchMouseGame(config: config);
    case GameMode.rainbow:
      return _GamePlaceholder(mode: mode);
  }
}

/// 未实现游戏的占位
class _GamePlaceholder extends StatelessWidget {
  final GameMode mode;

  const _GamePlaceholder({required this.mode});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(mode.icon, size: 48, color: mode.color),
          const SizedBox(height: 16),
          Text(
            '${mode.title} 开发中...',
            style: TextStyle(color: mode.color, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
