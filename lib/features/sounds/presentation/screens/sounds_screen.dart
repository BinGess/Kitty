import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/widgets/centered_page_title.dart';
import '../../../personality_test/presentation/providers/cat_personality_provider.dart';
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
    final listenSounds = ref.watch(personalizedListenSoundsProvider);
    final playSounds = ref.watch(personalizedPlaySoundsProvider);
    final ambientSounds = ref.watch(personalizedAmbientSoundsProvider);
    final personalityProfile = ref.watch(currentCatPersonalityProfileProvider);

    return Container(
      color: AppColors.background,
      child: SafeArea(
        child: DefaultTabController(
          length: 3,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppDimensions.spacingM,
                  AppDimensions.spacingS,
                  AppDimensions.spacingM,
                  AppDimensions.spacingM,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CenteredPageTitle(
                      title: l10n.soundsPageTitle,
                      padding: EdgeInsets.zero,
                      trailing: isPlaying
                          ? GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => ref
                                  .read(soundPlaybackProvider.notifier)
                                  .stopAll(),
                              child: Container(
                                width: AppDimensions.touchTargetMin,
                                height: AppDimensions.touchTargetMin,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.12,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.stop_rounded,
                                  size: AppDimensions.iconSmall,
                                  color: AppColors.primary,
                                ),
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(height: AppDimensions.spacingM + 4),
                    if (personalityProfile != null) ...[
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(
                          bottom: AppDimensions.spacingM,
                        ),
                        padding: const EdgeInsets.all(
                          AppDimensions.spacingS + 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusMedium,
                          ),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.24),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.auto_awesome,
                              size: AppDimensions.iconSmall,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: AppDimensions.spacingS),
                            Expanded(
                              child: Text(
                                l10n.personalityRecommendationSubtitle(
                                  personalityProfile.result.personality.code,
                                  personalityProfile.result.personality.title,
                                ),
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.onBackground,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const _CategoryTabBar(),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _TabPane(
                      title: l10n.soundCategoryEmotion,
                      icon: Icons.headphones_rounded,
                      subtitle: l10n.soundsSubtitleEmotion,
                      sounds: listenSounds,
                    ),
                    _TabPane(
                      title: l10n.soundCategoryCalling,
                      icon: Icons.music_note_rounded,
                      subtitle: l10n.soundsSubtitleCalling,
                      sounds: playSounds,
                    ),
                    _TabPane(
                      title: l10n.soundCategoryEnvironment,
                      icon: Icons.spa_rounded,
                      subtitle: l10n.soundsSubtitleEnvironment,
                      sounds: ambientSounds,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryTabBar extends StatelessWidget {
  const _CategoryTabBar();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      height: 44,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),
      child: TabBar(
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
        ),
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: AppTypography.labelMedium.copyWith(
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: AppTypography.labelMedium,
        tabs: [
          Tab(text: l10n.soundCategoryEmotion),
          Tab(text: l10n.soundCategoryCalling),
          Tab(text: l10n.soundCategoryEnvironment),
        ],
      ),
    );
  }
}

class _TabPane extends StatelessWidget {
  final String title;
  final IconData icon;
  final String subtitle;
  final List<SoundItem> sounds;

  const _TabPane({
    required this.title,
    required this.icon,
    required this.subtitle,
    required this.sounds,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.spacingM,
        0,
        AppDimensions.spacingM,
        AppDimensions.spacingL,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(title: title, icon: icon, subtitle: subtitle),
          const SizedBox(height: AppDimensions.spacingS + 4),
          _SoundGrid(sounds: sounds),
        ],
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
          padding: const EdgeInsets.all(AppDimensions.spacingS - 2),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: AppDimensions.iconSmall - 2,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: AppDimensions.spacingS + 2),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTypography.labelLarge.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              subtitle,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.textSecondary,
              ),
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
        crossAxisSpacing: AppDimensions.spacingS,
        mainAxisSpacing: AppDimensions.spacingS,
        childAspectRatio: 0.82,
      ),
      itemCount: sounds.length,
      itemBuilder: (context, index) {
        return SoundCard(sound: sounds[index]);
      },
    );
  }
}
