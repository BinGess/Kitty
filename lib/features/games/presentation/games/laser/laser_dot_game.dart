import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import '../../../domain/game_config.dart';
import 'laser_trajectory.dart' show LaserTrajectory, LaserPhase;

/// 经典激光点游戏：增强版
/// - 光点拖尾效果
/// - 脉冲呼吸光晕
/// - 屏幕边缘环境光
/// - 点击计分
/// - 暂停微抖动
class LaserDotGame extends StatefulWidget {
  final GameConfig config;

  const LaserDotGame({
    super.key,
    required this.config,
  });

  @override
  State<LaserDotGame> createState() => _LaserDotGameState();
}

class _LaserDotGameState extends State<LaserDotGame> {
  LaserTrajectory? _trajectory;
  double _lastTime = 0;
  int _score = 0;
  // 点击反馈动画
  Offset? _tapFeedbackPos;
  double _tapFeedbackProgress = 0;
  bool _showTapFeedback = false;

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

      final traj = _trajectory;
      if (traj != null) {
        final speedFactor = widget.config.movementDurationFactor.toDouble();
        traj.update(deltaMs, speedFactor);
      }

      // 点击反馈动画
      if (_showTapFeedback) {
        _tapFeedbackProgress += deltaMs / 400;
        if (_tapFeedbackProgress >= 1.0) {
          _showTapFeedback = false;
          _tapFeedbackProgress = 0;
        }
      }

      setState(() {});
      _scheduleFrame();
    });
  }

  void _initTrajectory(Size size) {
    if (size.width <= 0 || size.height <= 0) return;
    _trajectory = LaserTrajectory(
      bounds: Offset.zero & size,
      rng: Random(),
      dotRadius: 14,
    );
    _trajectory!.startNewCycle();
  }

  void _onTap(Offset localPosition) {
    final traj = _trajectory;
    if (traj == null) return;

    if (traj.tapHit(localPosition)) {
      _score++;
      _tapFeedbackPos = localPosition;
      _tapFeedbackProgress = 0;
      _showTapFeedback = true;

      if (widget.config.vibrationEnabled) {
        HapticFeedback.lightImpact();
      }
      if (widget.config.soundEnabled) {
        SystemSound.play(SystemSoundType.click);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        if (size.width > 0 && size.height > 0) {
          if (_trajectory == null || _trajectory!.bounds.size != size) {
            _initTrajectory(size);
          }
        }
        if (_trajectory == null) {
          return const SizedBox.expand();
        }
        return Listener(
          behavior: HitTestBehavior.opaque,
          onPointerDown: (e) => _onTap(e.localPosition),
          child: CustomPaint(
            size: Size(constraints.maxWidth, constraints.maxHeight),
            painter: _LaserDotPainter(
              trajectory: _trajectory!,
              score: _score,
              tapFeedbackPos: _tapFeedbackPos,
              tapFeedbackProgress:
                  _showTapFeedback ? _tapFeedbackProgress : -1,
            ),
          ),
        );
      },
    );
  }
}

class _LaserDotPainter extends CustomPainter {
  final LaserTrajectory trajectory;
  final int score;
  final Offset? tapFeedbackPos;
  final double tapFeedbackProgress;

  _LaserDotPainter({
    required this.trajectory,
    required this.score,
    this.tapFeedbackPos,
    this.tapFeedbackProgress = -1,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. 纯黑背景
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFF050505),
    );

    // 2. 微妙的地面纹理（木地板感）
    _paintFloorTexture(canvas, size);

    // 3. 屏幕边缘环境光
    if (trajectory.visible && trajectory.position != null) {
      _paintAmbientGlow(canvas, size, trajectory.position!);
    }

    // 4. 拖尾效果
    _paintTrail(canvas);

    // 5. 光点主体
    if (trajectory.visible && trajectory.position != null) {
      final pos = trajectory.phase == LaserPhase.paused
          ? trajectory.position! + trajectory.jitter
          : trajectory.position!;
      _paintLaserDot(canvas, pos);
    }

    // 6. 点击反馈
    if (tapFeedbackProgress >= 0 && tapFeedbackPos != null) {
      _paintTapFeedback(canvas, tapFeedbackPos!, tapFeedbackProgress);
    }

    // 7. 分数显示
    _paintScore(canvas, size);
  }

  void _paintFloorTexture(Canvas canvas, Size size) {
    // 微妙的横纹，模拟地板
    final linePaint = Paint()
      ..color = const Color(0xFF0A0A0A)
      ..strokeWidth = 0.5;
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }
  }

  void _paintAmbientGlow(Canvas canvas, Size size, Offset pos) {
    // 光点附近区域的环境反射光
    final ambientPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          trajectory.color.withValues(alpha: 0.06),
          trajectory.color.withValues(alpha: 0.02),
          Colors.transparent,
        ],
        stops: const [0.0, 0.4, 1.0],
      ).createShader(Rect.fromCircle(center: pos, radius: 150));
    canvas.drawCircle(pos, 150, ambientPaint);
  }

  void _paintTrail(Canvas canvas) {
    final trail = trajectory.trail;
    if (trail.length < 2) return;

    for (int i = 0; i < trail.length; i++) {
      final t = i / trail.length; // 0 最旧, 1 最新
      final alpha = t * 0.4;
      final radius = 3 + t * 5;

      final trailPaint = Paint()
        ..color = trajectory.color.withValues(alpha: alpha)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4 + t * 6);
      canvas.drawCircle(trail[i], radius, trailPaint);
    }
  }

  void _paintLaserDot(Canvas canvas, Offset pos) {
    final color = trajectory.color;
    final pulse = sin(trajectory.pulsePhase * 2 * pi);
    final pulseScale = 1.0 + pulse * 0.15;

    // 层1：最外层大范围光晕
    final outerGlow = Paint()
      ..color = color.withValues(alpha: 0.15 + pulse * 0.05)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 40);
    canvas.drawCircle(pos, 30 * pulseScale, outerGlow);

    // 层2：中层光晕
    final midGlow = Paint()
      ..color = color.withValues(alpha: 0.4 + pulse * 0.1)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16);
    canvas.drawCircle(pos, 18 * pulseScale, midGlow);

    // 层3：核心光点
    final corePaint = Paint()..color = color;
    canvas.drawCircle(pos, 10 * pulseScale, corePaint);

    // 层4：中心高光
    final brightPaint = Paint()
      ..color = Color.lerp(color, Colors.white, 0.6)!;
    canvas.drawCircle(pos, 5 * pulseScale, brightPaint);

    // 层5：中心最亮点
    canvas.drawCircle(pos, 2, Paint()..color = Colors.white);
  }

  void _paintTapFeedback(Canvas canvas, Offset pos, double progress) {
    final t = Curves.easeOut.transform(progress);
    final radius = 20 + t * 40;
    final alpha = (1.0 - t) * 0.5;

    final ringPaint = Paint()
      ..color = const Color(0xFFFFD700).withValues(alpha: alpha)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * (1 - t);
    canvas.drawCircle(pos, radius, ringPaint);

    // +1 文字
    if (t < 0.8) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: '+1',
          style: TextStyle(
            color: const Color(0xFFFFD700).withValues(alpha: (1 - t) * 0.9),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(pos.dx - textPainter.width / 2, pos.dy - 30 - t * 20),
      );
    }
  }

  void _paintScore(Canvas canvas, Size size) {
    // 右上角分数
    final textPainter = TextPainter(
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
      Offset(size.width - textPainter.width - 20, 56),
    );
  }

  @override
  bool shouldRepaint(covariant _LaserDotPainter oldDelegate) => true;
}
