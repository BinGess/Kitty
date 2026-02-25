import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/widgets/centered_page_title.dart';
import '../../data/models/sound_item.dart';
import '../../data/repositories/sound_repository.dart';
import '../providers/sounds_provider.dart';
import '../widgets/sound_card.dart';

class SoundsScreen extends ConsumerStatefulWidget {
  const SoundsScreen({super.key});

  @override
  ConsumerState<SoundsScreen> createState() => _SoundsScreenState();
}

class _SoundsScreenState extends ConsumerState<SoundsScreen> {
  bool _precacheDone = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_precacheDone) return;
    _precacheDone = true;
    for (final sound in SoundRepository.allSounds) {
      precacheImage(AssetImage(sound.imagePath), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final playbackState = ref.watch(soundPlaybackProvider);
    final isPlaying = playbackState.playingId != null;
    final listenSounds = ref.watch(listenSoundsProvider);
    final playSounds = ref.watch(playSoundsProvider);

    return Container(
      color: AppColors.background,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── 顶部标题栏 ──
              CenteredPageTitle(
                title: l10n.soundsPageTitle,
                padding: EdgeInsets.zero,
                trailing: isPlaying
                    ? GestureDetector(
                        onTap: () =>
                            ref.read(soundPlaybackProvider.notifier).stopAll(),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.stop_rounded,
                            size: 18,
                            color: AppColors.primary,
                          ),
                        ),
                      )
                    : null,
              ),
              const SizedBox(height: 20),

              // ── 分区1 ──
              _SectionHeader(
                title: SoundCategory.listen.label,
                icon: Icons.headphones_rounded,
                subtitle: l10n.soundsSubtitleEmotion,
              ),
              const SizedBox(height: 12),
              _SoundGrid(sounds: listenSounds),
              const SizedBox(height: 24),

              // ── 分隔线 ──
              Row(
                children: [
                  const Expanded(child: Divider(color: AppColors.divider)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Icon(
                      Icons.pets,
                      size: 14,
                      color: AppColors.textSecondary.withValues(alpha: 0.4),
                    ),
                  ),
                  const Expanded(child: Divider(color: AppColors.divider)),
                ],
              ),
              const SizedBox(height: 24),

              // ── 分区2 ──
              _SectionHeader(
                title: SoundCategory.play.label,
                icon: Icons.music_note_rounded,
                subtitle: l10n.soundsSubtitleCalling,
              ),
              const SizedBox(height: 12),
              _SoundGrid(sounds: playSounds),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final String subtitle;
  const _SectionHeader({
    required this.title,
    required this.icon,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: AppColors.primary),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.onBackground,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
          ],
        ),
      ],
    );
  }
}

class _SoundGrid extends StatelessWidget {
  final List<SoundItem> sounds;
  const _SoundGrid({required this.sounds});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.82,
      ),
      itemCount: sounds.length,
      itemBuilder: (context, index) {
        return SoundCard(sound: sounds[index]);
      },
    );
  }
}
