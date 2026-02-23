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

/// 影子藏猫猫游戏逻辑
class ShadowPeekLogic {
  ShadowPeekLogic({
    required this.bounds,
    required this.rng,
    this.frequencyFactor = 1.0,
    this.onPeekStarted,
  });

  /// 生物露出时触发轻微响声
  final VoidCallback? onPeekStarted;

  final Rect bounds;
  final Random rng;
  final double frequencyFactor;

  late List<Shelter> shelters;
  int _currentShelterIndex = 0;
  CreatureType _creatureType = CreatureType.bird;

  // 时隐时现：出现 -> 停留 -> 消失
  bool _creatureVisible = false;
  double _peekProgress = 0; // 0=完全隐藏, 1=完全露出
  double _peekElapsed = 0;
  double _peekAppearDuration = 0;
  double _peekHoldDuration = 0;
  double _peekHideDuration = 0;
  int _peekPhase = 0; // 0=出现中, 1=停留, 2=消失中
  double _hideElapsed = 0;
  double _hideDuration = 0;
  bool _isPeekingPhase = false;
  bool _isFirstPeek = true;

  // 逃窜
  bool _isEscaping = false;
  double _escapeProgress = 0;
  int _escapeFromIndex = 0;
  int _escapeToIndex = 0;

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
    _scheduleNextPeek();
  }

  void _initShelters() {
    final w = bounds.width;
    final h = bounds.height;
    shelters = [
      // 左下草丛
      Shelter(
        rect: Rect.fromLTWH(w * 0.05, h * 0.6, w * 0.35, h * 0.3),
        type: ShelterType.grass,
      ),
      // 右下纸箱
      Shelter(
        rect: Rect.fromLTWH(w * 0.55, h * 0.65, w * 0.4, h * 0.28),
        type: ShelterType.box,
      ),
      // 中上草丛
      Shelter(
        rect: Rect.fromLTWH(w * 0.25, h * 0.15, w * 0.5, h * 0.25),
        type: ShelterType.grass,
      ),
      // 左上纸箱
      Shelter(
        rect: Rect.fromLTWH(w * 0.05, h * 0.2, w * 0.3, h * 0.22),
        type: ShelterType.box,
      ),
    ];
  }

  void _scheduleNextPeek() {
    _hideElapsed = 0;
    // 首次出现缩短等待，后续按频率随机
    _hideDuration = _isFirstPeek
        ? (300 + rng.nextDouble() * 400) / frequencyFactor
        : (1200 + rng.nextDouble() * 2000) / frequencyFactor;
    _isPeekingPhase = false;
  }

  /// 点击是否命中当前生物所在的掩体
  bool tapShelter(Offset point) {
    if (_isEscaping) return false;
    if (!_creatureVisible) return false;

    final shelter = shelters[_currentShelterIndex];
    if (shelter.rect.contains(point)) {
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
    // 确保逃往不同的掩体
    final others = List.generate(shelters.length, (i) => i)
        .where((i) => i != _currentShelterIndex)
        .toList();
    _escapeToIndex = others[rng.nextInt(others.length)];
    _currentShelterIndex = _escapeToIndex;
    _creatureType = rng.nextBool() ? CreatureType.bird : CreatureType.snake;
  }

  Rect _getCreaturePeekRect() {
    final s = shelters[_currentShelterIndex];
    return Rect.fromLTWH(
      s.rect.left + s.rect.width * 0.2,
      s.rect.top + s.rect.height * 0.3,
      s.rect.width * 0.6,
      s.rect.height * 0.5,
    );
  }

  /// 返回 true 表示需要重绘
  bool update(double deltaMs) {
    if (_isEscaping) {
      _escapeProgress += deltaMs / 400;
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
        _peekProgress = 1.0 - (_peekElapsed / _peekHideDuration).clamp(0.0, 1.0);
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
      return true; // 立即触发重绘，让生物出现
    }
    return false;
  }

  void _startPeek() {
    onPeekStarted?.call();
    _isPeekingPhase = true;
    _creatureVisible = true;
    _peekElapsed = 0;
    _peekPhase = 0;
    _peekAppearDuration = 400 + rng.nextDouble() * 300;
    _peekHoldDuration = 600 + rng.nextDouble() * 800;
    _peekHideDuration = 300 + rng.nextDouble() * 200;
    _peekProgress = 0;
  }
}
