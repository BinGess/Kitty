import 'package:flutter/material.dart';

enum SoundCategory { listen, play, ambient }

class SoundItem {
  final String id;
  final SoundCategory category;
  final String label;
  final String imagePath;
  final double visualScale;
  final IconData icon;
  final String assetPath;
  final bool isLoopable;
  final bool isPlaceholder;

  const SoundItem({
    required this.id,
    required this.category,
    required this.label,
    required this.imagePath,
    this.visualScale = 1.0,
    required this.icon,
    required this.assetPath,
    this.isLoopable = false,
    this.isPlaceholder = false,
  });
}
