import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart';
import '../../../domain/game_config.dart';
import 'shadow_peek_logic.dart';

/// 影子藏猫猫：草丛/纸箱中物体时隐时现，点击触发逃窜
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
      frequencyFactor: 0.5 + widget.config.speed, // 0.5~1.5
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
    if (hit && widget.config.vibrationEnabled) {
      HapticFeedback.lightImpact();
    }
    if (hit) {
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

    // 1. 背景：草丛渐变
    _paintGrassBackground(canvas, bounds);

    // 2. 纸箱/草丛掩体
    for (final shelter in logic.shelters) {
      _paintShelter(canvas, shelter);
    }

    // 3. 露出的生物
    if (logic.creatureVisible) {
      _paintCreature(canvas, logic.creatureType, logic.creaturePeekRect,
          logic.creaturePeekProgress);
    }

    // 4. 逃窜动画
    if (logic.isEscaping) {
      _paintEscapingCreature(canvas, logic.creatureType,
          logic.escapeFrom, logic.escapeTo, logic.escapeProgress);
    }
  }

  void _paintGrassBackground(Canvas canvas, Rect bounds) {
    final bgPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF1B5E20),
          const Color(0xFF2E7D32),
          const Color(0xFF388E3C),
        ],
      ).createShader(bounds);
    canvas.drawRect(bounds, bgPaint);

    // 草丛纹理：竖条纹
    final stripePaint = Paint()
      ..color = const Color(0xFF1B5E20).withValues(alpha: 0.3)
      ..strokeWidth = 2;
    for (double x = 0; x < bounds.width; x += 12) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, bounds.height),
        stripePaint,
      );
    }
  }

  void _paintShelter(Canvas canvas, Shelter shelter) {
    final r = shelter.rect;

    if (shelter.type == ShelterType.grass) {
      // 草丛团
      final paint = Paint()
        ..color = const Color(0xFF2E7D32)
        ..style = PaintingStyle.fill;
      final strokePaint = Paint()
        ..color = const Color(0xFF1B5E20)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      final path = Path()
        ..addRRect(RRect.fromRectAndRadius(r, const Radius.circular(12)));
      canvas.drawPath(path, paint);
      canvas.drawPath(path, strokePaint);

      // 草叶装饰
      final leafPaint = Paint()..color = const Color(0xFF4CAF50);
      for (int i = 0; i < 5; i++) {
        final cx = r.left + r.width * (0.2 + i * 0.2);
        final cy = r.top + r.height * 0.3;
        canvas.drawOval(
          Rect.fromCenter(center: Offset(cx, cy), width: 8, height: 16),
          leafPaint,
        );
      }
    } else {
      // 纸箱
      final boxPaint = Paint()
        ..color = const Color(0xFF8D6E63)
        ..style = PaintingStyle.fill;
      final edgePaint = Paint()
        ..color = const Color(0xFF5D4037)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      canvas.drawRRect(
        RRect.fromRectAndRadius(r, const Radius.circular(4)),
        boxPaint,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(r, const Radius.circular(4)),
        edgePaint,
      );

      // 纸箱胶带
      final tapePaint = Paint()..color = const Color(0xFFBCAAA4);
      canvas.drawRect(
        Rect.fromLTWH(r.left, r.top + r.height * 0.45, r.width, 6),
        tapePaint,
      );
    }
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
    final cy = rect.bottom - 20;

    // 身体
    final bodyPaint = Paint()
      ..color = const Color(0xFFFFEB3B)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx, cy), 14 * progress, bodyPaint);

    // 眼睛
    final eyePaint = Paint()..color = const Color(0xFF212121);
    canvas.drawCircle(Offset(cx - 4, cy - 4), 3, eyePaint);
    canvas.drawCircle(Offset(cx + 4, cy - 4), 3, eyePaint);

    // 喙
    final beakPath = Path()
      ..moveTo(cx + 8, cy)
      ..lineTo(cx + 18, cy - 2)
      ..lineTo(cx + 8, cy + 2)
      ..close();
    canvas.drawPath(beakPath, Paint()..color = const Color(0xFFFF9800));
  }

  void _drawSnake(Canvas canvas, Rect rect, double progress) {
    final cx = rect.center.dx;
    final cy = rect.bottom - 15;

    // 蛇头
    final headPaint = Paint()
      ..color = const Color(0xFF8BC34A)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx, cy), 12 * progress, headPaint);

    // 眼睛
    final eyePaint = Paint()..color = const Color(0xFF212121);
    canvas.drawCircle(Offset(cx - 4, cy - 3), 2, eyePaint);
    canvas.drawCircle(Offset(cx + 4, cy - 3), 2, eyePaint);

    // 舌头
    if (progress > 0.5) {
      final tonguePaint = Paint()
        ..color = const Color(0xFFE91E63)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;
      final tonguePath = Path()
        ..moveTo(cx, cy + 8)
        ..quadraticBezierTo(cx + 6, cy + 16, cx + 4, cy + 20)
        ..moveTo(cx, cy + 8)
        ..quadraticBezierTo(cx - 6, cy + 16, cx - 4, cy + 20);
      canvas.drawPath(tonguePath, tonguePaint);
    }
  }

  void _paintEscapingCreature(
    Canvas canvas,
    CreatureType type,
    Rect from,
    Rect to,
    double progress,
  ) {
    final t = Curves.easeInOutCubic.transform(progress);
    final x = from.center.dx + (to.center.dx - from.center.dx) * t;
    final y = from.center.dy + (to.center.dy - from.center.dy) * t;
    final rect = Rect.fromCenter(
      center: Offset(x, y),
      width: 50,
      height: 50,
    );
    // 逃窜时完整显示，不裁剪
    if (type == CreatureType.bird) {
      _drawBird(canvas, rect, 1.0);
    } else {
      _drawSnake(canvas, rect, 1.0);
    }
  }

  @override
  bool shouldRepaint(covariant _ShadowPeekPainter oldDelegate) {
    // logic 内部状态变化需重绘，每次 rebuild 都重绘
    return true;
  }
}
