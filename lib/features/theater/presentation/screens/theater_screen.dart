import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class TheaterScreen extends StatelessWidget {
  const TheaterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('喵剧场')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.video_library, size: 64, color: AppColors.primary),
            SizedBox(height: 16),
            Text('喵剧场', style: TextStyle(fontSize: 20)),
            SizedBox(height: 8),
            Text('精选猫咪视频内容',
                style: TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
