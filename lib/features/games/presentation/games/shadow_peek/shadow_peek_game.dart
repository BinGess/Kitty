import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart';
import '../../../domain/game_config.dart';
import 'shadow_peek_logic.dart';

/// 影子藏猫猫（增强版）
/// - 天空渐变 + 云朵
/// - 草丛随风摇曳
/// - 更精致的掩体和生物
/// - 粒子效果
/// - 分数显示
class ShadowPeekGame extends StatefulWidget {
  final GameConfig config;

  const ShadowPeekGame({
    super.key,
    required this.config,
  });

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
            painter: _ShadowPeekPainter(logic: _logic!),
          ),
        );
      },
    );
  }
}

class _ShadowPeekPainter extends CustomPainter {
  final ShadowPeekLogic logic;

  _ShadowPeekPainter({required this.logic});

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = logic.bounds;

    // 1. 天空渐变背景
    _paintSky(canvas, bounds);

    // 2. 远景装饰（云朵、树）
    _paintClouds(canvas, bounds);

    // 3. 地面
    _paintGround(canvas, bounds);

    // 4. 掩体（含摇动效果）
    for (int i = 0; i < logic.shelters.length; i++) {
      final isShaking =
          logic.shakingShelterIndex == i && logic.shakeProgress < 1.0;
      _paintShelter(canvas, logic.shelters[i], i, isShaking);
    }

    // 5. 露出的生物
    if (logic.creatureVisible) {
      _paintCreature(canvas, logic.creatureType, logic.creaturePeekRect,
          logic.creaturePeekProgress);
    }

    // 6. 逃窜动画
    if (logic.isEscaping) {
      _paintEscapingCreature(canvas, logic.creatureType, logic.escapeFrom,
          logic.escapeTo, logic.escapeProgress);
    }

    // 7. 粒子
    _paintParticles(canvas);

    // 8. 分数
    _paintScore(canvas, size);

    // 9. 提示
    if (!logic.creatureVisible && !logic.isEscaping && logic.score == 0) {
      _paintHint(canvas, bounds);
    }
  }

  void _paintSky(Canvas canvas, Rect bounds) {
    final skyPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF1A237E), // 深蓝天空
          const Color(0xFF283593),
          const Color(0xFF3949AB),
          const Color(0xFF1B5E20), // 过渡到绿
        ],
        stops: const [0.0, 0.3, 0.6, 1.0],
      ).createShader(bounds);
    canvas.drawRect(bounds, skyPaint);

    // 星星（微弱闪烁）
    final starPaint = Paint()..color = Colors.white;
    final rng = Random(42); // 固定种子保持星星位置不变
    for (int i = 0; i < 30; i++) {
      final x = rng.nextDouble() * bounds.width;
      final y = rng.nextDouble() * bounds.height * 0.5;
      final twinkle =
          sin(logic.globalTime / 1000 + i * 1.7) * 0.5 + 0.5;
      starPaint.color =
          Colors.white.withValues(alpha: 0.2 + twinkle * 0.4);
      final starSize = 1.0 + rng.nextDouble() * 1.5;
      canvas.drawCircle(Offset(x, y), starSize, starPaint);
    }
  }

  void _paintClouds(Canvas canvas, Rect bounds) {
    // 缓慢飘动的云朵
    final cloudPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.06);
    final t = (logic.globalTime / 30000) % 1.0;

    for (int i = 0; i < 3; i++) {
      final baseX =
          ((t * bounds.width + i * bounds.width / 3) % (bounds.width + 200)) -
              100;
      final y = 40.0 + i * 50;
      final w = 80.0 + i * 30;

      canvas.drawOval(
          Rect.fromCenter(center: Offset(baseX, y), width: w, height: 24),
          cloudPaint);
      canvas.drawOval(
          Rect.fromCenter(
              center: Offset(baseX + 20, y - 8), width: w * 0.6, height: 18),
          cloudPaint);
    }
  }

  void _paintGround(Canvas canvas, Rect bounds) {
    // 草地渐变
    final groundTop = bounds.height * 0.55;
    final groundRect =
        Rect.fromLTWH(0, groundTop, bounds.width, bounds.height - groundTop);
    final groundPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF2E7D32),
          const Color(0xFF1B5E20),
          const Color(0xFF0D3B0F),
        ],
      ).createShader(groundRect);
    canvas.drawRect(groundRect, groundPaint);

    // 随风摇曳的小草
    final grassPaint = Paint()
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final windOffset = sin(logic.globalTime / 2000) * 5;
    final rng = Random(123);

    for (int i = 0; i < 40; i++) {
      final x = rng.nextDouble() * bounds.width;
      final baseY = groundTop + rng.nextDouble() * (bounds.height - groundTop) * 0.3;
      final h = 10 + rng.nextDouble() * 15;
      final sway = sin(logic.globalTime / 1500 + x / 50) * 4 + windOffset;

      grassPaint.color = Color.lerp(
        const Color(0xFF4CAF50),
        const Color(0xFF81C784),
        rng.nextDouble(),
      )!
          .withValues(alpha: 0.5);

      final path = Path()
        ..moveTo(x, baseY)
        ..quadraticBezierTo(x + sway * 0.5, baseY - h * 0.5, x + sway, baseY - h);
      canvas.drawPath(path, grassPaint);
    }
  }

  void _paintShelter(
      Canvas canvas, Shelter shelter, int index, bool isShaking) {
    final r = shelter.rect;

    canvas.save();
    if (isShaking) {
      final shakeAmount =
          sin(logic.shakeProgress * pi * 6) * 4 * (1 - logic.shakeProgress);
      canvas.translate(shakeAmount, 0);
    }

    if (shelter.type == ShelterType.grass) {
      _paintGrassShelter(canvas, r, index);
    } else {
      _paintBoxShelter(canvas, r, index);
    }

    canvas.restore();
  }

  void _paintGrassShelter(Canvas canvas, Rect r, int index) {
    // 底部阴影
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawOval(
      Rect.fromLTWH(r.left + 5, r.bottom - 10, r.width - 10, 16),
      shadowPaint,
    );

    // 草丛主体（多层叠加）
    final basePaint = Paint()
      ..color = const Color(0xFF2E7D32)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(r, const Radius.circular(16)),
      basePaint,
    );

    // 草叶（顶部一排弯曲的草）
    final windSway = sin(logic.globalTime / 1800 + index * 2) * 6;
    final bladePaint = Paint()
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final rng = Random(index * 100);
    for (int i = 0; i < 8; i++) {
      final cx = r.left + r.width * (0.1 + i * 0.12);
      final baseY = r.top + r.height * 0.2;
      final h = 15 + rng.nextDouble() * 12;
      final sway = windSway * (0.5 + rng.nextDouble());

      bladePaint.color = Color.lerp(
        const Color(0xFF4CAF50),
        const Color(0xFF8BC34A),
        rng.nextDouble(),
      )!;

      final path = Path()
        ..moveTo(cx, baseY)
        ..quadraticBezierTo(
            cx + sway * 0.6, baseY - h * 0.6, cx + sway, baseY - h);
      canvas.drawPath(path, bladePaint);
    }

    // 亮色装饰点
    final dotPaint = Paint()..color = const Color(0xFF81C784);
    for (int i = 0; i < 4; i++) {
      final dx = r.left + r.width * (0.2 + i * 0.2) + rng.nextDouble() * 8;
      final dy = r.top + r.height * (0.4 + rng.nextDouble() * 0.3);
      canvas.drawCircle(Offset(dx, dy), 3, dotPaint);
    }
  }

  void _paintBoxShelter(Canvas canvas, Rect r, int index) {
    // 底部阴影
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.25)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawRect(
      Rect.fromLTWH(r.left + 4, r.bottom - 6, r.width - 8, 10),
      shadowPaint,
    );

    // 纸箱主体
    final boxPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFFA1887F),
          const Color(0xFF8D6E63),
          const Color(0xFF795548),
        ],
      ).createShader(r);
    canvas.drawRRect(
      RRect.fromRectAndRadius(r, const Radius.circular(6)),
      boxPaint,
    );

    // 边框
    final edgePaint = Paint()
      ..color = const Color(0xFF5D4037)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRRect(
      RRect.fromRectAndRadius(r, const Radius.circular(6)),
      edgePaint,
    );

    // 纸箱翻盖（顶部三角折叠）
    final flapPaint = Paint()..color = const Color(0xFF6D4C41);
    final flapPath = Path()
      ..moveTo(r.left, r.top)
      ..lineTo(r.left + r.width * 0.3, r.top - r.height * 0.08)
      ..lineTo(r.left + r.width * 0.5, r.top)
      ..close();
    canvas.drawPath(flapPath, flapPaint);

    final flapPath2 = Path()
      ..moveTo(r.right, r.top)
      ..lineTo(r.right - r.width * 0.3, r.top - r.height * 0.08)
      ..lineTo(r.right - r.width * 0.5, r.top)
      ..close();
    canvas.drawPath(flapPath2, Paint()..color = const Color(0xFF795548));

    // 胶带
    final tapePaint = Paint()..color = const Color(0xFFBCAAA4).withValues(alpha: 0.6);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
            r.left + r.width * 0.1, r.top + r.height * 0.42, r.width * 0.8, 5),
        const Radius.circular(2),
      ),
      tapePaint,
    );

    // 纸箱上的猫咪贴纸（小装饰）
    final stickerPaint = Paint()..color = const Color(0xFFFFCC80).withValues(alpha: 0.3);
    canvas.drawCircle(
      Offset(r.left + r.width * 0.75, r.top + r.height * 0.65),
      8,
      stickerPaint,
    );
  }

  void _paintCreature(
      Canvas canvas, CreatureType type, Rect rect, double progress) {
    if (progress <= 0) return;

    canvas.save();
    canvas.clipRect(rect);

    if (type == CreatureType.bird) {
      _drawBird(canvas, rect, progress);
    } else {
      _drawSnake(canvas, rect, progress);
    }

    canvas.restore();
  }

  void _drawBird(Canvas canvas, Rect rect, double progress) {
    final cx = rect.center.dx;
    final cy = rect.bottom - 24;
    final scale = progress.clamp(0.0, 1.0);

    // 身体
    final bodyPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFFF176),
          const Color(0xFFFFEB3B),
          const Color(0xFFFFC107),
        ],
      ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: 16))
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(cx, cy), width: 30 * scale, height: 26 * scale),
      bodyPaint,
    );

    if (scale > 0.5) {
      // 翅膀（左）
      final wingPaint = Paint()..color = const Color(0xFFFFE082);
      final wingPath = Path()
        ..moveTo(cx - 10, cy)
        ..quadraticBezierTo(cx - 22, cy - 8, cx - 18, cy + 6)
        ..close();
      canvas.drawPath(wingPath, wingPaint);

      // 翅膀（右）
      final wingPath2 = Path()
        ..moveTo(cx + 10, cy)
        ..quadraticBezierTo(cx + 22, cy - 8, cx + 18, cy + 6)
        ..close();
      canvas.drawPath(wingPath2, wingPaint);

      // 眼睛
      final eyePaint = Paint()..color = const Color(0xFF212121);
      canvas.drawCircle(Offset(cx - 5, cy - 4), 3.5, eyePaint);
      canvas.drawCircle(Offset(cx + 5, cy - 4), 3.5, eyePaint);
      // 眼睛高光
      canvas.drawCircle(
          Offset(cx - 4, cy - 5), 1.5, Paint()..color = Colors.white);
      canvas.drawCircle(
          Offset(cx + 6, cy - 5), 1.5, Paint()..color = Colors.white);

      // 喙
      final beakPath = Path()
        ..moveTo(cx, cy + 2)
        ..lineTo(cx + 6, cy + 6)
        ..lineTo(cx, cy + 8)
        ..lineTo(cx - 6, cy + 6)
        ..close();
      canvas.drawPath(beakPath, Paint()..color = const Color(0xFFFF9800));

      // 头顶小毛
      final tuffPaint = Paint()
        ..color = const Color(0xFFFFCC02)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
      final tuffPath = Path()
        ..moveTo(cx - 2, cy - 12)
        ..quadraticBezierTo(cx + 2, cy - 20, cx - 1, cy - 18);
      canvas.drawPath(tuffPath, tuffPaint);
    }
  }

  void _drawSnake(Canvas canvas, Rect rect, double progress) {
    final cx = rect.center.dx;
    final cy = rect.bottom - 18;
    final scale = progress.clamp(0.0, 1.0);

    // 身体弧线（S形）
    if (scale > 0.3) {
      final bodyPaint = Paint()
        ..color = const Color(0xFF66BB6A)
        ..strokeWidth = 8 * scale
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      final bodyPath = Path()
        ..moveTo(cx - 20, cy + 10)
        ..cubicTo(cx - 10, cy - 5, cx + 10, cy + 15, cx + 20, cy);
      canvas.drawPath(bodyPath, bodyPaint);

      // 身体花纹
      final patternPaint = Paint()
        ..color = const Color(0xFF43A047)
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke;
      canvas.drawPath(bodyPath, patternPaint);
    }

    // 蛇头
    final headPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF81C784),
          const Color(0xFF4CAF50),
        ],
      ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: 14))
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(cx, cy), width: 22 * scale, height: 18 * scale),
      headPaint,
    );

    if (scale > 0.5) {
      // 眼睛（黄色带竖瞳）
      final eyeBgPaint = Paint()..color = const Color(0xFFFFEB3B);
      canvas.drawOval(
        Rect.fromCenter(
            center: Offset(cx - 5, cy - 3), width: 7, height: 8),
        eyeBgPaint,
      );
      canvas.drawOval(
        Rect.fromCenter(
            center: Offset(cx + 5, cy - 3), width: 7, height: 8),
        eyeBgPaint,
      );
      // 竖瞳
      final pupilPaint = Paint()..color = const Color(0xFF212121);
      canvas.drawOval(
        Rect.fromCenter(
            center: Offset(cx - 5, cy - 3), width: 2.5, height: 6),
        pupilPaint,
      );
      canvas.drawOval(
        Rect.fromCenter(
            center: Offset(cx + 5, cy - 3), width: 2.5, height: 6),
        pupilPaint,
      );

      // 分叉舌头（动画）
      final tongueFlick =
          sin(logic.globalTime / 200) * 0.5 + 0.5;
      if (tongueFlick > 0.3) {
        final tonguePaint = Paint()
          ..color = const Color(0xFFE91E63)
          ..strokeWidth = 1.5
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;
        final extend = tongueFlick * 12;
        final tonguePath = Path()
          ..moveTo(cx, cy + 8)
          ..lineTo(cx, cy + 8 + extend)
          ..moveTo(cx, cy + 8 + extend * 0.7)
          ..lineTo(cx - 3, cy + 8 + extend)
          ..moveTo(cx, cy + 8 + extend * 0.7)
          ..lineTo(cx + 3, cy + 8 + extend);
        canvas.drawPath(tonguePath, tonguePaint);
      }
    }
  }

  void _paintEscapingCreature(
    Canvas canvas,
    CreatureType type,
    Rect from,
    Rect to,
    double progress,
  ) {
    final t = Curves.easeInOutCubic.transform(progress.clamp(0.0, 1.0));
    final x = from.center.dx + (to.center.dx - from.center.dx) * t;
    final y = from.center.dy + (to.center.dy - from.center.dy) * t;
    // 抛物线上弹效果
    final arc = sin(t * pi) * -40;
    final rect = Rect.fromCenter(
      center: Offset(x, y + arc),
      width: 50,
      height: 50,
    );

    // 运动模糊效果（半透明副本）
    if (t > 0.1 && t < 0.9) {
      canvas.save();
      final blurPaint = Paint()
        ..color = (type == CreatureType.bird
                ? const Color(0xFFFFEB3B)
                : const Color(0xFF4CAF50))
            .withValues(alpha: 0.3);
      canvas.drawCircle(
          Offset(x - (to.center.dx - from.center.dx) * 0.05, y + arc),
          12,
          blurPaint);
      canvas.restore();
    }

    if (type == CreatureType.bird) {
      _drawBird(canvas, rect, 1.0);
    } else {
      _drawSnake(canvas, rect, 1.0);
    }
  }

  void _paintParticles(Canvas canvas) {
    for (final p in logic.particles) {
      final paint = Paint()
        ..color = p.color.withValues(alpha: p.life.clamp(0.0, 1.0))
        ..style = PaintingStyle.fill;
      // 叶片形状粒子
      canvas.save();
      canvas.translate(p.x, p.y);
      canvas.rotate(p.vx * p.life * 2);
      canvas.drawOval(
        Rect.fromCenter(
            center: Offset.zero,
            width: p.size * p.life,
            height: p.size * p.life * 0.6),
        paint,
      );
      canvas.restore();
    }
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
      const Offset(68, 56),
    );
  }

  void _paintHint(Canvas canvas, Rect bounds) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: '仔细观察草丛和纸箱...',
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.4),
          fontSize: 14,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        bounds.center.dx - textPainter.width / 2,
        bounds.height * 0.48,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant _ShadowPeekPainter oldDelegate) => true;
}
