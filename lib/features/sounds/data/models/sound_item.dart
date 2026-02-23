import 'package:flutter/material.dart';

enum SoundCategory {
  listen('嗨，听听它'),
  play('或，叫它玩');

  final String label;
  const SoundCategory(this.label);
}

class SoundItem {
  final String id;
  final SoundCategory category;
  final String label;
  final String imagePath;
  final IconData icon;
  final String assetPath;
  final bool isLoopable;

  const SoundItem({
    required this.id,
    required this.category,
    required this.label,
    required this.imagePath,
    required this.icon,
    required this.assetPath,
    this.isLoopable = false,
  });
}
