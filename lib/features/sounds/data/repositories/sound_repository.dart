import 'package:flutter/material.dart';
import '../models/sound_item.dart';

class SoundRepository {
  static const _img = 'assets/images/sounds';

  static const List<SoundItem> allSounds = [
    // ══════ 嗨，听听它（猫咪情绪表达）══════
    SoundItem(
      id: 'purr',
      category: SoundCategory.listen,
      label: '喵力引擎',
      imagePath: '$_img/purr.png',
      icon: Icons.favorite,
      assetPath: 'sounds/emotion/1.mp3',
      isLoopable: true,
    ),
    SoundItem(
      id: 'meow',
      category: SoundCategory.listen,
      label: '撒娇技能',
      imagePath: '$_img/meow.png',
      icon: Icons.chat_bubble,
      assetPath: 'sounds/emotion/2.mp3',
    ),
    SoundItem(
      id: 'hiss',
      category: SoundCategory.listen,
      label: '怒气值 +99',
      imagePath: '$_img/hiss.png',
      icon: Icons.flash_on,
      assetPath: 'sounds/emotion/3.mp3',
    ),
    SoundItem(
      id: 'chattering',
      category: SoundCategory.listen,
      label: '快乐值 MAX',
      imagePath: '$_img/chattering.png',
      icon: Icons.pest_control,
      assetPath: 'sounds/emotion/4.mp3',
    ),
    SoundItem(
      id: 'hungry',
      category: SoundCategory.listen,
      label: '供粮请求',
      imagePath: '$_img/hungry.png',
      icon: Icons.restaurant,
      assetPath: 'sounds/emotion/5.mp3',
    ),
    SoundItem(
      id: 'whimper',
      category: SoundCategory.listen,
      label: '快来摸我～',
      imagePath: '$_img/whimper.png',
      icon: Icons.sentiment_dissatisfied,
      assetPath: 'sounds/emotion/6.mp3',
    ),

    // ══════ 或，叫它玩（召唤 & 环境诱导）══════
    SoundItem(
      id: 'can_opener',
      category: SoundCategory.play,
      label: '召唤本喵现身',
      imagePath: '$_img/can_opener.png',
      icon: Icons.kitchen,
      assetPath: 'sounds/calling/7.mp3',
    ),
    SoundItem(
      id: 'food_shaking',
      category: SoundCategory.play,
      label: '召唤本喵吃饭',
      imagePath: '$_img/food_shaking.png',
      icon: Icons.inventory_2,
      assetPath: 'sounds/calling/8.mp3',
    ),
    SoundItem(
      id: 'water',
      category: SoundCategory.play,
      label: '召唤本喵喝水',
      imagePath: '$_img/water.png',
      icon: Icons.water_drop,
      assetPath: 'sounds/environment/9.mp3',
      isLoopable: true,
    ),
    SoundItem(
      id: 'white_noise',
      category: SoundCategory.play,
      label: '睡眠引导模式',
      imagePath: '$_img/white_noise.png',
      icon: Icons.cloud,
      assetPath: 'sounds/environment/10.mp3',
      isLoopable: true,
    ),
    SoundItem(
      id: 'bell',
      category: SoundCategory.play,
      label: '警告：叮叮叮！',
      imagePath: '$_img/bell.png',
      icon: Icons.notifications_active,
      assetPath: 'sounds/calling/11.mp3',
    ),
    SoundItem(
      id: 'squeaky_toy',
      category: SoundCategory.play,
      label: '装备：铃铛 +1',
      imagePath: '$_img/squeaky_toy.png',
      icon: Icons.toys,
      assetPath: 'sounds/calling/12.mp3',
    ),
    SoundItem(
      id: 'mouse_sounds',
      category: SoundCategory.play,
      label: '偷袭：老鼠出没',
      imagePath: '$_img/mouse_sounds.png',
      icon: Icons.cruelty_free,
      assetPath: 'sounds/environment/13.mp3',
    ),
    SoundItem(
      id: 'plastic_bag',
      category: SoundCategory.play,
      label: '零食召唤术',
      imagePath: '$_img/plastic_bag.png',
      icon: Icons.shopping_bag,
      assetPath: 'sounds/calling/14.mp3',
    ),
    SoundItem(
      id: 'bird_sounds',
      category: SoundCategory.play,
      label: '喵星频道来电',
      imagePath: '$_img/bird_sounds.png',
      icon: Icons.forest,
      assetPath: 'sounds/environment/15.mp3',
      isLoopable: true,
    ),
    SoundItem(
      id: 'can_open',
      category: SoundCategory.play,
      label: '开罐头',
      imagePath: '$_img/can_opener.png',
      icon: Icons.takeout_dining,
      assetPath: 'sounds/environment/16.mp3',
    ),
    SoundItem(
      id: 'comeback',
      category: SoundCategory.play,
      label: '你回来了',
      imagePath: '$_img/comeback.png',
      icon: Icons.home,
      assetPath: 'sounds/environment/17.mp3',
    ),
    SoundItem(
      id: 'squeaky_toys',
      category: SoundCategory.play,
      label: '响纸玩具',
      imagePath: '$_img/squeaky_toys.png',
      icon: Icons.auto_awesome,
      assetPath: 'sounds/environment/18.mp3',
    ),
  ];

  List<SoundItem> getSoundsByCategory(SoundCategory category) {
    return allSounds.where((s) => s.category == category).toList();
  }
}
