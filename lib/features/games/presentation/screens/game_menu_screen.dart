import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/widgets/centered_page_title.dart';
import '../../../personality_test/domain/cat_personality_profile.dart';
import '../../../personality_test/presentation/providers/cat_personality_provider.dart';
import '../../data/models/game_item.dart';
import '../providers/game_provider.dart';
import '../widgets/game_card.dart';

class GameMenuScreen extends ConsumerWidget {
  const GameMenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final personalityProfile = ref.watch(currentCatPersonalityProfileProvider);
    final personalityCode = personalityProfile?.result.personality.code;
    final sortedModes = PersonalityRecommendationEngine.sortedGameModes(
      GameMode.values,
      personalityCode,
    );
    final recommendedIds = PersonalityRecommendationEngine.recommendedGameIds(
      personalityCode,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            children: [
              CenteredPageTitle(
                title: l10n.gamesPageTitle,
                padding: EdgeInsets.zero,
              ),
              if (personalityProfile != null) ...[
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    l10n.personalityRecommendationSubtitle(
                      personalityProfile.result.personality.code,
                      personalityProfile.result.personality.title,
                    ),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              ...sortedModes.map(
                (mode) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GameCard(
                    mode: mode,
                    badgeText: recommendedIds.contains(mode.id)
                        ? l10n.personalityRecommendedBadge
                        : null,
                    onTap: () {
                      ref.read(selectedGameProvider.notifier).select(mode);
                      context.push('/game-play/${mode.id}');
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
