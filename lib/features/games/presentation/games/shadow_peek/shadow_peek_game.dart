import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart';
import '../../../domain/game_config.dart';
import '../../../../../core/l10n/app_localizations.dart';
import 'shadow_peek_logic.dart';

/// 影子藏猫猫（精美重绘版）
/// - 月色星空主题
/// - 多层次灌木花丛 + 可爱礼盒掩体
/// - 红衣小鸟 + 瓢虫（替换蛇）
/// - 星光粒子爆发
class ShadowPeekGame extends StatefulWidget {
  final GameConfig config;

  const ShadowPeekGame({super.key, required this.config});

  @override
  State<ShadowPeekGame> createState() => _ShadowPeekGameState();
}

class _ShadowPeekGameState extends State<ShadowPeekGame> {
  ShadowPeekLogic? _logic;
  double _lastTime = 0;

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

      final logic = _logic;
      if (logic != null && logic.update(deltaMs)) {
        setState(() {});
      }
      _scheduleFrame();
    });
  }

  void _initLogic(Size size) {
    if (size.width <= 0 || size.height <= 0) return;
    _logic = ShadowPeekLogic(
      bounds: Offset.zero & size,
      rng: Random(),
      frequencyFactor: 0.5 + widget.config.speed,
      onPeekStarted: widget.config.soundEnabled
          ? () => SystemSound.play(SystemSoundType.click)
          : null,
    );
    _logic!.reset();
  }

  void _onTap(Offset localPosition) {
    final logic = _logic;
    if (logic == null) return;

    final hit = logic.tapShelter(localPosition);
    if (hit) {
      if (widget.config.vibrationEnabled) HapticFeedback.mediumImpact();
      if (widget.config.soundEnabled) SystemSound.play(SystemSoundType.click);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final l10n = AppLocalizations.of(context)!;
        final size = constraints.biggest;
        final overlayTop = MediaQuery.of(context).padding.top + 12;
        const overlaySize = 48.0;
        const overlayLeft = 12.0;
        if (size.width > 0 && size.height > 0) {
          if (_logic == null || _logic!.bounds.size != size) {
            _initLogic(size);
          }
        }
        if (_logic == null) return const SizedBox.expand();
        return Listener(
          behavior: HitTestBehavior.opaque,
          onPointerDown: (e) => _onTap(e.localPosition),
          child: CustomPaint(
            size: Size(constraints.maxWidth, constraints.maxHeight),
            painter: _ShadowPeekPainter(
              logic: _logic!,
              scoreUnit: l10n.gameScoreUnit,
              hintText: l10n.gameShadowPeekHint,
              overlayTop: overlayTop,
              overlaySize: overlaySize,
              overlayLeft: overlayLeft,
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Painter
// ─────────────────────────────────────────────────────────────────────────────

class _ShadowPeekPainter extends CustomPainter {
  final ShadowPeekLogic logic;
  final String scoreUnit;
  final String hintText;
  final double overlayTop;
  final double overlaySize;
  final double overlayLeft;

  _ShadowPeekPainter({
    required this.logic,
    required this.scoreUnit,
    required this.hintText,
    required this.overlayTop,
    required this.overlaySize,
    required this.overlayLeft,
  });

  // ── Palette ────────────────────────────────────────────────────────────────
  static const _skyTop    = Color(0xFF0B0720);
  static const _skyMid    = Color(0xFF141050);
  static const _skyBot    = Color(0xFF0E2248);
  static const _gndTop    = Color(0xFF0D3318);
  static const _gndBot    = Color(0xFF061209);
  static const _moonColor = Color(0xFFFFF6DC);
  // bush
  static const _bushBack  = Color(0xFF155220);
  static const _bushMid   = Color(0xFF237A30);
  static const _bushFront = Color(0xFF35B048);
  static const _bushHi    = Color(0xFF58D460);
  static const _flowerPink= Color(0xFFEC407A);
  static const _flowerLt  = Color(0xFFF8BBD0);
  static const _flowerYlw = Color(0xFFFFD54F);
  // box
  static const _boxLight  = Color(0xFFEFCB74);
  static const _boxBase   = Color(0xFFD4A84B);
  static const _boxEdge   = Color(0xFF8B6510);
  static const _pawInk    = Color(0xFF6B3F08);

  // ── Entry ──────────────────────────────────────────────────────────────────
  @override
  void paint(Canvas canvas, Size size) {
    final b = logic.bounds;

    _paintBackground(canvas, b);
    _paintGround(canvas, b);

    for (int i = 0; i < logic.shelters.length; i++) {
      final shaking =
          logic.shakingShelterIndex == i && logic.shakeProgress < 1.0;
      _paintShelter(canvas, logic.shelters[i], i, shaking);
    }

    if (logic.creatureVisible) {
      _paintCreature(
        canvas, logic.creatureType,
        logic.creaturePeekRect, logic.creaturePeekProgress,
      );
    }

    if (logic.isEscaping) {
      _paintEscapingCreature(
        canvas, logic.creatureType,
        logic.escapeFrom, logic.escapeTo, logic.escapeProgress,
      );
    }

    _paintParticles(canvas);
    _paintScore(canvas, size);

    if (!logic.creatureVisible && !logic.isEscaping && logic.score == 0) {
      _paintHint(canvas, b);
    }
  }

  // ── Background ─────────────────────────────────────────────────────────────

  void _paintBackground(Canvas canvas, Rect b) {
    // Sky gradient
    canvas.drawRect(
      b,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: const [_skyTop, _skyMid, _skyBot],
          stops: const [0.0, 0.45, 1.0],
        ).createShader(b),
    );

    // Moon
    _paintMoon(canvas, Offset(b.width * 0.80, b.height * 0.16));

    // Stars
    _paintStars(canvas, b);

    // Horizon tree silhouettes
    _paintTrees(canvas, b);
  }

  void _paintMoon(Canvas canvas, Offset c) {
    // Outer halo layers
    for (final pair in [
      (90.0, 0.03), (58.0, 0.08), (36.0, 0.18),
    ]) {
      canvas.drawCircle(
        c, pair.$1,
        Paint()
          ..color = _moonColor.withValues(alpha: pair.$2)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, pair.$1 * 0.4),
      );
    }
    // Disc
    canvas.drawCircle(c, 24, Paint()..color = _moonColor);
    // Craters
    final cp = Paint()..color = const Color(0xFFE0CC90).withValues(alpha: 0.45);
    canvas.drawCircle(Offset(c.dx - 7, c.dy + 5), 4.5, cp);
    canvas.drawCircle(Offset(c.dx + 9, c.dy - 7), 3.0, cp);
    canvas.drawCircle(Offset(c.dx + 2, c.dy + 10), 3.5, cp);
    // Rim highlight
    canvas.drawArc(
      Rect.fromCircle(center: c, radius: 23),
      -pi * 0.85, pi * 0.4,
      false,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.35)
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke,
    );
  }

  void _paintStars(Canvas canvas, Rect b) {
    final rng = Random(42);
    final t = logic.globalTime;
    for (int i = 0; i < 50; i++) {
      final x = rng.nextDouble() * b.width;
      final y = rng.nextDouble() * b.height * 0.58;
      final tw = sin(t / 850 + i * 2.1) * 0.5 + 0.5;
      final alpha = 0.30 + tw * 0.70;
      final sz = 0.7 + rng.nextDouble() * 1.9;

      canvas.drawCircle(
        Offset(x, y), sz,
        Paint()..color = Colors.white.withValues(alpha: alpha),
      );

      // Cross-glint for larger stars
      if (sz > 2.0) {
        final sp = Paint()
          ..color = Colors.white.withValues(alpha: alpha * 0.55)
          ..strokeWidth = 0.7
          ..style = PaintingStyle.stroke;
        final arm = sz * 2.2;
        canvas.drawLine(Offset(x - arm, y), Offset(x + arm, y), sp);
        canvas.drawLine(Offset(x, y - arm), Offset(x, y + arm), sp);
      }
    }
  }

  void _paintTrees(Canvas canvas, Rect b) {
    final groundLine = b.height * 0.52;
    final tp = Paint()..color = const Color(0xFF09190C);
    final rng = Random(77);
    for (int i = 0; i < 7; i++) {
      final x = b.width * (0.05 + i * 0.14) + rng.nextDouble() * 18 - 9;
      final h = 55.0 + rng.nextDouble() * 45;
      final w = 20.0 + rng.nextDouble() * 18;
      // Trunk
      canvas.drawRect(
        Rect.fromLTWH(x - 3, groundLine - h * 0.28, 6, h * 0.32), tp);
      // Layered canopy
      for (int j = 0; j < 3; j++) {
        final cH = h * (0.44 - j * 0.10);
        final cW = w * (1.0 - j * 0.22);
        final baseY = groundLine - h * 0.22 - j * h * 0.18;
        final cp = Path()
          ..moveTo(x, baseY - cH)
          ..lineTo(x - cW / 2, baseY)
          ..lineTo(x + cW / 2, baseY)
          ..close();
        canvas.drawPath(cp, tp);
      }
    }
  }

  // ── Ground ─────────────────────────────────────────────────────────────────

  void _paintGround(Canvas canvas, Rect b) {
    final gt = b.height * 0.52;
    final gr = Rect.fromLTWH(0, gt, b.width, b.height - gt);

    canvas.drawRect(
      gr,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: const [_gndTop, _gndBot],
        ).createShader(gr),
    );

    // Bright edge strip
    canvas.drawRect(
      Rect.fromLTWH(0, gt, b.width, 3),
      Paint()..color = const Color(0xFF3DB54A).withValues(alpha: 0.55),
    );

    // Subtle texture dots
    final dp = Paint()..color = const Color(0xFF1C6A30).withValues(alpha: 0.30);
    final rng = Random(99);
    for (int i = 0; i < 70; i++) {
      final x = rng.nextDouble() * b.width;
      final y = gt + rng.nextDouble() * (b.height - gt) * 0.65;
      canvas.drawCircle(
        Offset(x, y), 1.0 + rng.nextDouble() * 2.2, dp);
    }
  }

  // ── Shelters ───────────────────────────────────────────────────────────────

  void _paintShelter(
    Canvas canvas, Shelter shelter, int index, bool isShaking) {
    canvas.save();
    if (isShaking) {
      final dx =
          sin(logic.shakeProgress * pi * 7) * 5 * (1 - logic.shakeProgress);
      canvas.translate(dx, 0);
    }
    if (shelter.type == ShelterType.grass) {
      _paintBush(canvas, shelter.rect, index);
    } else {
      _paintBox(canvas, shelter.rect, index);
    }
    canvas.restore();
  }

  // ─── Bush shelter ───────────────────────────────────────────────────────

  void _paintBush(Canvas canvas, Rect r, int index) {
    final sway = sin(logic.globalTime / 2400 + index * 1.7) * 3.5;

    // Drop shadow
    canvas.drawOval(
      Rect.fromLTWH(r.left + 10, r.bottom - 14, r.width - 20, 20),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.38)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
    );

    // Back layer
    canvas.save();
    canvas.translate(sway * 0.25, 0);
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(
            r.left - 10, r.top + r.height * 0.18,
            r.width + 20, r.height * 0.84),
        topLeft: const Radius.circular(64),
        topRight: const Radius.circular(64),
        bottomLeft: const Radius.circular(20),
        bottomRight: const Radius.circular(20),
      ),
      Paint()..color = _bushBack,
    );
    canvas.restore();

    // Mid layer
    canvas.save();
    canvas.translate(sway * 0.55, 0);
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(
            r.left - 3, r.top + r.height * 0.10,
            r.width + 6, r.height * 0.88),
        topLeft: const Radius.circular(52),
        topRight: const Radius.circular(52),
        bottomLeft: const Radius.circular(16),
        bottomRight: const Radius.circular(16),
      ),
      Paint()..color = _bushMid,
    );
    canvas.restore();

    // Front layer with vertical gradient
    canvas.save();
    canvas.translate(sway, 0);
    final fr = Rect.fromLTWH(
        r.left + r.width * 0.04, r.top,
        r.width * 0.92, r.height * 0.88);
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        fr,
        topLeft: const Radius.circular(44),
        topRight: const Radius.circular(44),
        bottomLeft: const Radius.circular(12),
        bottomRight: const Radius.circular(12),
      ),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: const [_bushHi, _bushFront, _bushMid],
          stops: const [0.0, 0.4, 1.0],
        ).createShader(fr),
    );
    canvas.restore();

    // Leaf highlights
    final lp = Paint()
      ..color = _bushHi.withValues(alpha: 0.45)
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final rngL = Random(index * 31 + 7);
    for (int i = 0; i < 5; i++) {
      final lx = r.left + r.width * (0.12 + i * 0.17) + sway * 0.6;
      final ly = r.top + r.height * (0.22 + rngL.nextDouble() * 0.22);
      final lw = 9.0 + rngL.nextDouble() * 7;
      canvas.drawOval(
        Rect.fromCenter(center: Offset(lx, ly), width: lw, height: lw * 0.48),
        lp,
      );
    }

    // Flowers on top
    final rngF = Random(index * 53 + 3);
    for (int i = 0; i < 5; i++) {
      final fx = r.left + r.width * (0.10 + i * 0.19) +
          rngF.nextDouble() * 10 - 5 + sway * 1.1;
      final fy = r.top - 5 + rngF.nextDouble() * 9;
      _drawFlower(canvas, Offset(fx, fy), 5.5 + rngF.nextDouble() * 3);
    }
  }

  void _drawFlower(Canvas canvas, Offset c, double sz) {
    // Outer petals
    final p1 = Paint()..color = _flowerPink;
    for (int i = 0; i < 6; i++) {
      final a = i * pi / 3;
      canvas.drawCircle(
          Offset(c.dx + cos(a) * sz * 0.88, c.dy + sin(a) * sz * 0.88),
          sz * 0.52, p1);
    }
    // Inner petals
    final p2 = Paint()..color = _flowerLt;
    for (int i = 0; i < 6; i++) {
      final a = i * pi / 3 + pi / 6;
      canvas.drawCircle(
          Offset(c.dx + cos(a) * sz * 0.65, c.dy + sin(a) * sz * 0.65),
          sz * 0.32, p2);
    }
    // Centre
    canvas.drawCircle(c, sz * 0.48, Paint()..color = _flowerYlw);
    canvas.drawCircle(
        c, sz * 0.24, Paint()..color = Colors.white.withValues(alpha: 0.75));
  }

  // ─── Box shelter ────────────────────────────────────────────────────────

  void _paintBox(Canvas canvas, Rect r, int index) {
    // Drop shadow
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(r.left + 5, r.bottom - 10, r.width - 10, 16),
        const Radius.circular(8),
      ),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.42)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );

    // Main body
    canvas.drawRRect(
      RRect.fromRectAndRadius(r, const Radius.circular(8)),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: const [_boxLight, _boxBase, Color(0xFFBA8E30)],
          stops: const [0.0, 0.55, 1.0],
        ).createShader(r),
    );

    // Left shading band (3-D depth)
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(r.left, r.top, r.width * 0.09, r.height),
        topLeft: const Radius.circular(8),
        bottomLeft: const Radius.circular(8),
      ),
      Paint()..color = _boxEdge.withValues(alpha: 0.30),
    );

    // Horizontal crease
    canvas.drawLine(
      Offset(r.left + 3, r.top + r.height * 0.48),
      Offset(r.right - 3, r.top + r.height * 0.48),
      Paint()
        ..color = _boxEdge.withValues(alpha: 0.38)
        ..strokeWidth = 1.5,
    );

    // Vertical crease
    canvas.drawLine(
      Offset(r.center.dx, r.top + 4),
      Offset(r.center.dx, r.bottom - 4),
      Paint()
        ..color = _boxEdge.withValues(alpha: 0.22)
        ..strokeWidth = 1.0,
    );

    // Top flaps
    final flapBezBase = r.top - r.height * 0.09;
    final flapL = Path()
      ..moveTo(r.left, r.top)
      ..lineTo(r.center.dx - 3, r.top)
      ..lineTo(r.center.dx - 6, flapBezBase)
      ..lineTo(r.left, flapBezBase + 4)
      ..close();
    canvas.drawPath(flapL, Paint()..color = _boxBase.withValues(alpha: 0.88));

    final flapR = Path()
      ..moveTo(r.center.dx + 3, r.top)
      ..lineTo(r.right, r.top)
      ..lineTo(r.right, flapBezBase + 4)
      ..lineTo(r.center.dx + 6, flapBezBase)
      ..close();
    canvas.drawPath(flapR, Paint()..color = _boxLight.withValues(alpha: 0.88));

    // Outline
    canvas.drawRRect(
      RRect.fromRectAndRadius(r, const Radius.circular(8)),
      Paint()
        ..color = _boxEdge.withValues(alpha: 0.65)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8,
    );

    // Cat paw print (right side)
    _drawPaw(canvas,
        Offset(r.left + r.width * 0.70, r.top + r.height * 0.60),
        r.width * 0.115);

    // "?" question mark (left side, subtle)
    final qp = TextPainter(
      text: TextSpan(
        text: '?',
        style: TextStyle(
          color: _boxEdge.withValues(alpha: 0.40),
          fontSize: r.height * 0.30,
          fontWeight: FontWeight.w900,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    qp.layout();
    qp.paint(canvas,
        Offset(r.left + r.width * 0.24 - qp.width / 2,
            r.top + r.height * 0.50 - qp.height / 2));
  }

  void _drawPaw(Canvas canvas, Offset c, double sz) {
    final p = Paint()..color = _pawInk.withValues(alpha: 0.32);
    // Palm
    canvas.drawOval(
        Rect.fromCenter(center: c, width: sz * 1.25, height: sz), p);
    // Toes
    for (final off in [
      Offset(-sz * 0.68, -sz * 0.72),
      Offset(0, -sz * 0.94),
      Offset(sz * 0.68, -sz * 0.72),
    ]) {
      canvas.drawCircle(c + off, sz * 0.33, p);
    }
  }

  // ── Creatures ──────────────────────────────────────────────────────────────

  void _paintCreature(
    Canvas canvas, CreatureType type, Rect rect, double progress) {
    if (progress <= 0) return;
    canvas.save();
    canvas.clipRect(rect);
    if (type == CreatureType.bird) {
      _drawBird(canvas, rect, progress);
    } else {
      _drawLadybug(canvas, rect, progress);
    }
    canvas.restore();
  }

  // ─── Bird (red cardinal) ────────────────────────────────────────────────

  void _drawBird(Canvas canvas, Rect rect, double progress) {
    final cx = rect.center.dx;
    final cy = rect.bottom - 22;
    final s = progress.clamp(0.0, 1.0);
    if (s <= 0) return;

    // Body
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(cx, cy), width: 36 * s, height: 30 * s),
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.25, -0.35),
          colors: const [Color(0xFFFF7043), Color(0xFFE53935)],
        ).createShader(
            Rect.fromCenter(center: Offset(cx, cy), width: 44 * s, height: 44 * s)),
    );

    if (s > 0.35) {
      // Wings
      for (final side in [-1, 1]) {
        final wp = Path()
          ..moveTo(cx + side * 12 * s, cy)
          ..quadraticBezierTo(
              cx + side * 28 * s, cy - 14 * s,
              cx + side * 22 * s, cy + 9 * s)
          ..close();
        canvas.drawPath(wp, Paint()..color = const Color(0xFFC62828));
      }

      // Belly highlight
      canvas.drawOval(
        Rect.fromCenter(
            center: Offset(cx, cy + 5 * s),
            width: 16 * s, height: 10 * s),
        Paint()..color = const Color(0xFFFFCDD2).withValues(alpha: 0.35),
      );

      // Crest (3 spiky points)
      final crPaint = Paint()..color = const Color(0xFFBD0B0B);
      for (int i = 0; i < 3; i++) {
        final cx2 = cx + (i - 1) * 5.5 * s;
        final crH = (14 - i * 2) * s;
        final cp = Path()
          ..moveTo(cx2, cy - 12 * s - crH)
          ..lineTo(cx2 - 3.5 * s, cy - 11 * s)
          ..lineTo(cx2 + 3.5 * s, cy - 11 * s)
          ..close();
        canvas.drawPath(cp, crPaint);
      }

      // Eyes
      for (final side in [-1, 1]) {
        final ex = cx + side * 5.5 * s;
        final ey = cy - 5.5 * s;
        canvas.drawCircle(Offset(ex, ey), 4.8 * s, Paint()..color = Colors.white);
        canvas.drawCircle(Offset(ex, ey), 3.2 * s,
            Paint()..color = const Color(0xFF1A1A1A));
        // Highlight
        canvas.drawCircle(
            Offset(ex - 1.4 * s, ey - 1.6 * s), 1.3 * s,
            Paint()..color = Colors.white);
      }

      // Beak
      final bp = Path()
        ..moveTo(cx - 5 * s, cy + 0.5 * s)
        ..lineTo(cx + 5 * s, cy + 0.5 * s)
        ..lineTo(cx, cy + 7 * s)
        ..close();
      canvas.drawPath(bp, Paint()..color = const Color(0xFFFFAA00));
      canvas.drawLine(
        Offset(cx - 4 * s, cy + 1.5 * s),
        Offset(cx + 4 * s, cy + 1.5 * s),
        Paint()
          ..color = const Color(0xFFFFCC44)
          ..strokeWidth = 1.4,
      );
    }
  }

  // ─── Ladybug ────────────────────────────────────────────────────────────

  void _drawLadybug(Canvas canvas, Rect rect, double progress) {
    final cx = rect.center.dx;
    final cy = rect.bottom - 20;
    final s = progress.clamp(0.0, 1.0);
    if (s <= 0) return;

    // Ground shadow
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(cx, cy + 7 * s), width: 30 * s, height: 10 * s),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.22)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
    );

    // Shell
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(cx, cy), width: 32 * s, height: 26 * s),
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.3, -0.45),
          colors: const [Color(0xFFFF5252), Color(0xFFD32F2F)],
        ).createShader(
            Rect.fromCenter(center: Offset(cx, cy), width: 38 * s, height: 38 * s)),
    );

    // Shell gloss
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(cx - 5 * s, cy - 5 * s),
          width: 11 * s, height: 7.5 * s),
      Paint()..color = Colors.white.withValues(alpha: 0.38),
    );

    // Centre divide line
    canvas.drawLine(
      Offset(cx, cy - 13 * s),
      Offset(cx, cy + 13 * s),
      Paint()
        ..color = const Color(0xFFB71C1C)
        ..strokeWidth = 1.8 * s,
    );

    // Spots
    final sp = Paint()..color = const Color(0xFF1A1A1A);
    for (final off in [
      Offset(-7 * s, -4 * s),
      Offset(7 * s, -4 * s),
      Offset(-7 * s, 5 * s),
      Offset(7 * s, 5 * s),
      Offset(-3 * s, -9 * s),
      Offset(3 * s, -9 * s),
    ]) {
      canvas.drawCircle(Offset(cx, cy) + off, 2.8 * s, sp);
    }

    if (s > 0.35) {
      // Head
      canvas.drawCircle(
          Offset(cx, cy - 13 * s), 7.5 * s,
          Paint()..color = const Color(0xFF1A1A1A));

      // Eyes
      for (final side in [-1, 1]) {
        final ex = cx + side * 3.8 * s;
        final ey = cy - 15.5 * s;
        canvas.drawCircle(Offset(ex, ey), 2.5 * s, Paint()..color = Colors.white);
        canvas.drawCircle(Offset(ex, ey), 1.3 * s,
            Paint()..color = const Color(0xFF1A1A1A));
        canvas.drawCircle(
            Offset(ex - 0.7 * s, ey - 0.8 * s), 0.6 * s,
            Paint()..color = Colors.white);
      }

      // Antennae
      final ap = Paint()
        ..color = const Color(0xFF1A1A1A)
        ..strokeWidth = 1.6 * s
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(
          Offset(cx - 2.5 * s, cy - 19 * s),
          Offset(cx - 9 * s, cy - 28 * s), ap);
      canvas.drawLine(
          Offset(cx + 2.5 * s, cy - 19 * s),
          Offset(cx + 9 * s, cy - 28 * s), ap);
      // Tips
      canvas.drawCircle(
          Offset(cx - 9 * s, cy - 28 * s), 2.2 * s,
          Paint()..color = const Color(0xFF1A1A1A));
      canvas.drawCircle(
          Offset(cx + 9 * s, cy - 28 * s), 2.2 * s,
          Paint()..color = const Color(0xFF1A1A1A));

      // Legs
      final lp = Paint()
        ..color = const Color(0xFF1A1A1A).withValues(alpha: 0.65)
        ..strokeWidth = 1.3 * s
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
      for (int i = 0; i < 3; i++) {
        final ly = cy - 2 * s + i * 5.5 * s;
        canvas.drawLine(
            Offset(cx - 16 * s, ly), Offset(cx - 9 * s, ly - 3 * s), lp);
        canvas.drawLine(
            Offset(cx + 16 * s, ly), Offset(cx + 9 * s, ly - 3 * s), lp);
      }
    }
  }

  // ── Escape animation ───────────────────────────────────────────────────────

  void _paintEscapingCreature(
    Canvas canvas, CreatureType type,
    Rect from, Rect to, double progress,
  ) {
    final t = Curves.easeInOutCubic.transform(progress.clamp(0.0, 1.0));
    final x = from.center.dx + (to.center.dx - from.center.dx) * t;
    final y = from.center.dy + (to.center.dy - from.center.dy) * t;
    final arc = sin(t * pi) * -55;
    final rect =
        Rect.fromCenter(center: Offset(x, y + arc), width: 56, height: 56);

    // Motion ghost
    if (t > 0.08 && t < 0.92) {
      final tc = type == CreatureType.bird
          ? const Color(0xFFE53935)
          : const Color(0xFFD32F2F);
      canvas.drawCircle(
        Offset(x - (to.center.dx - from.center.dx) * 0.06, y + arc),
        15,
        Paint()..color = tc.withValues(alpha: 0.22),
      );
    }

    if (type == CreatureType.bird) {
      _drawBird(canvas, rect, 1.0);
    } else {
      _drawLadybug(canvas, rect, 1.0);
    }
  }

  // ── Particles ──────────────────────────────────────────────────────────────

  void _paintParticles(Canvas canvas) {
    for (final p in logic.particles) {
      final life = p.life.clamp(0.0, 1.0);
      final sz = p.size * life;
      canvas.save();
      canvas.translate(p.x, p.y);
      canvas.rotate(p.vx * 0.55);

      // 4-pointed sparkle
      final sp = Paint()
        ..color = p.color.withValues(alpha: life)
        ..strokeWidth = sz * 0.48
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(Offset(-sz, 0), Offset(sz, 0), sp);
      canvas.drawLine(Offset(0, -sz), Offset(0, sz), sp);
      final d = sz * 0.58;
      canvas.drawLine(Offset(-d, -d), Offset(d, d), sp);
      canvas.drawLine(Offset(d, -d), Offset(-d, d), sp);

      // Bright center dot
      canvas.drawCircle(
          Offset.zero, sz * 0.22,
          Paint()..color = Colors.white.withValues(alpha: life * 0.8));

      canvas.restore();
    }
  }

  // ── HUD ────────────────────────────────────────────────────────────────────

  void _paintScore(Canvas canvas, Size size) {
    final tp = TextPainter(
      text: TextSpan(children: [
        TextSpan(
          text: '${logic.score}',
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
      ]),
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    tp.paint(
      canvas,
      Offset(overlayLeft, overlayTop + (overlaySize - tp.height) / 2),
    );
  }

  void _paintHint(Canvas canvas, Rect bounds) {
    final tp = TextPainter(
      text: TextSpan(
        text: hintText,
        style: TextStyle(
            color: Colors.white.withValues(alpha: 0.42), fontSize: 14),
      ),
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    tp.paint(
      canvas,
      Offset(bounds.center.dx - tp.width / 2, bounds.height * 0.48),
    );
  }

  @override
  bool shouldRepaint(covariant _ShadowPeekPainter oldDelegate) => true;
}
