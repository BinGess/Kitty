import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../games/data/models/game_item.dart';
import '../../../games/presentation/widgets/game_settings_sheet.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = ref.watch(localeProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(l10n.settingsPageTitle)),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.spacingM),
        children: [
          // ── Game Settings ──
          Text(
            l10n.settingsGameSection,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.onBackground,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingS),
          ...GameMode.values.map(
            (mode) => Card(
              margin: const EdgeInsets.only(bottom: AppDimensions.spacingS),
              child: ListTile(
                title: Text(mode.title),
                subtitle: Text(
                  mode.subtitle,
                  style: const TextStyle(fontSize: 12),
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: AppColors.textSecondary,
                ),
                onTap: () => showModalBottomSheet(
                  context: context,
                  useRootNavigator: true,
                  isScrollControlled: true,
                  useSafeArea: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => Padding(
                    padding: const EdgeInsets.only(
                      bottom: kBottomNavigationBarHeight,
                    ),
                    child: GameSettingsSheet(mode: mode),
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    AppDimensions.radiusLarge,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: AppDimensions.spacingL),

          // ── Language Settings ──
          Text(
            l10n.settingsLanguageSection,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.onBackground,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingXS),
          Text(
            l10n.settingsLanguageDesc,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingS),
          _LanguageOption(
            label: l10n.settingsLanguageSystem,
            icon: Icons.language,
            isSelected: currentLocale == null,
            onTap: () => ref.read(localeProvider.notifier).setLocale(null),
          ),
          const SizedBox(height: AppDimensions.spacingXS),
          _LanguageOption(
            label: l10n.settingsLanguageChinese,
            flag: '🇨🇳',
            isSelected: currentLocale?.languageCode == 'zh',
            onTap: () => ref
                .read(localeProvider.notifier)
                .setLocale(const Locale('zh')),
          ),
          const SizedBox(height: AppDimensions.spacingXS),
          _LanguageOption(
            label: l10n.settingsLanguageEnglish,
            flag: '🇺🇸',
            isSelected: currentLocale?.languageCode == 'en',
            onTap: () => ref
                .read(localeProvider.notifier)
                .setLocale(const Locale('en')),
          ),
        ],
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String label;
  final String? flag;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.flag,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            if (flag != null)
              Text(flag!, style: const TextStyle(fontSize: 20))
            else if (icon != null)
              Icon(icon,
                  size: 20,
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textSecondary),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? AppColors.primaryDark
                    : AppColors.onSurface,
              ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColors.primary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
