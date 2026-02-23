/// 游戏通用配置，由设置面板传入各游戏
class GameConfig {
  /// 移动速度 0.0~1.0，影响轨迹时长
  final double speed;

  /// 是否开启音效
  final bool soundEnabled;

  /// 是否开启震动反馈
  final bool vibrationEnabled;

  const GameConfig({
    this.speed = 0.5,
    this.soundEnabled = false,
    this.vibrationEnabled = true,
  });

  GameConfig copyWith({
    double? speed,
    bool? soundEnabled,
    bool? vibrationEnabled,
  }) {
    return GameConfig(
      speed: speed ?? this.speed,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
    );
  }

  /// 根据 speed 计算移动时长系数，0.5 为基准 1.0
  /// speed 越大，移动越快，时长越短
  double get movementDurationFactor => 2.0 - speed;

  /// 根据 speed 计算暂停时长系数
  double get pauseDurationFactor => 1.5 - speed * 0.5;
}
