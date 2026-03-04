import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../data/models/sound_item.dart';
import '../providers/sounds_provider.dart';

class SoundCard extends ConsumerWidget {
  static const double _iconBoxSize = 88;
  static const double _rippleSize = 122;

  final SoundItem sound;

  const SoundCard({super.key, required this.sound});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final playbackState = ref.watch(soundPlaybackProvider);
    final isPlaying = playbackState.playingId == sound.id;
    final isLooping = isPlaying && playbackState.isLooping;
    final isPlaceholder = sound.isPlaceholder;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (isPlaceholder) {
          HapticFeedback.selectionClick();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.soundPlaceholderHint),
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
            ),
          );
          return;
        }
        HapticFeedback.lightImpact();
        ref.read(soundPlaybackProvider.notifier).playOnce(sound);
      },
      onLongPress: sound.isLoopable && !isPlaceholder
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
                    scale: isPlaying ? 1.05 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    child: Opacity(
                      opacity: isPlaceholder ? 0.56 : 1.0,
                      child: Transform.scale(
                        scale: sound.visualScale,
                        child: SizedBox.square(
                          dimension: _iconBoxSize,
                          child: Image.asset(
                            sound.imagePath,
                            fit: BoxFit.contain,
                            gaplessPlayback: true,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                sound.icon,
                                size: AppDimensions.iconXLarge,
                                color: isPlaying
                                    ? AppColors.primary
                                    : AppColors.onSurface,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (isPlaying && !isPlaceholder)
                    const _PlayingRipple(
                      color: AppColors.primary,
                      size: _rippleSize,
                    ),
                  if (isPlaceholder)
                    Positioned(
                      top: AppDimensions.spacingXS,
                      right: AppDimensions.spacingXS,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.spacingXS,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusSmall,
                          ),
                        ),
                        child: Text(
                          l10n.soundPlaceholderTag,
                          style: AppTypography.bodySmall.copyWith(
                            fontSize: 11,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.spacingXS),
            Text(
              sound.label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.labelMedium.copyWith(
                fontWeight: isPlaying ? FontWeight.w600 : FontWeight.w500,
                color: isPlaceholder
                    ? AppColors.textSecondary
                    : (isPlaying ? AppColors.primary : AppColors.onSurface),
              ),
            ),
            SizedBox(
              height: 18,
              child: isPlaceholder
                  ? Text(
                      l10n.soundPlaceholderTag,
                      textAlign: TextAlign.center,
                      style: AppTypography.labelSmall.copyWith(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  : isLooping
                  ? Text(
                      l10n.soundLooping,
                      textAlign: TextAlign.center,
                      style: AppTypography.labelSmall.copyWith(
                        fontSize: 12,
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
  final double size;

  const _PlayingRipple({required this.color, required this.size});

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
          size: Size.square(widget.size),
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
