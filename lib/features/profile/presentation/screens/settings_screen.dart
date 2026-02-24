import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../games/data/models/game_item.dart';
import '../../../games/presentation/widgets/game_settings_sheet.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('设置')),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.spacingM),
        children: [
          const Text(
            '游戏设置',
            style: TextStyle(
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
        ],
      ),
    );
  }
}
