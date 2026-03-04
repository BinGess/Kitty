import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/providers/current_cat_provider.dart';
import '../../../../core/widgets/centered_page_title.dart';
import '../../data/models/question.dart';
import '../../domain/cat_personality_profile.dart';
import '../providers/cat_personality_provider.dart';
import '../providers/test_provider.dart';

class TestIntroScreen extends ConsumerWidget {
  const TestIntroScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final currentCat = ref.watch(currentCatProvider);
    final profile = ref.watch(currentCatPersonalityProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            children: [
              CenteredPageTitle(
                title: l10n.testTitle,
                padding: EdgeInsets.zero,
              ),
              if (profile == null) ...[
                const SizedBox(height: AppDimensions.spacingL),
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.psychology,
                    size: 64,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingL),
                Text(
                  l10n.testSubtitle,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onBackground,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingS),
                Text(
                  l10n.testTheoryDesc,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingXL),
              ] else ...[
                const SizedBox(height: AppDimensions.spacingL),
                _SavedResultCard(profile: profile),
                const SizedBox(height: AppDimensions.spacingL),
                _RetakeDivider(text: l10n.testResultRetake),
                const SizedBox(height: AppDimensions.spacingL),
              ],

              // Mode selection cards
              _ModeCard(
                mode: TestMode.basic,
                icon: Icons.flash_on,
                color: AppColors.primary,
                subtitle: l10n.testBasicModeDesc,
                onTap: () => _startTest(
                  context,
                  ref,
                  TestMode.basic,
                  catId: currentCat?.id,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingM),
              _ModeCard(
                mode: TestMode.advanced,
                icon: Icons.auto_awesome,
                color: AppColors.primaryDark,
                subtitle: l10n.testAdvancedModeDesc,
                onTap: () => _startTest(
                  context,
                  ref,
                  TestMode.advanced,
                  catId: currentCat?.id,
                ),
              ),

              if (profile == null) ...[
                const SizedBox(height: AppDimensions.spacingXL),
                Container(
                  padding: const EdgeInsets.all(AppDimensions.spacingM),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusMedium,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.tips_and_updates,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      const SizedBox(width: AppDimensions.spacingS),
                      Expanded(
                        child: Text(
                          l10n.testTip,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: AppDimensions.spacingXL),
            ],
          ),
        ),
      ),
    );
  }

  void _startTest(
    BuildContext context,
    WidgetRef ref,
    TestMode mode, {
    int? catId,
  }) {
    ref
        .read(testProvider.notifier)
        .startTest(
          mode,
          catId: catId,
          languageCode: Localizations.localeOf(context).languageCode,
        );
    context.push('/test/question');
  }
}

class _SavedResultCard extends StatelessWidget {
  final CatPersonalityProfile profile;

  const _SavedResultCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final personality = profile.result.personality;
    final timeText = DateFormat('yyyy-MM-dd HH:mm').format(profile.testedAt);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.spacingL),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.testCurrentResultTitle,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                personality.code,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  personality.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onBackground,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingS),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: personality.tags.map<Widget>((tag) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  tag,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryDark,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppDimensions.spacingS),
          Text(
            l10n.testLastTestedAt(timeText),
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            personality.description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.onBackground,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _RetakeDivider extends StatelessWidget {
  final String text;

  const _RetakeDivider({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.divider)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.divider)),
      ],
    );
  }
}

class _ModeCard extends StatelessWidget {
  final TestMode mode;
  final IconData icon;
  final Color color;
  final String subtitle;
  final VoidCallback onTap;

  const _ModeCard({
    required this.mode,
    required this.icon,
    required this.color,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final modeTitle = switch (mode) {
      TestMode.basic => l10n.testBasicMode,
      TestMode.advanced => l10n.testAdvancedMode,
    };
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppDimensions.spacingL),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          border: Border.all(color: AppColors.divider),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: AppDimensions.spacingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        modeTitle,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onBackground,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          l10n.testQuestionCount(mode.questionCount),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: color,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.divider),
          ],
        ),
      ),
    );
  }
}
