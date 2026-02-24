import 'dart:math';
import 'package:flutter/material.dart';

enum ShelterType { grass, box }

enum CreatureType { bird, snake }

class Shelter {
  Shelter({
    required this.rect,
    required this.type,
  });

  final Rect rect;
  final ShelterType type;
}

/// 捕获时的散开粒子
class PeekParticle {
  PeekParticle({
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

/// 影子藏猫猫游戏逻辑（增强版）
/// - 分数追踪
/// - 捕获粒子效果
/// - 草丛摇动
/// - 更自然的出没节奏
class ShadowPeekLogic {
  ShadowPeekLogic({
    required this.bounds,
    required this.rng,
    this.frequencyFactor = 1.0,
    this.onPeekStarted,
  });

  final VoidCallback? onPeekStarted;
  final Rect bounds;
  final Random rng;
  final double frequencyFactor;

  late List<Shelter> shelters;
  int _currentShelterIndex = 0;
  CreatureType _creatureType = CreatureType.bird;

  // 时隐时现
  bool _creatureVisible = false;
  double _peekProgress = 0;
  double _peekElapsed = 0;
  double _peekAppearDuration = 0;
  double _peekHoldDuration = 0;
  double _peekHideDuration = 0;
  int _peekPhase = 0;
  double _hideElapsed = 0;
  double _hideDuration = 0;
  bool _isPeekingPhase = false;
  bool _isFirstPeek = true;

  // 逃窜
  bool _isEscaping = false;
  double _escapeProgress = 0;
  int _escapeFromIndex = 0;
  int _escapeToIndex = 0;

  // 分数
  int _score = 0;

  // 粒子
  final List<PeekParticle> _particles = [];

  // 草丛摇动：被点击的掩体索引 + 摇动进度
  int _shakingShelterIndex = -1;
  double _shakeProgress = 0;

  // 全局时间（用于环境动画）
  double _globalTime = 0;

  bool get creatureVisible => _creatureVisible;
  CreatureType get creatureType => _creatureType;
  Rect get creaturePeekRect => _getCreaturePeekRect();
  double get creaturePeekProgress => _peekProgress;
  bool get isEscaping => _isEscaping;
  int get escapeFromIndex => _escapeFromIndex;
  int get escapeToIndex => _escapeToIndex;
  Rect get escapeFrom => shelters[_escapeFromIndex].rect;
  Rect get escapeTo => shelters[_escapeToIndex].rect;
  double get escapeProgress => _escapeProgress;
  int get score => _score;
  List<PeekParticle> get particles => _particles;
  int get shakingShelterIndex => _shakingShelterIndex;
  double get shakeProgress => _shakeProgress;
  double get globalTime => _globalTime;
  int get currentShelterIndex => _currentShelterIndex;

  void reset() {
    _initShelters();
    _currentShelterIndex = 0;
    _creatureType = rng.nextBool() ? CreatureType.bird : CreatureType.snake;
    _creatureVisible = false;
    _peekProgress = 0;
    _peekElapsed = 0;
    _isPeekingPhase = false;
    _isEscaping = false;
    _isFirstPeek = true;
    _score = 0;
    _particles.clear();
    _shakingShelterIndex = -1;
    _globalTime = 0;
    _scheduleNextPeek();
  }

  void _initShelters() {
    final w = bounds.width;
    final h = bounds.height;
    shelters = [
      // 左下草丛
      Shelter(
        rect: Rect.fromLTWH(w * 0.03, h * 0.58, w * 0.38, h * 0.28),
        type: ShelterType.grass,
      ),
      // 右下纸箱
      Shelter(
        rect: Rect.fromLTWH(w * 0.55, h * 0.62, w * 0.42, h * 0.26),
        type: ShelterType.box,
      ),
      // 中上草丛
      Shelter(
        rect: Rect.fromLTWH(w * 0.22, h * 0.18, w * 0.52, h * 0.22),
        type: ShelterType.grass,
      ),
      // 左上纸箱
      Shelter(
        rect: Rect.fromLTWH(w * 0.03, h * 0.22, w * 0.28, h * 0.20),
        type: ShelterType.box,
      ),
    ];
  }

  void _scheduleNextPeek() {
    _hideElapsed = 0;
    _hideDuration = _isFirstPeek
        ? (300 + rng.nextDouble() * 400) / frequencyFactor
        : (1000 + rng.nextDouble() * 1500) / frequencyFactor;
    _isPeekingPhase = false;
  }

  /// 点击是否命中当前生物所在的掩体
  bool tapShelter(Offset point) {
    if (_isEscaping) return false;
    if (!_creatureVisible) return false;

    final shelter = shelters[_currentShelterIndex];
    if (shelter.rect.contains(point)) {
      _score++;
      _triggerEscape();
      return true;
    }
    return false;
  }

  void _triggerEscape() {
    _creatureVisible = false;
    _isEscaping = true;
    _escapeProgress = 0;
    _escapeFromIndex = _currentShelterIndex;

    // 触发草丛/纸箱摇动
    _shakingShelterIndex = _currentShelterIndex;
    _shakeProgress = 0;

    // 生成粒子
    _spawnParticles();

    // 确保逃往不同的掩体
    final others = List.generate(shelters.length, (i) => i)
        .where((i) => i != _currentShelterIndex)
        .toList();
    _escapeToIndex = others[rng.nextInt(others.length)];
    _currentShelterIndex = _escapeToIndex;
    _creatureType = rng.nextBool() ? CreatureType.bird : CreatureType.snake;
  }

  void _spawnParticles() {
    _particles.clear();
    final shelter = shelters[_escapeFromIndex];
    final cx = shelter.rect.center.dx;
    final cy = shelter.rect.center.dy;

    // 根据掩体类型使用不同颜色粒子
    final colors = shelter.type == ShelterType.grass
        ? [const Color(0xFF4CAF50), const Color(0xFF8BC34A), const Color(0xFFCDDC39)]
        : [const Color(0xFF8D6E63), const Color(0xFFBCAAA4), const Color(0xFFD7CCC8)];

    for (int i = 0; i < 18; i++) {
      final angle = (i / 18) * 2 * pi + rng.nextDouble() * 0.5;
      final speed = 1.5 + rng.nextDouble() * 3;
      _particles.add(PeekParticle(
        x: cx + (rng.nextDouble() - 0.5) * 20,
        y: cy + (rng.nextDouble() - 0.5) * 20,
        vx: cos(angle) * speed,
        vy: sin(angle) * speed - 1.5, // 向上偏移
        color: colors[rng.nextInt(colors.length)],
        size: 3 + rng.nextDouble() * 5,
        life: 1.0,
      ));
    }
  }

  Rect _getCreaturePeekRect() {
    final s = shelters[_currentShelterIndex];
    return Rect.fromLTWH(
      s.rect.left + s.rect.width * 0.2,
      s.rect.top + s.rect.height * 0.15,
      s.rect.width * 0.6,
      s.rect.height * 0.6,
    );
  }

  /// 返回 true 表示需要重绘
  bool update(double deltaMs) {
    _globalTime += deltaMs;
    bool needsRepaint = false;

    // 更新粒子
    if (_particles.isNotEmpty) {
      for (final p in _particles) {
        p.x += p.vx * (deltaMs / 16);
        p.y += p.vy * (deltaMs / 16);
        p.life -= deltaMs / 600;
      }
      _particles.removeWhere((p) => p.life <= 0);
      needsRepaint = true;
    }

    // 更新掩体摇动
    if (_shakingShelterIndex >= 0) {
      _shakeProgress += deltaMs / 500;
      if (_shakeProgress >= 1.0) {
        _shakingShelterIndex = -1;
        _shakeProgress = 0;
      }
      needsRepaint = true;
    }

    // 环境动画（草丛微动）始终需要重绘
    needsRepaint = true;

    if (_isEscaping) {
      _escapeProgress += deltaMs / 500;
      if (_escapeProgress >= 1) {
        _isEscaping = false;
        _scheduleNextPeek();
      }
      return true;
    }

    if (_isPeekingPhase) {
      _peekElapsed += deltaMs;
      if (_peekPhase == 0) {
        _peekProgress = (_peekElapsed / _peekAppearDuration).clamp(0.0, 1.0);
        if (_peekElapsed >= _peekAppearDuration) {
          _peekPhase = 1;
          _peekElapsed = 0;
        }
      } else if (_peekPhase == 1) {
        _peekProgress = 1.0;
        if (_peekElapsed >= _peekHoldDuration) {
          _peekPhase = 2;
          _peekElapsed = 0;
        }
      } else {
        _peekProgress =
            1.0 - (_peekElapsed / _peekHideDuration).clamp(0.0, 1.0);
        if (_peekElapsed >= _peekHideDuration) {
          _creatureVisible = false;
          _peekProgress = 0;
          _peekPhase = 0;
          _scheduleNextPeek();
        }
      }
      return true;
    }

    _hideElapsed += deltaMs;
    if (_hideElapsed >= _hideDuration) {
      _startPeek();
      _isFirstPeek = false;
      return true;
    }
    return needsRepaint;
  }

  void _startPeek() {
    onPeekStarted?.call();
    _isPeekingPhase = true;
    _creatureVisible = true;
    _peekElapsed = 0;
    _peekPhase = 0;
    _peekAppearDuration = 300 + rng.nextDouble() * 300;
    _peekHoldDuration = 800 + rng.nextDouble() * 1000;
    _peekHideDuration = 300 + rng.nextDouble() * 200;
    _peekProgress = 0;
  }
}
