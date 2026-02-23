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
                  if (isLooping) _LoopingRing(color: AppColors.primary),
                  AnimatedScale(
                    scale: isPlaying ? 1.08 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    child: Image.asset(
                      sound.imagePath,
                      fit: BoxFit.contain,
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

class _LoopingRing extends StatefulWidget {
  final Color color;
  const _LoopingRing({required this.color});

  @override
  State<_LoopingRing> createState() => _LoopingRingState();
}

class _LoopingRingState extends State<_LoopingRing>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();
    _scale = Tween<double>(begin: 0.7, end: 1.3).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scale,
      builder: (context, child) {
        final progress = (_scale.value - 0.7) / 0.6;
        return Container(
          width: 80 * _scale.value,
          height: 80 * _scale.value,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: widget.color.withValues(alpha: 1.0 - progress),
              width: 2,
            ),
          ),
        );
      },
    );
  }
}
