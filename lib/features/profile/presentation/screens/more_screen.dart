import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('更多')),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.spacingM),
        children: [
          _buildMenuItem(
            context,
            icon: Icons.pets,
            title: '猫咪档案',
            subtitle: '管理你的猫咪信息',
            onTap: () => context.go('/more/cats'),
          ),
          _buildMenuItem(
            context,
            icon: Icons.settings,
            title: '设置',
            subtitle: '应用设置',
            onTap: null,
          ),
          _buildMenuItem(
            context,
            icon: Icons.info_outline,
            title: '关于',
            subtitle: '版本信息与反馈',
            onTap: () => context.go('/more/about'),
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
        trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        ),
      ),
    );
  }
}
