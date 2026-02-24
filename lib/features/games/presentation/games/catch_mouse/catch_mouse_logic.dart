import 'dart:math';
import 'package:flutter/material.dart';

enum CatchCreatureType { mouse, fish }

/// 粒子：用于捕获时的散开特效
class Particle {
  Particle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.color,
    required this.size,
    required this.life,
    this.shape = ParticleShape.circle,
    this.rotation = 0,
  });

  double x;
  double y;
  final double vx;
  final double vy;
  final Color color;
  final double size;
  double life; // 1 -> 0
  final ParticleShape shape;
  double rotation;
}

enum ParticleShape { circle, star, sparkle }

/// 捕鼠/捕鱼大战游戏逻辑（增强版）
/// - 分数追踪
/// - 移动轨迹历史（拖尾）
/// - 更丰富的粒子（星星、火花）
/// - 移动方向感知
/// - 生物大小随机化
class CatchMouseLogic {
  CatchMouseLogic({
    required this.bounds,
    required this.rng,
    this.speedFactor = 1.0,
  });

  final Rect bounds;
  final Random rng;
  final double speedFactor;

  static const double _creatureRadius = 30;
  static const double _respawnDelayMs = 2500;
  static const int _maxTrailLength = 12;

  // 生物
  CatchCreatureType _creatureType = CatchCreatureType.mouse;
  double _x = 0;
  double _y = 0;
  double _vx = 0;
  double _vy = 0;
  bool _visible = false;

  // 移动轨迹
  final List<Offset> _trail = [];
  int _trailCounter = 0;

  // 捕获
  bool _isCaught = false;
  double _caughtElapsed = 0;
  final List<Particle> _particles = [];

  // 刷新等待
  bool _isRespawning = false;
  double _respawnElapsed = 0;

  // 分数
  int _score = 0;

  // 全局时间
  double _globalTime = 0;

  // 移动方向角度
  double _moveAngle = 0;

  CatchCreatureType get creatureType => _creatureType;
  double get x => _x;
  double get y => _y;
  bool get visible => _visible;
  bool get isCaught => _isCaught;
  bool get isRespawning => _isRespawning;
  List<Particle> get particles => _particles;
  double get creatureRadius => _creatureRadius;
  int get score => _score;
  List<Offset> get trail => _trail;
  double get globalTime => _globalTime;
  double get moveAngle => _moveAngle;
  double get respawnProgress =>
      _isRespawning ? (_respawnElapsed / _respawnDelayMs).clamp(0.0, 1.0) : 0;

  void reset() {
    _visible = false;
    _isCaught = false;
    _isRespawning = false;
    _particles.clear();
    _trail.clear();
    _respawnElapsed = 0;
    _score = 0;
    _globalTime = 0;
    _spawnCreature();
  }

  void _spawnCreature() {
    _creatureType =
        rng.nextBool() ? CatchCreatureType.mouse : CatchCreatureType.fish;
    _x = _creatureRadius +
        rng.nextDouble() * (bounds.width - _creatureRadius * 2);
    _y = _creatureRadius +
        rng.nextDouble() * (bounds.height - _creatureRadius * 2);
    final angle = rng.nextDouble() * 2 * pi;
    final speed = (80 + rng.nextDouble() * 120) * speedFactor / 60;
    _vx = cos(angle) * speed;
    _vy = sin(angle) * speed;
    _moveAngle = angle;
    _visible = true;
    _isRespawning = false;
    _trail.clear();
  }

  /// 点击是否命中生物
  bool tapCreature(Offset point) {
    if (!_visible || _isCaught || _isRespawning) return false;

    final dx = point.dx - _x;
    final dy = point.dy - _y;
    // 适当放大命中区域
    final hitRadius = _creatureRadius * 1.5;
    if (dx * dx + dy * dy <= hitRadius * hitRadius) {
      _score++;
      _triggerCatch();
      return true;
    }
    return false;
  }

  void _triggerCatch() {
    _isCaught = true;
    _caughtElapsed = 0;
    _visible = false;

    // 生成多层粒子
    _particles.clear();
    final baseColor = _creatureType == CatchCreatureType.mouse
        ? const Color(0xFF8D6E63)
        : const Color(0xFF4FC3F7);
    final accentColor = _creatureType == CatchCreatureType.mouse
        ? const Color(0xFFFFCC80)
        : const Color(0xFF81D4FA);

    // 外圈散开粒子
    for (int i = 0; i < 20; i++) {
      final angle = (i / 20) * 2 * pi + rng.nextDouble() * 0.3;
      final speed = 2.5 + rng.nextDouble() * 4;
      _particles.add(Particle(
        x: _x,
        y: _y,
        vx: cos(angle) * speed,
        vy: sin(angle) * speed,
        color: i % 2 == 0 ? baseColor : accentColor,
        size: 4 + rng.nextDouble() * 6,
        life: 1.0,
      ));
    }

    // 星星粒子
    for (int i = 0; i < 6; i++) {
      final angle = (i / 6) * 2 * pi + rng.nextDouble() * 0.5;
      final speed = 1.5 + rng.nextDouble() * 2.5;
      _particles.add(Particle(
        x: _x,
        y: _y,
        vx: cos(angle) * speed,
        vy: sin(angle) * speed - 1.5,
        color: const Color(0xFFFFD700),
        size: 6 + rng.nextDouble() * 4,
        life: 1.0,
        shape: ParticleShape.star,
      ));
    }

    // 火花粒子
    for (int i = 0; i < 10; i++) {
      final angle = rng.nextDouble() * 2 * pi;
      final speed = 3 + rng.nextDouble() * 5;
      _particles.add(Particle(
        x: _x + (rng.nextDouble() - 0.5) * 10,
        y: _y + (rng.nextDouble() - 0.5) * 10,
        vx: cos(angle) * speed,
        vy: sin(angle) * speed,
        color: Colors.white.withValues(alpha: 0.9),
        size: 2 + rng.nextDouble() * 3,
        life: 1.0,
        shape: ParticleShape.sparkle,
      ));
    }
  }

  /// 返回 true 表示需要重绘
  bool update(double deltaMs) {
    _globalTime += deltaMs;

    if (_isCaught) {
      _caughtElapsed += deltaMs;
      for (final p in _particles) {
        p.x += p.vx * (deltaMs / 16);
        p.y += p.vy * (deltaMs / 16);
        p.life = (1.0 - _caughtElapsed / 600).clamp(0.0, 1.0);
        if (p.shape == ParticleShape.star) {
          p.rotation += deltaMs / 200;
        }
      }
      _particles.removeWhere((p) => p.life <= 0);
      if (_caughtElapsed >= 600) {
        _isCaught = false;
        _particles.clear();
        _isRespawning = true;
        _respawnElapsed = 0;
      }
      return true;
    }

    if (_isRespawning) {
      _respawnElapsed += deltaMs;
      if (_respawnElapsed >= _respawnDelayMs) {
        _spawnCreature();
      }
      return true;
    }

    if (_visible) {
      _x += _vx * (deltaMs / 16);
      _y += _vy * (deltaMs / 16);

      // 更新移动方向
      _moveAngle = atan2(_vy, _vx);

      // 记录轨迹
      _trailCounter++;
      if (_trailCounter % 3 == 0) {
        _trail.add(Offset(_x, _y));
        if (_trail.length > _maxTrailLength) {
          _trail.removeAt(0);
        }
      }

      // 边界反弹
      if (_x - _creatureRadius < 0) {
        _x = _creatureRadius;
        _vx = -_vx;
      }
      if (_x + _creatureRadius > bounds.width) {
        _x = bounds.width - _creatureRadius;
        _vx = -_vx;
      }
      if (_y - _creatureRadius < 0) {
        _y = _creatureRadius;
        _vy = -_vy;
      }
      if (_y + _creatureRadius > bounds.height) {
        _y = bounds.height - _creatureRadius;
        _vy = -_vy;
      }

      // 偶尔随机转向
      if (rng.nextDouble() < 0.003) {
        final angle =
            atan2(_vy, _vx) + (rng.nextDouble() - 0.5) * pi * 0.6;
        final speed = sqrt(_vx * _vx + _vy * _vy);
        _vx = cos(angle) * speed;
        _vy = sin(angle) * speed;
      }

      // 偶尔加速/减速
      if (rng.nextDouble() < 0.001) {
        final factor = 0.7 + rng.nextDouble() * 0.6;
        _vx *= factor;
        _vy *= factor;
      }

      return true;
    }

    return false;
  }
}
