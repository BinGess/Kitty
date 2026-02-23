import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/models/game_item.dart';
import '../providers/game_provider.dart';
import '../widgets/game_card.dart';

class GameMenuScreen extends ConsumerWidget {
  const GameMenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            children: [
              Row(
                children: [
                  const Text(
                    '🐱 猫咪语言 · 玩个游戏',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onBackground,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.music_note,
                        size: 18, color: AppColors.textSecondary),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...GameMode.values.map((mode) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GameCard(
                      mode: mode,
                      onTap: () {
                        ref.read(selectedGameProvider.notifier).select(mode);
                        context.push('/game-play/${mode.id}');
                      },
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
