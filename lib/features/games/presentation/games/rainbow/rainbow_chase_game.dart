import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import '../../../domain/game_config.dart';

/// 彩虹追逐（互动增强版）
/// - 彩虹光带随时间流动
/// - 触碰屏幕会吸引彩虹靠近并产生光点
/// - 轻量粒子与扩散波纹
/// - 互动次数显示
class RainbowChaseGame extends StatefulWidget {
  final GameConfig config;

  const RainbowChaseGame({
    super.key,
    required this.config,
  });

  @override
  State<RainbowChaseGame> createState() => _RainbowChaseGameState();
}

class _RainbowChaseGameState extends State<RainbowChaseGame> {
  final Random _rng = Random();
  Rect _bounds = Rect.zero;
  Offset _head = Offset.zero;
  Offset _dir = const Offset(1, 0);
  final List<Offset> _trail = [];
  final List<_Sparkle> _sparkles = [];
  final List<_Ripple> _ripples = [];
  double _lastTime = 0;
  double _time = 0;
  bool _initialized = false;
  Offset? _attractor;
  double _attractorLife = 0;
  int _touchCount = 0;

  @override
  void initState() {
    super.initState();
    _scheduleFrame();
  }

  void _scheduleFrame() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final now = DateTime.now().millisecondsSinceEpoch.toDouble();
      final deltaMs = _lastTime > 0 ? now - _lastTime : 16.0;
      _lastTime = now;

      if (_initialized) {
        _update(deltaMs);
      }

      setState(() {});
      _scheduleFrame();
    });
  }

  void _init(Size size) {
    if (size.width <= 0 || size.height <= 0) return;
    _bounds = Offset.zero & size;
    _head = Offset(size.width * 0.5, size.height * 0.55);
    _dir = _randomDir();
    _trail
      ..clear()
      ..addAll(List.filled(50, _head));
    _sparkles.clear();
    _ripples.clear();
    _initialized = true;
  }

  void _update(double deltaMs) {
    final dt = deltaMs / 1000.0;
    _time += deltaMs;

    final speed = 70 + widget.config.speed * 140; // 70~210 px/s

    // 处理吸引点
    if (_attractor != null) {
      _attractorLife -= dt;
      if (_attractorLife <= 0) {
        _attractor = null;
      }
    }

    Offset dir = _dir;
    if (_attractor != null) {
      final to = _attractor! - _head;
      if (to.distance > 2) {
        final desire = _normalize(to);
        final steer = 0.08 + widget.config.speed * 0.1;
        dir = _lerpDir(dir, desire, steer);
      }
    } else {
      final angle = atan2(dir.dy, dir.dx);
      final drift =
          sin(_time / 1200) * 0.18 + cos(_time / 900) * 0.14;
      dir = Offset(cos(angle + drift), sin(angle + drift));
    }

    // 边缘回弹
    const margin = 80.0;
    if (_head.dx < margin) {
      dir = _normalize(dir + const Offset(0.9, 0));
    } else if (_head.dx > _bounds.width - margin) {
      dir = _normalize(dir + const Offset(-0.9, 0));
    }
    if (_head.dy < margin) {
      dir = _normalize(dir + const Offset(0, 0.9));
    } else if (_head.dy > _bounds.height - margin) {
      dir = _normalize(dir + const Offset(0, -0.9));
    }

    _dir = _normalize(dir);
    _head += _dir * speed * dt;

    // 硬边界处理
    if (_head.dx < 0) {
      _head = Offset(0, _head.dy);
      _dir = Offset(_dir.dx.abs(), _dir.dy);
    } else if (_head.dx > _bounds.width) {
      _head = Offset(_bounds.width, _head.dy);
      _dir = Offset(-_dir.dx.abs(), _dir.dy);
    }
    if (_head.dy < 0) {
      _head = Offset(_head.dx, 0);
      _dir = Offset(_dir.dx, _dir.dy.abs());
    } else if (_head.dy > _bounds.height) {
      _head = Offset(_head.dx, _bounds.height);
      _dir = Offset(_dir.dx, -_dir.dy.abs());
    }

    _trail.add(_head);
    while (_trail.length > 60) {
      _trail.removeAt(0);
    }

    for (int i = _sparkles.length - 1; i >= 0; i--) {
      final s = _sparkles[i];
      s.life -= dt;
      if (s.life <= 0) {
        _sparkles.removeAt(i);
      } else {
        s.pos += s.vel * dt;
        s.vel = s.vel * 0.9;
      }
    }

    for (int i = _ripples.length - 1; i >= 0; i--) {
      final r = _ripples[i];
      r.age += dt;
      if (r.age >= r.maxAge) {
        _ripples.removeAt(i);
      }
    }
  }

  void _onTap(Offset localPosition) {
    _touchCount++;
    _attractor = localPosition;
    _attractorLife = 1.6;
    _spawnSparkles(localPosition);
    _spawnRipple(localPosition);

    if (widget.config.vibrationEnabled) {
      HapticFeedback.lightImpact();
    }
    if (widget.config.soundEnabled) {
      SystemSound.play(SystemSoundType.click);
    }
  }

  void _spawnSparkles(Offset pos) {
    const count = 14;
    for (int i = 0; i < count; i++) {
      final angle = _rng.nextDouble() * pi * 2;
      final speed = 60 + _rng.nextDouble() * 140;
      final hue = _rng.nextDouble() * 360;
      _sparkles.add(_Sparkle(
        pos: pos,
        vel: Offset(cos(angle), sin(angle)) * speed,
        life: 0.5 + _rng.nextDouble() * 0.6,
        maxLife: 1.1,
        radius: 1.5 + _rng.nextDouble() * 2.5,
        hue: hue,
      ));
    }
  }

  void _spawnRipple(Offset pos) {
    _ripples.add(_Ripple(pos: pos, age: 0, maxAge: 0.9));
  }

  Offset _randomDir() {
    final angle = _rng.nextDouble() * pi * 2;
    return Offset(cos(angle), sin(angle));
  }

  Offset _normalize(Offset v) {
    final len = v.distance;
    if (len <= 0.0001) return const Offset(1, 0);
    return v / len;
  }

  Offset _lerpDir(Offset a, Offset b, double t) {
    final lerp = Offset.lerp(a, b, t) ?? b;
    return _normalize(lerp);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        if (size.width > 0 && size.height > 0) {
          if (!_initialized || _bounds.size != size) {
            _init(size);
          }
        }
        if (!_initialized) {
          return const SizedBox.expand();
        }
        return Listener(
          behavior: HitTestBehavior.opaque,
          onPointerDown: (e) => _onTap(e.localPosition),
          child: CustomPaint(
            size: Size(constraints.maxWidth, constraints.maxHeight),
            painter: _RainbowChasePainter(
              bounds: _bounds,
              head: _head,
              trail: _trail,
              time: _time,
              sparkles: _sparkles,
              ripples: _ripples,
              touchCount: _touchCount,
            ),
          ),
        );
      },
    );
  }
}

class _RainbowChasePainter extends CustomPainter {
  final Rect bounds;
  final Offset head;
  final List<Offset> trail;
  final double time;
  final List<_Sparkle> sparkles;
  final List<_Ripple> ripples;
  final int touchCount;

  _RainbowChasePainter({
    required this.bounds,
    required this.head,
    required this.trail,
    required this.time,
    required this.sparkles,
    required this.ripples,
    required this.touchCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _paintBackground(canvas, bounds);
    _paintStars(canvas, bounds);
    _paintGlow(canvas, head);
    _paintRibbon(canvas, trail, time);
    _paintHead(canvas, head, time);
    _paintRipples(canvas, ripples);
    _paintSparkles(canvas, sparkles);
    _paintTouchCount(canvas, size, touchCount);
    if (touchCount == 0) {
      _paintHint(canvas, size);
    }
  }

  void _paintBackground(Canvas canvas, Rect bounds) {
    final bgPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFF0B0619),
          const Color(0xFF12062D),
          const Color(0xFF070714),
        ],
      ).createShader(bounds);
    canvas.drawRect(bounds, bgPaint);

    // 轻微的流动纹理
    final wavePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.02)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    for (double y = 0; y < bounds.height; y += 40) {
      final path = Path()..moveTo(0, y);
      for (double x = 0; x <= bounds.width; x += 12) {
        final wave = sin(time / 1200 + x / 80 + y / 120) * 4;
        path.lineTo(x, y + wave);
      }
      canvas.drawPath(path, wavePaint);
    }
  }

  void _paintStars(Canvas canvas, Rect bounds) {
    final rng = Random(11);
    for (int i = 0; i < 32; i++) {
      final x = rng.nextDouble() * bounds.width;
      final y = rng.nextDouble() * bounds.height * 0.7;
      final twinkle = sin(time / 800 + i * 1.7) * 0.5 + 0.5;
      final color = Colors.white.withValues(alpha: 0.1 + twinkle * 0.25);
      canvas.drawCircle(Offset(x, y), 1.2, Paint()..color = color);
    }
  }

  void _paintGlow(Canvas canvas, Offset pos) {
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF9C27B0).withValues(alpha: 0.12),
          const Color(0xFF3F51B5).withValues(alpha: 0.06),
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: pos, radius: 160));
    canvas.drawCircle(pos, 160, glowPaint);
  }

  void _paintRibbon(Canvas canvas, List<Offset> trail, double time) {
    if (trail.length < 2) return;

    for (int i = 0; i < trail.length; i++) {
      final t = i / (trail.length - 1);
      final pos = trail[i];
      final hue = (t * 260 + time / 18) % 360;
      final alpha = 0.15 + t * 0.7;
      final radius = 4 + t * 10;

      final color = HSVColor.fromAHSV(alpha, hue, 0.9, 1.0).toColor();
      final glow = Paint()
        ..color = color.withValues(alpha: alpha * 0.6)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 8 + t * 10);
      canvas.drawCircle(pos, radius * 1.4, glow);

      final core = Paint()..color = color;
      canvas.drawCircle(pos, radius, core);
    }
  }

  void _paintHead(Canvas canvas, Offset pos, double time) {
    final pulse = sin(time / 200) * 0.2 + 0.9;
    final core = Paint()..color = Colors.white;
    final ring = Paint()
      ..color = const Color(0xFFFFF59D).withValues(alpha: 0.9)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawCircle(pos, 18 * pulse, ring);
    canvas.drawCircle(pos, 7 * pulse, core);
  }

  void _paintSparkles(Canvas canvas, List<_Sparkle> sparkles) {
    for (final s in sparkles) {
      final lifeT = (s.life / s.maxLife).clamp(0.0, 1.0);
      final color = HSVColor.fromAHSV(
        0.5 * lifeT,
        s.hue,
        0.9,
        1.0,
      ).toColor();
      final paint = Paint()
        ..color = color
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
      canvas.drawCircle(s.pos, s.radius * (0.6 + lifeT), paint);
    }
  }

  void _paintRipples(Canvas canvas, List<_Ripple> ripples) {
    for (final r in ripples) {
      final t = (r.age / r.maxAge).clamp(0.0, 1.0);
      final radius = 20 + t * 90;
      final alpha = (1 - t) * 0.4;
      final ringPaint = Paint()
        ..color = const Color(0xFFB388FF).withValues(alpha: alpha)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2 * (1 - t);
      canvas.drawCircle(r.pos, radius, ringPaint);
    }
  }

  void _paintTouchCount(Canvas canvas, Size size, int count) {
    final textPainter = TextPainter(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$count',
            style: const TextStyle(
              color: Color(0xCCFFFFFF),
              fontSize: 28,
              fontWeight: FontWeight.w300,
            ),
          ),
          const TextSpan(
            text: ' 互动',
            style: TextStyle(
              color: Color(0x88FFFFFF),
              fontSize: 13,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      const Offset(68, 56),
    );
  }

  void _paintHint(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: '轻触屏幕，彩虹会靠近猫爪',
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.5),
          fontSize: 12,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(maxWidth: size.width - 40);
    textPainter.paint(
      canvas,
      Offset((size.width - textPainter.width) / 2, size.height * 0.68),
    );
  }

  @override
  bool shouldRepaint(covariant _RainbowChasePainter oldDelegate) => true;
}

class _Sparkle {
  Offset pos;
  Offset vel;
  double life;
  final double maxLife;
  final double radius;
  final double hue;

  _Sparkle({
    required this.pos,
    required this.vel,
    required this.life,
    required this.maxLife,
    required this.radius,
    required this.hue,
  });
}

class _Ripple {
  final Offset pos;
  double age;
  final double maxAge;

  _Ripple({
    required this.pos,
    required this.age,
    required this.maxAge,
  });
}
