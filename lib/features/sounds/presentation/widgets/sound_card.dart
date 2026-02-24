import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/models/sound_item.dart';
import '../providers/sounds_provider.dart';

class SoundCard extends ConsumerWidget {
  final SoundItem sound;

  const SoundCard({super.key, required this.sound});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playbackState = ref.watch(soundPlaybackProvider);
    final isPlaying = playbackState.playingId == sound.id;
    final isLooping = isPlaying && playbackState.isLooping;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        ref.read(soundPlaybackProvider.notifier).playOnce(sound);
      },
      onLongPress: sound.isLoopable
          ? () {
              HapticFeedback.mediumImpact();
              ref.read(soundPlaybackProvider.notifier).toggleLoop(sound);
            }
          : null,
      child: ColoredBox(
        color: AppColors.background,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedScale(
                    scale: isPlaying ? 1.08 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    child: Image.asset(
                      sound.imagePath,
                      fit: BoxFit.contain,
                      gaplessPlayback: true,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          sound.icon,
                          size: 48,
                          color: isPlaying
                              ? AppColors.primary
                              : AppColors.onSurface,
                        );
                      },
                    ),
                  ),
                  if (isPlaying) _PlayingRipple(color: AppColors.primary),
                ],
              ),
            ),
            const SizedBox(height: 2),
            Text(
              sound.label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isPlaying ? FontWeight.w600 : FontWeight.w400,
                color: isPlaying ? AppColors.primary : AppColors.onSurface,
              ),
            ),
            SizedBox(
              height: 14,
              child: isLooping
                  ? Text(
                      '循环中',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 9,
                        color: AppColors.primary.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _PlayingRipple extends StatefulWidget {
  final Color color;
  const _PlayingRipple({required this.color});

  @override
  State<_PlayingRipple> createState() => _PlayingRippleState();
}

class _PlayingRippleState extends State<_PlayingRipple>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      duration: const Duration(milliseconds: 4200),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) {
        return CustomPaint(
          size: const Size(110, 110),
          painter: _RipplePainter(progress: _ctrl.value, color: widget.color),
        );
      },
    );
  }
}

class _RipplePainter extends CustomPainter {
  final double progress;
  final Color color;

  _RipplePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    for (int i = 0; i < 3; i++) {
      final t = (progress + i / 3) % 1.0;
      final radius = 18 + t * (size.width / 2 - 8);
      final alpha = (1 - t) * 0.7;
      final stroke = 10 - t * 2.0;
      final paint = Paint()
        ..color = color.withValues(alpha: alpha)
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke;
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _RipplePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
