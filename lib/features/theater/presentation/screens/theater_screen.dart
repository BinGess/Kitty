import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/l10n/app_localizations.dart';

class TheaterScreen extends StatelessWidget {
  const TheaterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.moreTheater)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.video_library, size: 64, color: AppColors.primary),
            SizedBox(height: 16),
            Text(l10n.moreTheater, style: const TextStyle(fontSize: 20)),
            SizedBox(height: 8),
            Text(
              l10n.theaterSubtitle,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
