import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart';
import '../../../domain/game_config.dart';
import 'catch_mouse_logic.dart';

/// 捕鼠/捕鱼大战：拟真老鼠或鱼游走，拍击即捕获
class CatchMouseGame extends StatefulWidget {
  final GameConfig config;

  const CatchMouseGame({
    super.key,
    required this.config,
  });

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
            painter: _CatchMousePainter(logic: _logic!),
          ),
        );
      },
    );
  }
}

class _CatchMousePainter extends CustomPainter {
  final CatchMouseLogic logic;

  _CatchMousePainter({required this.logic});

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = logic.bounds;

    // 1. 背景：深色
    final bgPaint = Paint()..color = const Color(0xFF0D0D0D);
    canvas.drawRect(bounds, bgPaint);

    // 2. 粒子特效（捕获时）
    for (final p in logic.particles) {
      final paint = Paint()
        ..color = p.color.withValues(alpha: p.life)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(p.x, p.y), p.size * p.life, paint);
    }

    // 3. 生物
    if (logic.visible) {
      if (logic.creatureType == CatchCreatureType.mouse) {
        _drawMouse(canvas, Offset(logic.x, logic.y));
      } else {
        _drawFish(canvas, Offset(logic.x, logic.y));
      }
    }

    // 4. 刷新等待提示
    if (logic.isRespawning && logic.particles.isEmpty) {
      _drawRespawnHint(canvas, bounds);
    }
  }

  void _drawMouse(Canvas canvas, Offset center) {
    final r = logic.creatureRadius;

    // 身体
    final bodyPaint = Paint()
      ..color = const Color(0xFF8D6E63)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(center: center, width: r * 1.4, height: r * 1.2),
      bodyPaint,
    );

    // 耳朵
    final earPaint = Paint()
      ..color = const Color(0xFF6D4C41)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(center.dx - r * 0.5, center.dy - r * 0.6),
      r * 0.35,
      earPaint,
    );
    canvas.drawCircle(
      Offset(center.dx + r * 0.5, center.dy - r * 0.6),
      r * 0.35,
      earPaint,
    );

    // 眼睛
    final eyePaint = Paint()..color = const Color(0xFF212121);
    canvas.drawCircle(
      Offset(center.dx - r * 0.25, center.dy - r * 0.2),
      3,
      eyePaint,
    );
    canvas.drawCircle(
      Offset(center.dx + r * 0.25, center.dy - r * 0.2),
      3,
      eyePaint,
    );

    // 鼻子
    final nosePaint = Paint()..color = const Color(0xFF4E342E);
    canvas.drawCircle(
      Offset(center.dx, center.dy + r * 0.2),
      4,
      nosePaint,
    );

    // 尾巴
    final tailPath = Path()
      ..moveTo(center.dx + r * 0.6, center.dy)
      ..quadraticBezierTo(
        center.dx + r * 1.2,
        center.dy - r * 0.3,
        center.dx + r * 1.4,
        center.dy,
      )
      ..quadraticBezierTo(
        center.dx + r * 1.2,
        center.dy + r * 0.3,
        center.dx + r * 0.6,
        center.dy,
      );
    canvas.drawPath(tailPath, Paint()..color = const Color(0xFF6D4C41));
  }

  void _drawFish(Canvas canvas, Offset center) {
    final r = logic.creatureRadius;

    // 身体
    final bodyPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF4FC3F7),
          const Color(0xFF0288D1),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: r))
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(center: center, width: r * 1.6, height: r * 1.0),
      bodyPaint,
    );

    // 尾鳍
    final tailPath = Path()
      ..moveTo(center.dx + r * 0.6, center.dy)
      ..lineTo(center.dx + r * 1.2, center.dy - r * 0.5)
      ..lineTo(center.dx + r * 1.2, center.dy + r * 0.5)
      ..close();
    canvas.drawPath(tailPath, Paint()..color = const Color(0xFF0288D1));

    // 背鳍
    final dorsalPath = Path()
      ..moveTo(center.dx - r * 0.3, center.dy - r * 0.4)
      ..lineTo(center.dx + r * 0.3, center.dy - r * 0.6)
      ..lineTo(center.dx + r * 0.6, center.dy - r * 0.3)
      ..close();
    canvas.drawPath(dorsalPath, Paint()..color = const Color(0xFF039BE5));

    // 眼睛
    final eyePaint = Paint()..color = const Color(0xFF212121);
    canvas.drawCircle(
      Offset(center.dx - r * 0.3, center.dy - r * 0.1),
      4,
      eyePaint,
    );
    canvas.drawCircle(
      Offset(center.dx - r * 0.25, center.dy - r * 0.15),
      1.5,
      Paint()..color = Colors.white,
    );
  }

  void _drawRespawnHint(Canvas canvas, Rect bounds) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: '3秒后刷新...',
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.3),
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
        bounds.center.dy - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant _CatchMousePainter oldDelegate) => true;
}
