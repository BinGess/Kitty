import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../data/models/game_item.dart';
import '../providers/game_config_provider.dart';

class GameSettingsSheet extends ConsumerWidget {
  final GameMode mode;

  const GameSettingsSheet({super.key, required this.mode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(gameConfigProvider);
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusXLarge),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(AppDimensions.spacingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Row(
                  children: [
                    Icon(mode.icon, size: 22, color: mode.color),
                    const SizedBox(width: 8),
                    Text(
                      '${mode.title} 设置',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onBackground,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spacingL),

                // Speed / 频率 slider
                _SettingLabel(
                    title: mode == GameMode.shadowPeek ? '出现频率' : '移动速度'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text('🐢', style: TextStyle(fontSize: 18)),
                    Expanded(
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: mode.color,
                          inactiveTrackColor:
                              mode.color.withValues(alpha: 0.2),
                        ),
                        child: Slider(
                          value: config.speed,
                          onChanged: (v) => ref
                              .read(gameConfigProvider.notifier)
                              .setSpeed(v),
                        ),
                      ),
                    ),
                    const Text('🐇', style: TextStyle(fontSize: 18)),
                  ],
                ),
                const SizedBox(height: AppDimensions.spacingM),

                // Sound toggle
                _SettingSwitch(
                  title: '音效',
                  subtitle: '游戏过程中播放音效',
                  icon: Icons.volume_up,
                  value: config.soundEnabled,
                  color: mode.color,
                  onChanged: (v) =>
                      ref.read(gameConfigProvider.notifier).setSoundEnabled(v),
                ),
                const SizedBox(height: AppDimensions.spacingS),

                // Vibration toggle
                _SettingSwitch(
                  title: '震动反馈',
                  subtitle: '猫咪触碰目标时震动',
                  icon: Icons.vibration,
                  value: config.vibrationEnabled,
                  color: mode.color,
                  onChanged: (v) => ref
                      .read(gameConfigProvider.notifier)
                      .setVibrationEnabled(v),
                ),

                const SizedBox(height: AppDimensions.spacingL),

                // Game description
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppDimensions.spacingM),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusMedium),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline,
                              size: 16, color: AppColors.textSecondary),
                          const SizedBox(width: 6),
                          const Text(
                            '游戏说明',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.onBackground,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        mode.description,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingM),

                // Close button
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => Navigator.pop(context),
                    style: FilledButton.styleFrom(
                      backgroundColor: mode.color,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusMedium),
                      ),
                    ),
                    child: const Text('开始游戏'),
                  ),
                ),
                SizedBox(
                    height: MediaQuery.of(context).padding.bottom + 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingLabel extends StatelessWidget {
  final String title;
  const _SettingLabel({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.onBackground,
      ),
    );
  }
}

class _SettingSwitch extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool value;
  final Color color;
  final ValueChanged<bool> onChanged;

  const _SettingSwitch({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.color,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.onBackground,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeTrackColor: color,
            activeThumbColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
