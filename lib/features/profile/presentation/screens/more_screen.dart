import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/l10n/app_localizations.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.moreTitle)),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.spacingM),
        children: [
          _buildMenuItem(
            context,
            icon: Icons.pets,
            title: l10n.moreCatProfile,
            subtitle: l10n.moreCatProfileSubtitle,
            onTap: () => context.push('/more/cats'),
          ),
          _buildMenuItem(
            context,
            icon: Icons.settings,
            title: l10n.moreSettings,
            subtitle: l10n.moreSettingsSubtitle,
            onTap: () => context.push('/more/settings'),
          ),
          _buildMenuItem(
            context,
            icon: Icons.info_outline,
            title: l10n.moreAbout,
            subtitle: l10n.moreAboutSubtitle,
            onTap: () => context.push('/more/about'),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacingS),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(
          Icons.chevron_right,
          color: AppColors.textSecondary,
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        ),
      ),
    );
  }
}
