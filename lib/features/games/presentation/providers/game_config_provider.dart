import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/game_config.dart';

final gameConfigProvider =
    NotifierProvider<GameConfigNotifier, GameConfig>(GameConfigNotifier.new);

class GameConfigNotifier extends Notifier<GameConfig> {
  @override
  GameConfig build() => const GameConfig();

  void setSpeed(double speed) => state = state.copyWith(speed: speed);
  void setSoundEnabled(bool v) => state = state.copyWith(soundEnabled: v);
  void setVibrationEnabled(bool v) =>
      state = state.copyWith(vibrationEnabled: v);
  void update(GameConfig config) => state = config;
}
