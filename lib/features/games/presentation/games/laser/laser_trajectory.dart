import 'dart:math';
import 'package:flutter/material.dart';

/// 模拟昆虫飞行的轨迹算法：快速移动 - 静止观察 - 突然消失
/// 增强版：支持轨迹历史（拖尾）、脉冲效果、边缘感知
class LaserTrajectory {
  LaserTrajectory({
    required this.bounds,
    required this.rng,
    this.dotRadius = 14,
  });

  final Rect bounds;
  final Random rng;
  final double dotRadius;

  static const double _margin = 40;
  static const int _maxTrailLength = 20;

  /// 轨迹阶段
  LaserPhase get phase => _phase;
  LaserPhase _phase = LaserPhase.moving;

  /// 当前光点位置
  Offset? get position => _position;
  Offset? _position;

  /// 当前光点是否可见
  bool get visible => _visible;
  bool _visible = true;

  /// 当前使用的颜色（红/绿）
  Color get color => _color;
  Color _color = const Color(0xFFFF0000);

  /// 轨迹历史 (最新在末尾)
  List<Offset> get trail => _trail;
  final List<Offset> _trail = [];

  /// 脉冲进度 0~1 循环
  double get pulsePhase => _pulsePhase;
  double _pulsePhase = 0;

  /// 暂停阶段的微抖动偏移
  Offset get jitter => _jitter;
  Offset _jitter = Offset.zero;

  // 轨迹参数
  Offset _start = Offset.zero;
  Offset _end = Offset.zero;
  Offset _control = Offset.zero;
  PathType _pathType = PathType.straight;
  double _progress = 0;
  double _phaseDuration = 0;
  double _phaseElapsed = 0;
  int _trailCounter = 0;

  void _pickRandomPosition() {
    final w = bounds.width - _margin * 2;
    final h = bounds.height - _margin * 2;
    _position = Offset(
      _margin + rng.nextDouble() * w,
      _margin + rng.nextDouble() * h,
    );
  }

  void _pickColor() {
    // 80% 红色，20% 绿色（猫咪对红色更敏感）
    _color = rng.nextDouble() < 0.8
        ? const Color(0xFFFF0000)
        : const Color(0xFF00FF00);
  }

  /// 开始新的一轮
  void startNewCycle() {
    _pickColor();
    _start = _position ?? _pickFirstPosition();
    _pickRandomPosition();
    _end = _position!;
    _position = _start;
    _trail.clear();

    // 60% 弧线，40% 直线
    _pathType = rng.nextDouble() < 0.6 ? PathType.arc : PathType.straight;
    if (_pathType == PathType.arc) {
      final mid = Offset(
        (_start.dx + _end.dx) / 2,
        (_start.dy + _end.dy) / 2,
      );
      final perp = Offset(-(_end.dy - _start.dy), _end.dx - _start.dx);
      final len = sqrt(perp.dx * perp.dx + perp.dy * perp.dy);
      if (len > 1) {
        final unit = Offset(perp.dx / len, perp.dy / len);
        final bend = (rng.nextDouble() - 0.5) * 2;
        _control = Offset(
          mid.dx + unit.dx * 100 * bend,
          mid.dy + unit.dy * 100 * bend,
        );
      } else {
        _control = mid;
      }
    }

    _phase = LaserPhase.moving;
    _visible = true;
    _progress = 0;
    _phaseElapsed = 0;
    _phaseDuration = 800 + rng.nextDouble() * 600; // 800~1400ms
  }

  Offset _pickFirstPosition() {
    final w = bounds.width - _margin * 2;
    final h = bounds.height - _margin * 2;
    return Offset(
      _margin + rng.nextDouble() * w,
      _margin + rng.nextDouble() * h,
    );
  }

  void _enterPause() {
    _phase = LaserPhase.paused;
    _position = _end;
    _phaseElapsed = 0;
    _phaseDuration = 400 + rng.nextDouble() * 800;
    _trail.clear(); // 暂停时清除拖尾
  }

  void _enterVanish() {
    _phase = LaserPhase.vanished;
    _visible = false;
    _position = null;
    _phaseElapsed = 0;
    _phaseDuration = 150 + rng.nextDouble() * 150;
    _trail.clear();
  }

  /// 检测点击是否命中光点（用于计分）
  bool tapHit(Offset point) {
    if (!_visible || _position == null) return false;
    final dx = point.dx - _position!.dx;
    final dy = point.dy - _position!.dy;
    // 命中半径比视觉半径大一些，方便点击
    return dx * dx + dy * dy <= (dotRadius * 2.5) * (dotRadius * 2.5);
  }

  /// 更新，deltaMs 为帧间隔毫秒
  bool update(double deltaMs, double speedFactor) {
    // 脉冲循环
    _pulsePhase = (_pulsePhase + deltaMs / 800) % 1.0;

    _phaseElapsed += deltaMs;
    final duration = _phaseDuration / speedFactor;

    switch (_phase) {
      case LaserPhase.moving:
        _progress = (_phaseElapsed / duration).clamp(0.0, 1.0);
        // 使用缓动曲线让移动更自然
        final easedProgress = _easeInOutCubic(_progress);
        _position = _interpolate(easedProgress);

        // 每2帧记录一次轨迹
        _trailCounter++;
        if (_trailCounter % 2 == 0 && _position != null) {
          _trail.add(_position!);
          if (_trail.length > _maxTrailLength) {
            _trail.removeAt(0);
          }
        }

        if (_progress >= 1) {
          _enterPause();
        }
        return true;

      case LaserPhase.paused:
        // 暂停时微抖动，模拟昆虫停留时的细微移动
        _jitter = Offset(
          sin(_phaseElapsed / 80) * 1.5,
          cos(_phaseElapsed / 120) * 1.0,
        );
        if (_phaseElapsed >= duration) {
          _enterVanish();
          return true;
        }
        return true; // 微抖动需要重绘

      case LaserPhase.vanished:
        if (_phaseElapsed >= duration) {
          startNewCycle();
        }
        return true;
    }
  }

  double _easeInOutCubic(double t) {
    return t < 0.5
        ? 4 * t * t * t
        : 1 - pow(-2 * t + 2, 3) / 2;
  }

  Offset _interpolate(double t) {
    if (_pathType == PathType.straight) {
      return Offset.lerp(_start, _end, t)!;
    }
    final mt = 1 - t;
    final x = mt * mt * _start.dx +
        2 * mt * t * _control.dx +
        t * t * _end.dx;
    final y = mt * mt * _start.dy +
        2 * mt * t * _control.dy +
        t * t * _end.dy;
    return Offset(x, y);
  }
}

enum LaserPhase { moving, paused, vanished }

enum PathType { straight, arc }
