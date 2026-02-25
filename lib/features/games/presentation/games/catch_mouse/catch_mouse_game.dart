import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart';
import '../../../domain/game_config.dart';
import 'catch_mouse_logic.dart';

/// 捕鼠/捕鱼大战（增强版）
/// - 木地板纹理背景
/// - 生物移动拖尾
/// - 生物底部阴影和光晕
/// - 多层粒子效果（星星、火花）
/// - 分数显示
/// - 重生进度条
class CatchMouseGame extends StatefulWidget {
  final GameConfig config;

  const CatchMouseGame({super.key, required this.config});

  @override
  State<CatchMouseGame> createState() => _CatchMouseGameState();
}

class _CatchMouseGameState extends State<CatchMouseGame> {
  CatchMouseLogic? _logic;
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
    _logic = CatchMouseLogic(
      bounds: Offset.zero & size,
      rng: Random(),
      speedFactor: 0.5 + widget.config.speed,
    );
    _logic!.reset();
  }

  void _onTap(Offset localPosition) {
    final logic = _logic;
    if (logic == null) return;

    final hit = logic.tapCreature(localPosition);
    if (hit) {
      if (widget.config.vibrationEnabled) {
        HapticFeedback.mediumImpact();
      }
      if (widget.config.soundEnabled) {
        SystemSound.play(SystemSoundType.click);
      }
      setState(() {});
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
        if (size.width > 0 && size.height > 0) {
          if (_logic == null || _logic!.bounds.size != size) {
            _initLogic(size);
          }
        }
        if (_logic == null) {
          return const SizedBox.expand();
        }
        return Listener(
          behavior: HitTestBehavior.opaque,
          onPointerDown: (e) => _onTap(e.localPosition),
          child: CustomPaint(
            size: Size(constraints.maxWidth, constraints.maxHeight),
            painter: _CatchMousePainter(
              logic: _logic!,
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

class _CatchMousePainter extends CustomPainter {
  final CatchMouseLogic logic;
  final double overlayTop;
  final double overlaySize;
  final double overlayLeft;

  _CatchMousePainter({
    required this.logic,
    required this.overlayTop,
    required this.overlaySize,
    required this.overlayLeft,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = logic.bounds;

    // 1. 背景
    _paintBackground(canvas, bounds);

    // 2. 移动拖尾
    _paintTrail(canvas);

    // 3. 粒子特效（捕获时）
    _paintParticles(canvas);

    // 4. 生物阴影
    if (logic.visible) {
      _paintCreatureShadow(canvas, Offset(logic.x, logic.y));
    }

    // 5. 生物
    if (logic.visible) {
      _paintCreature(canvas, Offset(logic.x, logic.y));
    }

    // 6. 刷新等待
    if (logic.isRespawning && logic.particles.isEmpty) {
      _paintRespawnIndicator(canvas, bounds);
    }

    // 7. 分数
    _paintScore(canvas, size);
  }

  void _paintBackground(Canvas canvas, Rect bounds) {
    // 深色木地板
    final bgPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFF1A1208),
          const Color(0xFF0F0A05),
          const Color(0xFF1A1208),
        ],
      ).createShader(bounds);
    canvas.drawRect(bounds, bgPaint);

    // 木纹
    final woodPaint = Paint()
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    final rng = Random(77);
    for (double y = 0; y < bounds.height; y += 30 + rng.nextDouble() * 20) {
      woodPaint.color = Color.lerp(
        const Color(0xFF2D1F0E),
        const Color(0xFF1A1208),
        rng.nextDouble(),
      )!.withValues(alpha: 0.4);

      final path = Path()..moveTo(0, y);
      for (double x = 0; x < bounds.width; x += 40) {
        path.lineTo(x + 40, y + (rng.nextDouble() - 0.5) * 3);
      }
      canvas.drawPath(path, woodPaint);
    }

    // 边角暗角效果
    final vignetteShader = RadialGradient(
      colors: [Colors.transparent, Colors.black.withValues(alpha: 0.3)],
      stops: const [0.6, 1.0],
    ).createShader(bounds);
    canvas.drawRect(bounds, Paint()..shader = vignetteShader);
  }

  void _paintTrail(Canvas canvas) {
    final trail = logic.trail;
    if (trail.length < 2) return;

    final isMouse = logic.creatureType == CatchCreatureType.mouse;
    final trailColor = isMouse
        ? const Color(0xFF8D6E63)
        : const Color(0xFF4FC3F7);

    for (int i = 0; i < trail.length; i++) {
      final t = i / trail.length;
      final alpha = t * 0.25;
      final radius = 3 + t * 8;

      final paint = Paint()
        ..color = trailColor.withValues(alpha: alpha)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
      canvas.drawCircle(trail[i], radius, paint);
    }
  }

  void _paintParticles(Canvas canvas) {
    for (final p in logic.particles) {
      final alpha = p.life.clamp(0.0, 1.0);

      switch (p.shape) {
        case ParticleShape.circle:
          final paint = Paint()
            ..color = p.color.withValues(alpha: alpha)
            ..style = PaintingStyle.fill;
          canvas.drawCircle(Offset(p.x, p.y), p.size * p.life, paint);
          break;

        case ParticleShape.star:
          canvas.save();
          canvas.translate(p.x, p.y);
          canvas.rotate(p.rotation);
          _drawStar(canvas, p.size * p.life, p.color.withValues(alpha: alpha));
          canvas.restore();
          break;

        case ParticleShape.sparkle:
          final paint = Paint()
            ..color = p.color.withValues(alpha: alpha)
            ..strokeWidth = 1.5
            ..style = PaintingStyle.stroke;
          final s = p.size * p.life;
          canvas.drawLine(Offset(p.x - s, p.y), Offset(p.x + s, p.y), paint);
          canvas.drawLine(Offset(p.x, p.y - s), Offset(p.x, p.y + s), paint);
          break;
      }
    }
  }

  void _drawStar(Canvas canvas, double radius, Color color) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final path = Path();
    for (int i = 0; i < 5; i++) {
      final outerAngle = (i * 2 * pi / 5) - pi / 2;
      final innerAngle = outerAngle + pi / 5;
      final outerX = cos(outerAngle) * radius;
      final outerY = sin(outerAngle) * radius;
      final innerX = cos(innerAngle) * radius * 0.4;
      final innerY = sin(innerAngle) * radius * 0.4;
      if (i == 0) {
        path.moveTo(outerX, outerY);
      } else {
        path.lineTo(outerX, outerY);
      }
      path.lineTo(innerX, innerY);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _paintCreatureShadow(Canvas canvas, Offset center) {
    // 底部椭圆阴影
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + logic.creatureRadius * 0.5),
        width: logic.creatureRadius * 1.8,
        height: logic.creatureRadius * 0.6,
      ),
      shadowPaint,
    );
  }

  void _paintCreature(Canvas canvas, Offset center) {
    canvas.save();
    // 根据移动方向旋转生物
    canvas.translate(center.dx, center.dy);
    canvas.rotate(logic.moveAngle);
    canvas.translate(-center.dx, -center.dy);

    if (logic.creatureType == CatchCreatureType.mouse) {
      _drawMouse(canvas, center);
    } else {
      _drawFish(canvas, center);
    }
    canvas.restore();
  }

  void _drawMouse(Canvas canvas, Offset center) {
    final r = logic.creatureRadius;

    // 尾巴（后方弯曲）
    final tailPaint = Paint()
      ..color = const Color(0xFF8D6E63).withValues(alpha: 0.8)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final sway = sin(logic.globalTime / 300) * 8;
    final tailPath = Path()
      ..moveTo(center.dx - r * 0.7, center.dy)
      ..cubicTo(
        center.dx - r * 1.2,
        center.dy + sway,
        center.dx - r * 1.5,
        center.dy - sway * 0.5,
        center.dx - r * 1.6,
        center.dy + sway * 0.3,
      );
    canvas.drawPath(tailPath, tailPaint);

    // 身体（椭圆，带渐变）
    final bodyPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.2, -0.3),
        colors: [
          const Color(0xFFA1887F),
          const Color(0xFF8D6E63),
          const Color(0xFF6D4C41),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: r));
    canvas.drawOval(
      Rect.fromCenter(center: center, width: r * 1.6, height: r * 1.3),
      bodyPaint,
    );

    // 腹部（浅色）
    final bellyPaint = Paint()
      ..color = const Color(0xFFBCAAA4).withValues(alpha: 0.5);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx + r * 0.1, center.dy + r * 0.15),
        width: r * 0.8,
        height: r * 0.6,
      ),
      bellyPaint,
    );

    // 耳朵
    _drawMouseEar(
      canvas,
      Offset(center.dx + r * 0.3, center.dy - r * 0.55),
      r * 0.3,
    );
    _drawMouseEar(
      canvas,
      Offset(center.dx + r * 0.6, center.dy - r * 0.45),
      r * 0.25,
    );

    // 眼睛
    final eyePaint = Paint()..color = const Color(0xFF212121);
    canvas.drawCircle(
      Offset(center.dx + r * 0.35, center.dy - r * 0.15),
      3.5,
      eyePaint,
    );
    // 眼睛高光
    canvas.drawCircle(
      Offset(center.dx + r * 0.37, center.dy - r * 0.18),
      1.5,
      Paint()..color = Colors.white,
    );

    // 鼻子（粉色椭圆）
    final nosePaint = Paint()..color = const Color(0xFFE8A0BF);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx + r * 0.7, center.dy + r * 0.05),
        width: 6,
        height: 5,
      ),
      nosePaint,
    );

    // 胡须
    final whiskerPaint = Paint()
      ..color = const Color(0xFFBCAAA4)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    for (int i = -1; i <= 1; i++) {
      final wy = center.dy + r * 0.05 + i * 5;
      canvas.drawLine(
        Offset(center.dx + r * 0.55, wy),
        Offset(center.dx + r * 1.1, wy + i * 3),
        whiskerPaint,
      );
    }
  }

  void _drawMouseEar(Canvas canvas, Offset center, double radius) {
    // 外耳
    final earPaint = Paint()
      ..color = const Color(0xFF6D4C41)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, earPaint);
    // 内耳
    final innerEarPaint = Paint()
      ..color = const Color(0xFFE8A0BF).withValues(alpha: 0.6);
    canvas.drawCircle(center, radius * 0.6, innerEarPaint);
  }

  void _drawFish(Canvas canvas, Offset center) {
    final r = logic.creatureRadius;

    // 尾鳍（后方摆动）
    final tailSway = sin(logic.globalTime / 200) * 10;
    final tailPath = Path()
      ..moveTo(center.dx - r * 0.5, center.dy)
      ..lineTo(center.dx - r * 1.3, center.dy - r * 0.5 + tailSway)
      ..quadraticBezierTo(
        center.dx - r * 0.9,
        center.dy,
        center.dx - r * 1.3,
        center.dy + r * 0.5 + tailSway,
      )
      ..close();
    canvas.drawPath(tailPath, Paint()..color = const Color(0xFF0277BD));

    // 身体（渐变椭圆）
    final bodyPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF81D4FA),
          const Color(0xFF4FC3F7),
          const Color(0xFF0288D1),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: r))
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(center: center, width: r * 1.8, height: r * 1.1),
      bodyPaint,
    );

    // 腹部亮色
    final bellyPaint = Paint()
      ..color = const Color(0xFFB3E5FC).withValues(alpha: 0.4);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + r * 0.15),
        width: r * 1.2,
        height: r * 0.4,
      ),
      bellyPaint,
    );

    // 背鳍
    final dorsalPath = Path()
      ..moveTo(center.dx - r * 0.1, center.dy - r * 0.5)
      ..quadraticBezierTo(
        center.dx + r * 0.2,
        center.dy - r * 0.9,
        center.dx + r * 0.5,
        center.dy - r * 0.45,
      )
      ..close();
    canvas.drawPath(dorsalPath, Paint()..color = const Color(0xFF039BE5));

    // 胸鳍
    final pectoralPath = Path()
      ..moveTo(center.dx + r * 0.1, center.dy + r * 0.15)
      ..quadraticBezierTo(
        center.dx + r * 0.4,
        center.dy + r * 0.5,
        center.dx + r * 0.1,
        center.dy + r * 0.45,
      );
    canvas.drawPath(
      pectoralPath,
      Paint()
        ..color = const Color(0xFF4FC3F7).withValues(alpha: 0.7)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke,
    );

    // 鳞片纹理（微妙的弧线）
    final scalePaint = Paint()
      ..color = const Color(0xFF039BE5).withValues(alpha: 0.2)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;
    for (int i = 0; i < 4; i++) {
      final sx = center.dx - r * 0.2 + i * r * 0.25;
      canvas.drawArc(
        Rect.fromCenter(
          center: Offset(sx, center.dy),
          width: r * 0.3,
          height: r * 0.4,
        ),
        0.5,
        2.0,
        false,
        scalePaint,
      );
    }

    // 眼睛
    final eyeBgPaint = Paint()..color = Colors.white;
    canvas.drawCircle(
      Offset(center.dx + r * 0.45, center.dy - r * 0.1),
      5,
      eyeBgPaint,
    );
    final eyePaint = Paint()..color = const Color(0xFF212121);
    canvas.drawCircle(
      Offset(center.dx + r * 0.47, center.dy - r * 0.1),
      3,
      eyePaint,
    );
    // 眼睛高光
    canvas.drawCircle(
      Offset(center.dx + r * 0.49, center.dy - r * 0.13),
      1.5,
      Paint()..color = Colors.white,
    );

    // 嘴巴
    final mouthPaint = Paint()
      ..color = const Color(0xFF01579B).withValues(alpha: 0.5)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(center.dx + r * 0.55, center.dy + r * 0.1),
        width: 8,
        height: 6,
      ),
      0.2,
      2.0,
      false,
      mouthPaint,
    );
  }

  void _paintRespawnIndicator(Canvas canvas, Rect bounds) {
    final progress = logic.respawnProgress;
    final cx = bounds.center.dx;
    final cy = bounds.center.dy;

    // 圆形进度指示器
    final bgPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(Offset(cx, cy), 24, bgPaint);

    final progressPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: 24),
      -pi / 2,
      progress * 2 * pi,
      false,
      progressPaint,
    );

    // 中心图标
    final iconText = logic.creatureType == CatchCreatureType.mouse
        ? '🐭'
        : '🐟';
    final textPainter = TextPainter(
      text: TextSpan(
        text: iconText,
        style: TextStyle(
          fontSize: 20,
          color: Colors.white.withValues(alpha: 0.5),
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(cx - textPainter.width / 2, cy - textPainter.height / 2),
    );
  }

  void _paintScore(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      text: TextSpan(
        children: [
          TextSpan(
            text: '${logic.score}',
            style: const TextStyle(
              color: Color(0xAAFFFFFF),
              fontSize: 32,
              fontWeight: FontWeight.w300,
              letterSpacing: 2,
            ),
          ),
          const TextSpan(
            text: ' 次',
            style: TextStyle(
              color: Color(0x66FFFFFF),
              fontSize: 14,
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
      Offset(overlayLeft, overlayTop + (overlaySize - textPainter.height) / 2),
    );
  }

  @override
  bool shouldRepaint(covariant _CatchMousePainter oldDelegate) => true;
}
