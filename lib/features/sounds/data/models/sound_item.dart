import 'package:flutter/material.dart';
import '../../../../core/l10n/app_localizations.dart';

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

extension SoundItemLocalizedLabel on SoundItem {
  String localizedLabel(AppLocalizations l10n) {
    switch (id) {
      case 'purr':
        return l10n.soundNamePurr;
      case 'meow':
        return l10n.soundNameMeow;
      case 'hiss':
        return l10n.soundNameHiss;
      case 'chattering':
        return l10n.soundNameChattering;
      case 'hungry':
        return l10n.soundNameHungry;
      case 'whimper':
        return l10n.soundNameWhimper;
      case 'can_opener':
        return l10n.soundNameCanOpener;
      case 'food_shaking':
        return l10n.soundNameFoodShaking;
      case 'water':
        return l10n.soundNameWater;
      case 'white_noise':
        return l10n.soundNameWhiteNoise;
      case 'bell':
        return l10n.soundNameBell;
      case 'squeaky_toy':
        return l10n.soundNameSqueakyToy;
      case 'mouse_sounds':
        return l10n.soundNameMouseSounds;
      case 'plastic_bag':
        return l10n.soundNamePlasticBag;
      case 'bird_sounds':
        return l10n.soundNameBirdSounds;
      case 'can_open':
        return l10n.soundNameCanOpen;
      case 'comeback':
        return l10n.soundNameComeback;
      case 'squeaky_toys':
        return l10n.soundNameSqueakyToys;
      case 'ambient_white_noise':
        return l10n.soundNameAmbientWhiteNoise;
      case 'ambient_water':
        return l10n.soundNameAmbientWater;
      case 'ambient_bird_sounds':
        return l10n.soundNameAmbientBirdSounds;
      case 'ambient_feather':
        return l10n.soundNameAmbientFeather;
      case 'ambient_mouse_sounds':
        return l10n.soundNameAmbientMouseSounds;
      case 'music_cat_specific':
        return l10n.soundNameMusicCatSpecific;
      case 'music_slow_classical':
        return l10n.soundNameMusicSlowClassical;
      case 'music_noise_blend':
        return l10n.soundNameMusicNoiseBlend;
      case 'music_nature_ambience':
        return l10n.soundNameMusicNatureAmbience;
      case 'music_ambient_drone':
        return l10n.soundNameMusicAmbientDrone;
      case 'music_soft_interaction':
        return l10n.soundNameMusicSoftInteraction;
      default:
        return label;
    }
  }
}
