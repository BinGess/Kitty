import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import '../../../domain/game_config.dart';
import '../../../../../core/l10n/app_localizations.dart';

class _TapRing {
  final Offset center;
  double age;
  final double maxAge;

  _TapRing({required this.center, required this.age, required this.maxAge});
}

class _HitParticle {
  Offset pos;
  Offset vel;
  double age;
  final double maxAge;
  final double size;
  final Color color;

  _HitParticle({
    required this.pos,
    required this.vel,
    required this.age,
    required this.maxAge,
    required this.size,
    required this.color,
  });
}

/// 羽毛逗杆：模拟逗猫棒轨迹，点击羽毛得分
class FeatherWandGame extends StatefulWidget {
  final GameConfig config;

  const FeatherWandGame({super.key, required this.config});

  @override
  State<FeatherWandGame> createState() => _FeatherWandGameState();
}

class _FeatherWandGameState extends State<FeatherWandGame> {
  final Random _rng = Random();
  Rect _bounds = Rect.zero;
  bool _initialized = false;
  double _lastTime = 0;
  double _time = 0;
  int _score = 0;
  Offset _featherPos = Offset.zero;
  final List<Offset> _trail = [];
  final List<_TapRing> _rings = [];
  final List<_HitParticle> _particles = [];
  double _pauseAfterHit = 0;
  double _hitFlash = 0;
  Offset? _lastHitPos;

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
    _time = 0;
    _featherPos = Offset(size.width * 0.5, size.height * 0.55);
    _trail
      ..clear()
      ..addAll(List.filled(36, _featherPos));
    _initialized = true;
  }

  void _update(double deltaMs) {
    final dt = deltaMs / 1000.0;

    _hitFlash = (_hitFlash - dt * 3.2).clamp(0.0, 1.0);

    for (int i = _particles.length - 1; i >= 0; i--) {
      final p = _particles[i];
      p.age += dt;
      if (p.age >= p.maxAge) {
        _particles.removeAt(i);
        continue;
      }
      p.pos += p.vel * dt;
      p.vel = p.vel * 0.9;
    }

    for (int i = _rings.length - 1; i >= 0; i--) {
      final ring = _rings[i];
      ring.age += dt;
      if (ring.age >= ring.maxAge) {
        _rings.removeAt(i);
      }
    }

    if (_pauseAfterHit > 0) {
      _pauseAfterHit = (_pauseAfterHit - dt).clamp(0.0, 10.0);
      return;
    }

    final speed = 0.35 + widget.config.speed * 0.75;
    // 周期性"悬停"：用低频正弦调制速度，让羽毛偶尔近似静止，模拟逗猫棒被轻轻搭着不动
    final hoverFactor =
        (sin(_time * 0.52 + pi / 3) > 0.78) ? 0.07 : 1.0;
    _time += dt * speed * hoverFactor;

    final w = _bounds.width;
    final h = _bounds.height;
    final x =
        w * 0.5 + sin(_time * 1.8) * w * 0.28 + sin(_time * 4.2) * w * 0.06;
    final y =
        h * 0.52 +
        cos(_time * 2.4 + 0.7) * h * 0.22 +
        sin(_time * 5.0 + 1.2) * h * 0.05;
    _featherPos = Offset(x.clamp(36, w - 36), y.clamp(120, h - 80));

    _trail.add(_featherPos);
    while (_trail.length > 42) {
      _trail.removeAt(0);
    }
  }

  void _onTap(Offset localPosition) {
    if (!_initialized) return;
    const hitRadius = 68.0;
    if ((localPosition - _featherPos).distance > hitRadius) return;

    _score++;
    _rings.add(_TapRing(center: localPosition, age: 0, maxAge: 0.42));
    _hitFlash = 1.0;
    _lastHitPos = _featherPos;
    _spawnParticles(_featherPos);
    _pauseAfterHit = 0.28;
    if (widget.config.vibrationEnabled) {
      HapticFeedback.mediumImpact();
    }
    if (widget.config.soundEnabled) {
      SystemSound.play(SystemSoundType.click);
    }
  }

  void _spawnParticles(Offset center) {
    const palette = [
      Color(0xFFB2DFDB),
      Color(0xFF80CBC4),
      Color(0xFF26A69A),
      Color(0xFFFFF59D),
    ];
    for (int i = 0; i < 14; i++) {
      final angle = _rng.nextDouble() * pi * 2;
      final speed = 70 + _rng.nextDouble() * 140;
      _particles.add(
        _HitParticle(
          pos: center,
          vel: Offset(cos(angle), sin(angle)) * speed,
          age: 0,
          maxAge: 0.5 + _rng.nextDouble() * 0.25,
          size: 2 + _rng.nextDouble() * 2.5,
          color: palette[_rng.nextInt(palette.length)],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        final overlayTop = MediaQuery.of(context).padding.top + 12;
        const overlaySize = 48.0;
        const overlayLeft = 12.0;
        if (!_initialized || _bounds.size != size) {
          _init(size);
        }
        if (!_initialized) return const SizedBox.expand();

        final l10n = AppLocalizations.of(context)!;
        return Listener(
          behavior: HitTestBehavior.opaque,
          onPointerDown: (event) => _onTap(event.localPosition),
          child: CustomPaint(
            size: size,
            painter: _FeatherWandPainter(
              bounds: _bounds,
              featherPos: _featherPos,
              trail: _trail,
              rings: _rings,
              particles: _particles,
              hitFlash: _hitFlash,
              lastHitPos: _lastHitPos,
              score: _score,
              overlayTop: overlayTop,
              overlaySize: overlaySize,
              overlayLeft: overlayLeft,
              scoreUnit: l10n.gameScoreUnit,
              hintText: l10n.gameFeatherWandHint,
              hitText: l10n.gameFeatherWandHit,
            ),
          ),
        );
      },
    );
  }
}

class _FeatherWandPainter extends CustomPainter {
  final Rect bounds;
  final Offset featherPos;
  final List<Offset> trail;
  final List<_TapRing> rings;
  final List<_HitParticle> particles;
  final double hitFlash;
  final Offset? lastHitPos;
  final int score;
  final double overlayTop;
  final double overlaySize;
  final double overlayLeft;
  final String scoreUnit;
  final String hintText;
  final String hitText;

  _FeatherWandPainter({
    required this.bounds,
    required this.featherPos,
    required this.trail,
    required this.rings,
    required this.particles,
    required this.hitFlash,
    required this.lastHitPos,
    required this.score,
    required this.overlayTop,
    required this.overlaySize,
    required this.overlayLeft,
    required this.scoreUnit,
    required this.hintText,
    required this.hitText,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _paintBackground(canvas, size);
    _paintString(canvas, size);
    _paintTrail(canvas);
    _paintFeather(canvas, featherPos);
    _paintRings(canvas);
    _paintParticles(canvas);
    _paintHitFeedback(canvas);
    _paintScore(canvas);
    if (score == 0) {
      _paintHint(canvas, size);
    }
  }

  void _paintBackground(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF114B4B), Color(0xFF0E3A3A), Color(0xFF0A2A2A)],
        ).createShader(rect),
    );

    final wavePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.03)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    for (double y = size.height * 0.28; y < size.height; y += 34) {
      final path = Path()..moveTo(0, y);
      for (double x = 0; x <= size.width; x += 14) {
        path.lineTo(x, y + sin(x / 52 + y / 80) * 2.8);
      }
      canvas.drawPath(path, wavePaint);
    }
  }

  void _paintString(Canvas canvas, Size size) {
    final start = Offset(size.width * 0.5, 0);
    final control = Offset(
      (start.dx + featherPos.dx) / 2,
      featherPos.dy * 0.45,
    );
    final path = Path()
      ..moveTo(start.dx, start.dy)
      ..quadraticBezierTo(control.dx, control.dy, featherPos.dx, featherPos.dy);
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.32)
        ..strokeWidth = 1.4
        ..style = PaintingStyle.stroke,
    );
  }

  void _paintTrail(Canvas canvas) {
    if (trail.length < 2) return;
    for (int i = 0; i < trail.length; i++) {
      final t = i / trail.length;
      final alpha = t * 0.28;
      canvas.drawCircle(
        trail[i],
        2 + t * 5,
        Paint()
          ..color = const Color(0xFF80CBC4).withValues(alpha: alpha)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
      );
    }
  }

  void _paintFeather(Canvas canvas, Offset c) {
    final stemPaint = Paint()
      ..color = const Color(0xFFB2DFDB)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(c.dx, c.dy - 20),
      Offset(c.dx, c.dy + 14),
      stemPaint,
    );

    final left = Path()
      ..moveTo(c.dx, c.dy - 12)
      ..quadraticBezierTo(c.dx - 20, c.dy - 6, c.dx - 10, c.dy + 10)
      ..quadraticBezierTo(c.dx - 2, c.dy + 2, c.dx, c.dy - 8)
      ..close();
    final right = Path()
      ..moveTo(c.dx, c.dy - 10)
      ..quadraticBezierTo(c.dx + 18, c.dy - 2, c.dx + 10, c.dy + 14)
      ..quadraticBezierTo(c.dx + 2, c.dy + 3, c.dx, c.dy - 6)
      ..close();

    canvas.drawPath(left, Paint()..color = const Color(0xFF80CBC4));
    canvas.drawPath(right, Paint()..color = const Color(0xFF26A69A));
    canvas.drawCircle(
      c,
      34,
      Paint()
        ..color = const Color(
          0xFF80CBC4,
        ).withValues(alpha: 0.15 + hitFlash * 0.2)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );
    if (hitFlash > 0.01) {
      canvas.drawCircle(
        c,
        22 + hitFlash * 20,
        Paint()
          ..color = Colors.white.withValues(alpha: hitFlash * 0.28)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2 + hitFlash * 2,
      );
    }
  }

  void _paintRings(Canvas canvas) {
    for (final ring in rings) {
      final t = (ring.age / ring.maxAge).clamp(0.0, 1.0);
      final radius = 14 + t * 38;
      final alpha = (1 - t) * 0.55;
      canvas.drawCircle(
        ring.center,
        radius,
        Paint()
          ..color = const Color(0xFFB2DFDB).withValues(alpha: alpha * 1.2)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4 - t * 2.4,
      );
    }
  }

  void _paintParticles(Canvas canvas) {
    for (final p in particles) {
      final t = (p.age / p.maxAge).clamp(0.0, 1.0);
      final alpha = (1 - t) * 0.95;
      canvas.drawCircle(
        p.pos,
        p.size * (1 - t * 0.35),
        Paint()..color = p.color.withValues(alpha: alpha),
      );
    }
  }

  void _paintHitFeedback(Canvas canvas) {
    final pos = lastHitPos;
    if (pos == null || hitFlash <= 0.01) return;

    final tp = TextPainter(
      text: TextSpan(
        text: hitText,
        style: TextStyle(
          color: const Color(0xFFFFF59D).withValues(alpha: hitFlash),
          fontSize: 22,
          fontWeight: FontWeight.w800,
          shadows: [
            Shadow(
              color: Colors.black.withValues(alpha: hitFlash * 0.4),
              blurRadius: 6,
            ),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(
      canvas,
      Offset(pos.dx - tp.width / 2, pos.dy - 68 - (1 - hitFlash) * 14),
    );
  }

  void _paintScore(Canvas canvas) {
    final tp = TextPainter(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$score',
            style: const TextStyle(
              color: Color(0xAAFFFFFF),
              fontSize: 32,
              fontWeight: FontWeight.w300,
              letterSpacing: 2,
            ),
          ),
          TextSpan(
            text: ' $scoreUnit',
            style: const TextStyle(
              color: Color(0x66FFFFFF),
              fontSize: 14,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(
      canvas,
      Offset(overlayLeft, overlayTop + (overlaySize - tp.height) / 2),
    );
  }

  void _paintHint(Canvas canvas, Size size) {
    final tp = TextPainter(
      text: TextSpan(
        text: hintText,
        style: const TextStyle(
          color: Color(0xCCFFFFFF),
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(maxWidth: size.width - 32);
    tp.paint(canvas, Offset((size.width - tp.width) / 2, size.height * 0.2));
  }

  @override
  bool shouldRepaint(covariant _FeatherWandPainter oldDelegate) => true;
}
