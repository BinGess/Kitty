import 'dart:math';
import 'package:flutter/material.dart';
import '../../data/models/game_item.dart';

class GameCard extends StatefulWidget {
  final GameMode mode;
  final VoidCallback onTap;

  const GameCard({
    super.key,
    required this.mode,
    required this.onTap,
  });

  @override
  State<GameCard> createState() => _GameCardState();
}

class _GameCardState extends State<GameCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mode = widget.mode;
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: 100,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: AnimatedBuilder(
          animation: _anim,
          builder: (context, child) {
            return CustomPaint(
              painter: _CardBgPainter(mode: mode, t: _anim.value),
              child: child,
            );
          },
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Text(
                mode.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: _titleColor(mode),
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _titleColor(GameMode mode) {
    switch (mode) {
      case GameMode.laser:
        return Colors.white;
      case GameMode.shadowPeek:
        return const Color(0xFF3E2723);
      case GameMode.catchMouse:
        return const Color(0xFF1A237E);
      case GameMode.rainbow:
        return Colors.white;
    }
  }
}

class _CardBgPainter extends CustomPainter {
  final GameMode mode;
  final double t;
  _CardBgPainter({required this.mode, required this.t});

  @override
  void paint(Canvas canvas, Size size) {
    switch (mode) {
      case GameMode.laser:
        _paintLaser(canvas, size);
      case GameMode.shadowPeek:
        _paintShadowPeek(canvas, size);
      case GameMode.catchMouse:
        _paintCatchFish(canvas, size);
      case GameMode.rainbow:
        _paintRainbow(canvas, size);
    }
  }

  void _paintLaser(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(
        rect, Paint()..color = const Color(0xFF1A1A2E));

    final rng = Random(7);
    final starPaint = Paint()..color = Colors.white.withValues(alpha: 0.15);
    for (int i = 0; i < 30; i++) {
      final dx = rng.nextDouble() * size.width;
      final dy = rng.nextDouble() * size.height;
      final twinkle = (sin(t * 2 * pi + i * 1.3) + 1) / 2;
      canvas.drawCircle(
          Offset(dx, dy), 0.8 + twinkle * 0.6, starPaint);
    }

    final cx = size.width * 0.25 + sin(t * 2 * pi) * size.width * 0.12;
    final cy = size.height * 0.5 + cos(t * 2 * pi * 1.3) * size.height * 0.2;
    final glow = Paint()
      ..color = Colors.red.withValues(alpha: 0.08)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30);
    canvas.drawCircle(Offset(cx, cy), 40, glow);

    for (int i = 5; i >= 0; i--) {
      final pt = (t - i * 0.015) % 1.0;
      final px = size.width * 0.25 + sin(pt * 2 * pi) * size.width * 0.12;
      final py = size.height * 0.5 + cos(pt * 2 * pi * 1.3) * size.height * 0.2;
      final a = (1.0 - i / 6) * 0.7;
      canvas.drawCircle(
          Offset(px, py), 5 - i * 0.5, Paint()..color = Colors.red.withValues(alpha: a));
    }

    canvas.drawCircle(
      Offset(cx, cy),
      6,
      Paint()..color = const Color(0xFFFF4444),
    );
    canvas.drawCircle(
      Offset(cx, cy),
      3,
      Paint()..color = Colors.white.withValues(alpha: 0.8),
    );
  }

  void _paintShadowPeek(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(rect, Paint()..color = const Color(0xFFDCE7C5));

    final grassDark = Paint()..color = const Color(0xFF6B8E23).withValues(alpha: 0.3);
    final grassLight = Paint()..color = const Color(0xFF8FBC3A).withValues(alpha: 0.25);
    final rng = Random(3);
    for (int i = 0; i < 20; i++) {
      final bx = rng.nextDouble() * size.width * 0.7;
      final by = size.height * 0.3 + rng.nextDouble() * size.height * 0.7;
      final h = 15.0 + rng.nextDouble() * 25;
      final sway = sin(t * 2 * pi + i * 0.8) * 3;
      final p = Path()
        ..moveTo(bx - 3, by)
        ..quadraticBezierTo(bx + sway, by - h, bx + 1, by - h + 2)
        ..quadraticBezierTo(bx + sway + 2, by - h * 0.5, bx + 4, by);
      canvas.drawPath(p, i % 2 == 0 ? grassDark : grassLight);
    }

    final boxPaint = Paint()..color = const Color(0xFFC9A96E);
    final boxDark = Paint()..color = const Color(0xFFB08B55);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromLTWH(size.width * 0.08, size.height * 0.45, 50, 40),
          const Radius.circular(4)),
      boxPaint,
    );
    canvas.drawLine(Offset(size.width * 0.08, size.height * 0.45 + 20),
        Offset(size.width * 0.08 + 50, size.height * 0.45 + 20), boxDark);

    final peek = (sin(t * 2 * pi * 0.8) + 1) / 2;
    if (peek > 0.4) {
      final eyeY = size.height * 0.42;
      final eyeX = size.width * 0.08 + 36;
      final eyePaint = Paint()..color = Colors.black.withValues(alpha: (peek - 0.4) * 1.2);
      canvas.drawOval(Rect.fromCenter(center: Offset(eyeX, eyeY), width: 5, height: 6), eyePaint);
      canvas.drawOval(Rect.fromCenter(center: Offset(eyeX + 10, eyeY), width: 5, height: 6), eyePaint);
    }
  }

  void _paintCatchFish(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(rect,
        Paint()
          ..shader = const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF87CEEB), Color(0xFF4FC3F7), Color(0xFF0288D1)],
          ).createShader(rect));

    final wavePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..style = PaintingStyle.fill;
    for (int w = 0; w < 3; w++) {
      final path = Path();
      final yBase = size.height * (0.3 + w * 0.25);
      path.moveTo(0, yBase);
      for (double x = 0; x <= size.width; x += 2) {
        path.lineTo(
            x, yBase + sin(t * 2 * pi + x / 40 + w * 1.2) * 5);
      }
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.close();
      canvas.drawPath(path, wavePaint);
    }

    final fx = size.width * 0.3 + sin(t * 2 * pi * 0.7) * 30;
    final fy = size.height * 0.5 + cos(t * 2 * pi * 0.5) * 12;
    _drawFish(canvas, Offset(fx, fy), 18, const Color(0xFFFF9800));

    final fx2 = size.width * 0.55 + cos(t * 2 * pi * 0.5 + 1) * 20;
    final fy2 = size.height * 0.35 + sin(t * 2 * pi * 0.6 + 2) * 10;
    _drawFish(canvas, Offset(fx2, fy2), 12, const Color(0xFFE91E63));

    final rng = Random(5);
    for (int i = 0; i < 6; i++) {
      final bx = rng.nextDouble() * size.width * 0.6;
      final by = size.height * 0.2 + rng.nextDouble() * size.height * 0.6;
      final rise = (t * 30 + i * 20) % size.height;
      canvas.drawCircle(
        Offset(bx, by - rise * 0.3),
        1.5 + rng.nextDouble() * 1.5,
        Paint()..color = Colors.white.withValues(alpha: 0.2),
      );
    }
  }

  void _drawFish(Canvas canvas, Offset c, double s, Color color) {
    final body = Paint()..color = color;
    canvas.drawOval(
        Rect.fromCenter(center: c, width: s * 2, height: s), body);

    final tail = Path()
      ..moveTo(c.dx + s * 0.8, c.dy)
      ..lineTo(c.dx + s * 1.5, c.dy - s * 0.5)
      ..lineTo(c.dx + s * 1.5, c.dy + s * 0.5)
      ..close();
    canvas.drawPath(tail, body);

    canvas.drawCircle(
      Offset(c.dx - s * 0.5, c.dy - s * 0.15),
      s * 0.12,
      Paint()..color = Colors.white,
    );
  }

  void _paintRainbow(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(rect, Paint()..color = const Color(0xFF1A1A3E));

    const colors = [
      Color(0xFFFF0000),
      Color(0xFFFF7700),
      Color(0xFFFFFF00),
      Color(0xFF00FF00),
      Color(0xFF0077FF),
      Color(0xFF8800FF),
    ];

    for (int i = 0; i < colors.length; i++) {
      final yBase = size.height * (0.18 + i * 0.12);
      final phase = t * 2 * pi + i * 0.6;
      final path = Path();
      path.moveTo(0, yBase + sin(phase) * 8);
      for (double x = 0; x <= size.width; x += 3) {
        path.lineTo(x, yBase + sin(phase + x / size.width * 3 * pi) * 8);
      }
      canvas.drawPath(
        path,
        Paint()
          ..color = colors[i].withValues(alpha: 0.6)
          ..strokeWidth = 4
          ..style = PaintingStyle.stroke
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
      );
      canvas.drawPath(
        path,
        Paint()
          ..color = colors[i].withValues(alpha: 0.9)
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke,
      );
    }

    final rng = Random(9);
    for (int i = 0; i < 8; i++) {
      final dx = rng.nextDouble() * size.width;
      final dy = rng.nextDouble() * size.height;
      final twinkle = (sin(t * 2 * pi * 1.5 + i) + 1) / 2;
      canvas.drawCircle(
        Offset(dx, dy),
        1.5,
        Paint()..color = colors[i % colors.length].withValues(alpha: twinkle * 0.5),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CardBgPainter old) => old.t != t;
}
