import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../../../domain/game_config.dart';
import 'laser_trajectory.dart' show LaserTrajectory, LaserPhase;

/// 经典激光点游戏：红/绿高亮光点，模拟昆虫飞行轨迹
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
        if (traj.update(deltaMs, speedFactor)) {
          setState(() {});
        } else if (traj.phase == LaserPhase.paused) {
          setState(() {});
        }
      }
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

  @override
  void dispose() {
    super.dispose();
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
        return CustomPaint(
          size: Size(constraints.maxWidth, constraints.maxHeight),
          painter: _LaserDotPainter(trajectory: _trajectory!),
        );
      },
    );
  }
}

class _LaserDotPainter extends CustomPainter {
  final LaserTrajectory trajectory;

  _LaserDotPainter({required this.trajectory});

  @override
  void paint(Canvas canvas, Size size) {
    if (!trajectory.visible || trajectory.position == null) return;

    final pos = trajectory.position!;
    final color = trajectory.color;

    // 外发光
    final glowPaint = Paint()
      ..color = color.withValues(alpha: 0.35)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 28);
    canvas.drawCircle(pos, 22, glowPaint);

    // 中层光晕
    final midPaint = Paint()
      ..color = color.withValues(alpha: 0.7)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawCircle(pos, 14, midPaint);

    // 核心高亮
    final corePaint = Paint()..color = color;
    canvas.drawCircle(pos, 10, corePaint);

    // 中心最亮
    final brightPaint = Paint()
      ..color = Color.lerp(color, Colors.white, 0.5)!;
    canvas.drawCircle(pos, 5, brightPaint);
  }

  @override
  bool shouldRepaint(covariant _LaserDotPainter oldDelegate) {
    return oldDelegate.trajectory != trajectory;
  }
}
