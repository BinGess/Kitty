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
  });

  double x;
  double y;
  final double vx;
  final double vy;
  final Color color;
  final double size;
  double life; // 1 -> 0
}

/// 捕鼠/捕鱼大战游戏逻辑
class CatchMouseLogic {
  CatchMouseLogic({
    required this.bounds,
    required this.rng,
    this.speedFactor = 1.0,
  });

  final Rect bounds;
  final Random rng;
  final double speedFactor;

  static const double _creatureRadius = 28;
  static const double _respawnDelayMs = 3000;

  // 生物
  CatchCreatureType _creatureType = CatchCreatureType.mouse;
  double _x = 0;
  double _y = 0;
  double _vx = 0;
  double _vy = 0;
  bool _visible = false;

  // 捕获
  bool _isCaught = false;
  double _caughtElapsed = 0;
  final List<Particle> _particles = [];

  // 刷新等待
  bool _isRespawning = false;
  double _respawnElapsed = 0;

  CatchCreatureType get creatureType => _creatureType;
  double get x => _x;
  double get y => _y;
  bool get visible => _visible;
  bool get isCaught => _isCaught;
  bool get isRespawning => _isRespawning;
  List<Particle> get particles => _particles;
  double get creatureRadius => _creatureRadius;

  void reset() {
    _visible = false;
    _isCaught = false;
    _isRespawning = false;
    _particles.clear();
    _respawnElapsed = 0;
    _spawnCreature();
  }

  void _spawnCreature() {
    _creatureType = rng.nextBool() ? CatchCreatureType.mouse : CatchCreatureType.fish;
    _x = _creatureRadius + rng.nextDouble() * (bounds.width - _creatureRadius * 2);
    _y = _creatureRadius + rng.nextDouble() * (bounds.height - _creatureRadius * 2);
    final angle = rng.nextDouble() * 2 * pi;
    final speed = (80 + rng.nextDouble() * 120) * speedFactor / 60;
    _vx = cos(angle) * speed;
    _vy = sin(angle) * speed;
    _visible = true;
    _isRespawning = false;
  }

  /// 点击是否命中生物
  bool tapCreature(Offset point) {
    if (!_visible || _isCaught || _isRespawning) return false;

    final dx = point.dx - _x;
    final dy = point.dy - _y;
    if (dx * dx + dy * dy <= _creatureRadius * _creatureRadius) {
      _triggerCatch();
      return true;
    }
    return false;
  }

  void _triggerCatch() {
    _isCaught = true;
    _caughtElapsed = 0;
    _visible = false;

    // 生成散开粒子
    _particles.clear();
    final color = _creatureType == CatchCreatureType.mouse
        ? const Color(0xFF8D6E63)
        : const Color(0xFF4FC3F7);
    for (int i = 0; i < 28; i++) {
      final angle = (i / 28) * 2 * pi + rng.nextDouble() * 0.3;
      final speed = 2 + rng.nextDouble() * 4;
      _particles.add(Particle(
        x: _x,
        y: _y,
        vx: cos(angle) * speed,
        vy: sin(angle) * speed,
        color: color,
        size: 4 + rng.nextDouble() * 6,
        life: 1.0,
      ));
    }
  }

  /// 返回 true 表示需要重绘
  bool update(double deltaMs) {
    if (_isCaught) {
      _caughtElapsed += deltaMs;
      for (final p in _particles) {
        p.x += p.vx * (deltaMs / 16);
        p.y += p.vy * (deltaMs / 16);
        p.life = (1.0 - _caughtElapsed / 500).clamp(0.0, 1.0);
      }
      _particles.removeWhere((p) => p.life <= 0);
      if (_caughtElapsed >= 500) {
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
      if (rng.nextDouble() < 0.002) {
        final angle = atan2(_vy, _vx) + (rng.nextDouble() - 0.5) * pi * 0.5;
        final speed = sqrt(_vx * _vx + _vy * _vy);
        _vx = cos(angle) * speed;
        _vy = sin(angle) * speed;
      }
      return true;
    }

    return false;
  }
}
