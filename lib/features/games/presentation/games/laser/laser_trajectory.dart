import 'dart:math';
import 'package:flutter/material.dart';

/// 模拟昆虫飞行的轨迹算法：快速移动 - 静止观察 - 突然消失
class LaserTrajectory {
  LaserTrajectory({
    required this.bounds,
    required this.rng,
    this.dotRadius = 12,
  });

  final Rect bounds;
  final Random rng;
  final double dotRadius;

  static const double _margin = 40;

  /// 轨迹阶段
  LaserPhase get phase => _phase;
  LaserPhase _phase = LaserPhase.moving;

  /// 当前光点位置（移动中为插值，消失阶段为 null）
  Offset? get position => _position;
  Offset? _position;

  /// 当前光点是否可见（消失阶段为 false）
  bool get visible => _visible;
  bool _visible = true;

  /// 当前使用的颜色（红/绿）
  Color get color => _color;
  Color _color = const Color(0xFFFF0000);

  // 轨迹参数
  Offset _start = Offset.zero;
  Offset _end = Offset.zero;
  Offset _control = Offset.zero; // 弧线控制点
  PathType _pathType = PathType.straight;
  double _progress = 0;
  double _phaseDuration = 0;
  double _phaseElapsed = 0;

  void _pickRandomPosition() {
    final w = bounds.width - _margin * 2;
    final h = bounds.height - _margin * 2;
    _position = Offset(
      _margin + rng.nextDouble() * w,
      _margin + rng.nextDouble() * h,
    );
  }

  void _pickColor() {
    _color = rng.nextBool()
        ? const Color(0xFFFF0000) // 红
        : const Color(0xFF00FF00); // 绿
  }

  /// 开始新的一轮：随机选点、随机轨迹类型
  void startNewCycle() {
    _pickColor();
    _start = _position ?? _pickFirstPosition();
    _pickRandomPosition();
    _end = _position!;
    _position = _start;

    _pathType = rng.nextDouble() < 0.6 ? PathType.straight : PathType.arc;
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
          mid.dx + unit.dx * 80 * bend,
          mid.dy + unit.dy * 80 * bend,
        );
      } else {
        _control = mid;
      }
    }

    _phase = LaserPhase.moving;
    _visible = true;
    _progress = 0;
    _phaseDuration = 800 + rng.nextDouble() * 600; // 800~1400ms 移动
  }

  Offset _pickFirstPosition() {
    final w = bounds.width - _margin * 2;
    final h = bounds.height - _margin * 2;
    return Offset(
      _margin + rng.nextDouble() * w,
      _margin + rng.nextDouble() * h,
    );
  }

  /// 进入静止观察阶段
  void _enterPause() {
    _phase = LaserPhase.paused;
    _position = _end;
    _phaseElapsed = 0;
    _phaseDuration = 400 + rng.nextDouble() * 800; // 400~1200ms 静止
  }

  /// 进入突然消失阶段（短暂不可见后跳转）
  void _enterVanish() {
    _phase = LaserPhase.vanished;
    _visible = false;
    _position = null;
    _phaseElapsed = 0;
    _phaseDuration = 150 + rng.nextDouble() * 150; // 150~300ms 消失
  }

  /// 更新，deltaMs 为帧间隔毫秒
  /// 返回 true 表示需要重绘
  bool update(double deltaMs, double speedFactor) {
    _phaseElapsed += deltaMs;
    final duration = _phaseDuration / speedFactor;

    switch (_phase) {
      case LaserPhase.moving:
        _progress = (_phaseElapsed / duration).clamp(0.0, 1.0);
        _position = _interpolate(_progress);
        if (_progress >= 1) {
          _enterPause();
        }
        return true;

      case LaserPhase.paused:
        if (_phaseElapsed >= duration) {
          _enterVanish();
          return true; // 消失需重绘
        }
        return false;

      case LaserPhase.vanished:
        if (_phaseElapsed >= duration) {
          startNewCycle();
        }
        return true;
    }
  }

  Offset _interpolate(double t) {
    if (_pathType == PathType.straight) {
      return Offset.lerp(_start, _end, t)!;
    }
    // 二次贝塞尔弧线
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
