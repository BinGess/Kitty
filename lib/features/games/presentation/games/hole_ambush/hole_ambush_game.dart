import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import '../../../domain/game_config.dart';
import '../../../../../core/l10n/app_localizations.dart';

enum _AmbushPhase { waiting, rising, holding, falling }

enum _AmbushTarget { mouse, fish, feather }

class _HitPulse {
  final Offset center;
  double age;
  final double maxAge;

  _HitPulse({required this.center, required this.age, required this.maxAge});
}

class _ConfettiParticle {
  Offset position;
  Offset velocity;
  double age;
  final double maxAge;
  final Color color;
  final double size;
  double rotation;
  final double spin;

  _ConfettiParticle({
    required this.position,
    required this.velocity,
    required this.age,
    required this.maxAge,
    required this.color,
    required this.size,
    required this.rotation,
    required this.spin,
  });
}

/// 洞洞伏击：猎物会随机从洞口探头，点击命中得分
class HoleAmbushGame extends StatefulWidget {
  final GameConfig config;

  const HoleAmbushGame({super.key, required this.config});

  @override
  State<HoleAmbushGame> createState() => _HoleAmbushGameState();
}

class _HoleAmbushGameState extends State<HoleAmbushGame> {
  final Random _rng = Random();
  Rect _bounds = Rect.zero;
  List<Offset> _holes = const [];
  bool _initialized = false;
  ui.Image? _mouseImage;
  ui.Image? _fishImage;

  _AmbushPhase _phase = _AmbushPhase.waiting;
  _AmbushTarget _activeTarget = _AmbushTarget.mouse;
  int _activeHoleIndex = 0;
  double _phaseElapsed = 0;
  double _phaseDuration = 0.8;
  double _peekProgress = 0;

  double _lastTime = 0;
  int _score = 0;
  final List<_HitPulse> _hitPulses = [];
  final List<_ConfettiParticle> _confetti = [];

  @override
  void initState() {
    super.initState();
    _loadTargetImages();
    _scheduleFrame();
  }

  Future<void> _loadTargetImages() async {
    final mouse = await _loadImageAsset(
      'assets/images/games/hole_ambush/ambush_mouse.png',
    );
    final fish = await _loadImageAsset(
      'assets/images/games/hole_ambush/ambush_fish.png',
    );
    if (!mounted) return;
    setState(() {
      _mouseImage = mouse;
      _fishImage = fish;
    });
  }

  Future<ui.Image?> _loadImageAsset(String assetPath) async {
    try {
      final data = await rootBundle.load(assetPath);
      final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
      final frame = await codec.getNextFrame();
      return frame.image;
    } catch (_) {
      return null;
    }
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
    _holes = _buildHoles(size);
    _activeHoleIndex = _rng.nextInt(_holes.length);
    _startWaiting(quick: true);
    _initialized = true;
  }

  List<Offset> _buildHoles(Size size) {
    const x = [0.18, 0.5, 0.82];
    const y = [0.47, 0.71];
    final holes = <Offset>[];
    for (final yi in y) {
      for (final xi in x) {
        holes.add(Offset(size.width * xi, size.height * yi));
      }
    }
    return holes;
  }

  void _update(double deltaMs) {
    final dt = deltaMs / 1000.0;
    _phaseElapsed += dt;

    switch (_phase) {
      case _AmbushPhase.waiting:
        _peekProgress = 0;
        if (_phaseElapsed >= _phaseDuration) {
          _startRising();
        }
      case _AmbushPhase.rising:
        final t = (_phaseElapsed / _phaseDuration).clamp(0.0, 1.0);
        _peekProgress = Curves.easeOutBack.transform(t);
        if (t >= 1) _startHolding();
      case _AmbushPhase.holding:
        _peekProgress = 1;
        if (_phaseElapsed >= _phaseDuration) {
          _startFalling();
        }
      case _AmbushPhase.falling:
        final t = (_phaseElapsed / _phaseDuration).clamp(0.0, 1.0);
        _peekProgress = 1 - Curves.easeIn.transform(t);
        if (t >= 1) _startWaiting();
    }

    for (int i = _hitPulses.length - 1; i >= 0; i--) {
      final pulse = _hitPulses[i];
      pulse.age += dt;
      if (pulse.age >= pulse.maxAge) {
        _hitPulses.removeAt(i);
      }
    }

    for (int i = _confetti.length - 1; i >= 0; i--) {
      final p = _confetti[i];
      p.age += dt;
      p.velocity = Offset(p.velocity.dx * 0.985, p.velocity.dy + 420 * dt);
      p.position = Offset(
        p.position.dx + p.velocity.dx * dt,
        p.position.dy + p.velocity.dy * dt,
      );
      p.rotation += p.spin * dt;
      if (p.age >= p.maxAge) {
        _confetti.removeAt(i);
      }
    }
  }

  void _startWaiting({bool quick = false}) {
    _phase = _AmbushPhase.waiting;
    _phaseElapsed = 0;
    final base = quick ? 0.2 : (1.2 - widget.config.speed * 0.75);
    _phaseDuration = max(0.18, base + _rng.nextDouble() * 0.25);
  }

  void _startRising() {
    _phase = _AmbushPhase.rising;
    _phaseElapsed = 0;
    _phaseDuration = max(0.16, 0.38 - widget.config.speed * 0.15);
    _pickNextTarget();
  }

  void _startHolding() {
    _phase = _AmbushPhase.holding;
    _phaseElapsed = 0;
    _phaseDuration = max(0.12, 0.46 - widget.config.speed * 0.22);
  }

  void _startFalling() {
    _phase = _AmbushPhase.falling;
    _phaseElapsed = 0;
    _phaseDuration = 0.22 + _rng.nextDouble() * 0.08;
  }

  void _pickNextTarget() {
    final current = _activeHoleIndex;
    int next = current;
    if (_holes.length > 1) {
      while (next == current) {
        next = _rng.nextInt(_holes.length);
      }
    }
    _activeHoleIndex = next;
    _activeTarget =
        _AmbushTarget.values[_rng.nextInt(_AmbushTarget.values.length)];
  }

  Offset _targetCenter() {
    final hole = _holes[_activeHoleIndex];
    return Offset(hole.dx, hole.dy - (10 + _peekProgress * 34));
  }

  void _onTap(Offset localPosition) {
    if (!_initialized ||
        _phase == _AmbushPhase.waiting ||
        _peekProgress < 0.35) {
      return;
    }

    final center = _targetCenter();
    final hitRadius = 52.0;
    final hit = (localPosition - center).distance <= hitRadius;
    if (!hit) return;

    _score++;
    _hitPulses.add(_HitPulse(center: center, age: 0, maxAge: 0.45));
    _spawnConfetti(center);
    if (widget.config.vibrationEnabled) {
      HapticFeedback.mediumImpact();
    }
    if (widget.config.soundEnabled) {
      SystemSound.play(SystemSoundType.click);
    }
    _startWaiting(quick: true);
  }

  void _spawnConfetti(Offset center) {
    const palette = <Color>[
      Color(0xFFFF7043),
      Color(0xFFFFCA28),
      Color(0xFFEC407A),
      Color(0xFF66BB6A),
      Color(0xFF29B6F6),
      Color(0xFFFF8A65),
    ];

    for (int i = 0; i < 18; i++) {
      final angle = _rng.nextDouble() * pi * 2;
      final speed = 95 + _rng.nextDouble() * 170;
      _confetti.add(
        _ConfettiParticle(
          position: center,
          velocity: Offset(cos(angle) * speed, sin(angle) * speed - 130),
          age: 0,
          maxAge: 0.55 + _rng.nextDouble() * 0.28,
          color: palette[_rng.nextInt(palette.length)],
          size: 4 + _rng.nextDouble() * 5,
          rotation: _rng.nextDouble() * pi * 2,
          spin: (_rng.nextDouble() - 0.5) * 12,
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
            painter: _HoleAmbushPainter(
              bounds: _bounds,
              holes: _holes,
              activeHoleIndex: _activeHoleIndex,
              activeTarget: _activeTarget,
              phase: _phase,
              peekProgress: _peekProgress,
              score: _score,
              hitPulses: _hitPulses,
              confetti: _confetti,
              overlayTop: overlayTop,
              overlaySize: overlaySize,
              overlayLeft: overlayLeft,
              scoreUnit: l10n.gameScoreUnit,
              hintText: l10n.gameHoleAmbushHint,
              mouseImage: _mouseImage,
              fishImage: _fishImage,
            ),
          ),
        );
      },
    );
  }
}

class _HoleAmbushPainter extends CustomPainter {
  final Rect bounds;
  final List<Offset> holes;
  final int activeHoleIndex;
  final _AmbushTarget activeTarget;
  final _AmbushPhase phase;
  final double peekProgress;
  final int score;
  final List<_HitPulse> hitPulses;
  final List<_ConfettiParticle> confetti;
  final double overlayTop;
  final double overlaySize;
  final double overlayLeft;
  final String scoreUnit;
  final String hintText;
  final ui.Image? mouseImage;
  final ui.Image? fishImage;

  _HoleAmbushPainter({
    required this.bounds,
    required this.holes,
    required this.activeHoleIndex,
    required this.activeTarget,
    required this.phase,
    required this.peekProgress,
    required this.score,
    required this.hitPulses,
    required this.confetti,
    required this.overlayTop,
    required this.overlaySize,
    required this.overlayLeft,
    required this.scoreUnit,
    required this.hintText,
    required this.mouseImage,
    required this.fishImage,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _paintBackground(canvas, size);
    _paintHoles(canvas);
    if (phase != _AmbushPhase.waiting) {
      _paintTarget(canvas, holes[activeHoleIndex], peekProgress, activeTarget);
    }
    _paintHitPulses(canvas);
    _paintConfetti(canvas);
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
          colors: [Color(0xFF5D4037), Color(0xFF3E2723), Color(0xFF2B1C13)],
        ).createShader(rect),
    );

    final linePaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.1)
      ..strokeWidth = 0.8;
    for (double y = size.height * 0.3; y < size.height; y += 28) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }
  }

  void _paintHoles(Canvas canvas) {
    final holePaint = Paint()..color = const Color(0xFF1C120D);
    final rimPaint = Paint()
      ..color = const Color(0xFF6D4C41).withValues(alpha: 0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (int i = 0; i < holes.length; i++) {
      final center = holes[i];
      final focus = i == activeHoleIndex && phase != _AmbushPhase.waiting;
      final width = focus ? 72.0 : 66.0;
      final height = focus ? 32.0 : 28.0;
      final rect = Rect.fromCenter(
        center: center,
        width: width,
        height: height,
      );
      canvas.drawOval(rect, holePaint);
      canvas.drawOval(rect, rimPaint);
      if (focus) {
        canvas.drawOval(
          Rect.fromCenter(center: center, width: width + 6, height: height + 4),
          Paint()
            ..color = const Color(0xFFFFB74D).withValues(alpha: 0.18)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
        );
      }
    }
  }

  void _paintTarget(
    Canvas canvas,
    Offset holeCenter,
    double peek,
    _AmbushTarget target,
  ) {
    final c = Offset(holeCenter.dx, holeCenter.dy - (10 + peek * 34));

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(c.dx, holeCenter.dy - 2),
        width: 34 + peek * 16,
        height: 12 + peek * 5,
      ),
      Paint()..color = Colors.black.withValues(alpha: 0.2),
    );

    switch (target) {
      case _AmbushTarget.mouse:
        _drawMouse(canvas, c, peek);
      case _AmbushTarget.fish:
        _drawFish(canvas, c, peek);
      case _AmbushTarget.feather:
        _drawFeather(canvas, c);
    }
  }

  void _drawMouse(Canvas canvas, Offset c, double peek) {
    if (mouseImage != null) {
      final scale = 0.94 + peek * 0.24;
      _drawSprite(
        canvas,
        c: Offset(c.dx, c.dy - 5),
        image: mouseImage!,
        width: 88 * scale,
        height: 88 * scale,
      );
      return;
    }

    final bodyPaint = Paint()..color = const Color(0xFFFFC48A);
    canvas.drawCircle(c, 13, bodyPaint);
    canvas.drawCircle(Offset(c.dx - 8, c.dy - 11), 5, bodyPaint);
    canvas.drawCircle(Offset(c.dx + 8, c.dy - 11), 5, bodyPaint);
    canvas.drawCircle(
      Offset(c.dx - 3, c.dy - 2),
      1.5,
      Paint()..color = Colors.black87,
    );
    canvas.drawCircle(
      Offset(c.dx + 3, c.dy - 2),
      1.5,
      Paint()..color = Colors.black87,
    );
    canvas.drawCircle(
      Offset(c.dx, c.dy + 3),
      1.2,
      Paint()..color = const Color(0xFF8D6E63),
    );
  }

  void _drawFish(Canvas canvas, Offset c, double peek) {
    if (fishImage != null) {
      final scale = 0.95 + peek * 0.24;
      _drawSprite(
        canvas,
        c: Offset(c.dx, c.dy - 4),
        image: fishImage!,
        width: 94 * scale,
        height: 84 * scale,
      );
      return;
    }

    final paint = Paint()..color = const Color(0xFF81D4FA);
    canvas.drawOval(Rect.fromCenter(center: c, width: 28, height: 16), paint);
    final tail = Path()
      ..moveTo(c.dx + 11, c.dy)
      ..lineTo(c.dx + 20, c.dy - 7)
      ..lineTo(c.dx + 20, c.dy + 7)
      ..close();
    canvas.drawPath(tail, paint);
    canvas.drawCircle(
      Offset(c.dx - 8, c.dy - 1),
      1.3,
      Paint()..color = Colors.black87,
    );
  }

  void _drawSprite(
    Canvas canvas, {
    required Offset c,
    required ui.Image image,
    required double width,
    required double height,
  }) {
    final src = Rect.fromLTWH(
      0,
      0,
      image.width.toDouble(),
      image.height.toDouble(),
    );
    final dst = Rect.fromCenter(center: c, width: width, height: height);
    canvas.drawImageRect(
      image,
      src,
      dst,
      Paint()..filterQuality = FilterQuality.high,
    );
  }

  void _drawFeather(Canvas canvas, Offset c) {
    final stemPaint = Paint()
      ..color = const Color(0xFFFFE082)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    final featherPaint = Paint()
      ..color = const Color(0xFFFFCC80)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(c.dx, c.dy - 14),
      Offset(c.dx, c.dy + 10),
      stemPaint,
    );
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(c.dx - 4, c.dy - 2),
        width: 18,
        height: 18,
      ),
      pi * 1.2,
      pi * 0.9,
      false,
      featherPaint,
    );
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(c.dx + 4, c.dy - 2),
        width: 18,
        height: 18,
      ),
      -pi * 0.1,
      pi * 0.9,
      false,
      featherPaint,
    );
  }

  void _paintHitPulses(Canvas canvas) {
    for (final pulse in hitPulses) {
      final t = (pulse.age / pulse.maxAge).clamp(0.0, 1.0);
      final r = 14 + t * 42;
      final alpha = (1 - t) * 0.55;
      canvas.drawCircle(
        pulse.center,
        18 + t * 16,
        Paint()..color = const Color(0xFFFFF176).withValues(alpha: alpha * 0.5),
      );
      canvas.drawCircle(
        pulse.center,
        r,
        Paint()
          ..color = const Color(0xFFFFB74D).withValues(alpha: alpha)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3 - t * 2,
      );
    }
  }

  void _paintConfetti(Canvas canvas) {
    for (int i = 0; i < confetti.length; i++) {
      final p = confetti[i];
      final t = (p.age / p.maxAge).clamp(0.0, 1.0);
      final alpha = 1 - t;
      canvas.save();
      canvas.translate(p.position.dx, p.position.dy);
      canvas.rotate(p.rotation);
      final paint = Paint()..color = p.color.withValues(alpha: alpha);
      if (i.isEven) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: Offset.zero,
              width: p.size,
              height: p.size * 0.65,
            ),
            const Radius.circular(2),
          ),
          paint,
        );
      } else {
        canvas.drawCircle(Offset.zero, p.size * 0.35, paint);
      }
      canvas.restore();
    }
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
  bool shouldRepaint(covariant _HoleAmbushPainter oldDelegate) => true;
}
