import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class CatListScreen extends StatelessWidget {
  const CatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('猫咪档案')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.pets, size: 64, color: AppColors.primary),
            SizedBox(height: 16),
            Text('还没有猫咪', style: TextStyle(fontSize: 20)),
            SizedBox(height: 8),
            Text('点击右下角添加你的第一只猫咪',
                style: TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
