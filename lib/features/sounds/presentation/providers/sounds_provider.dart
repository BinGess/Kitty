import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/audio/audio_service.dart';
import '../../../personality_test/domain/cat_personality_profile.dart';
import '../../../personality_test/presentation/providers/cat_personality_provider.dart';
import '../../data/models/sound_item.dart';
import '../../data/repositories/sound_repository.dart';

final audioServiceProvider = Provider<AudioService>((ref) {
  final service = AudioService();
  ref.onDispose(() => service.dispose());
  return service;
});

final soundRepositoryProvider = Provider<SoundRepository>((ref) {
  return SoundRepository();
});

final listenSoundsProvider = Provider<List<SoundItem>>((ref) {
  return SoundRepository.allSounds
      .where((s) => s.category == SoundCategory.listen)
      .toList();
});

final playSoundsProvider = Provider<List<SoundItem>>((ref) {
  return SoundRepository.allSounds
      .where((s) => s.category == SoundCategory.play)
      .toList();
});

final ambientSoundsProvider = Provider<List<SoundItem>>((ref) {
  return SoundRepository.allSounds
      .where((s) => s.category == SoundCategory.ambient)
      .toList();
});

final personalityRecommendedSoundIdsProvider = Provider<Set<String>>((ref) {
  final profile = ref.watch(currentCatPersonalityProfileProvider);
  if (profile == null) return {};
  return PersonalityRecommendationEngine.recommendedSoundIds(
    profile.result.personality.code,
  );
});

final personalizedListenSoundsProvider = Provider<List<SoundItem>>((ref) {
  final sounds = ref.watch(listenSoundsProvider);
  final recommendedIds = ref.watch(personalityRecommendedSoundIdsProvider);
  return _sortSoundsByRecommendation(sounds, recommendedIds);
});

final personalizedPlaySoundsProvider = Provider<List<SoundItem>>((ref) {
  final sounds = ref.watch(playSoundsProvider);
  final recommendedIds = ref.watch(personalityRecommendedSoundIdsProvider);
  return _sortSoundsByRecommendation(sounds, recommendedIds);
});

final personalizedAmbientSoundsProvider = Provider<List<SoundItem>>((ref) {
  final sounds = ref.watch(ambientSoundsProvider);
  final recommendedIds = ref.watch(personalityRecommendedSoundIdsProvider);
  return _sortSoundsByRecommendation(sounds, recommendedIds);
});

List<SoundItem> _sortSoundsByRecommendation(
  List<SoundItem> sounds,
  Set<String> recommendedIds,
) {
  if (recommendedIds.isEmpty) return sounds;

  final recommended = <SoundItem>[];
  final others = <SoundItem>[];

  for (final sound in sounds) {
    if (recommendedIds.contains(sound.id)) {
      recommended.add(sound);
    } else {
      others.add(sound);
    }
  }

  return [...recommended, ...others];
}

final soundPlaybackProvider =
    NotifierProvider<SoundPlaybackNotifier, SoundPlaybackState>(
      SoundPlaybackNotifier.new,
    );

class SoundPlaybackState {
  final String? playingId;
  final bool isLooping;

  const SoundPlaybackState({this.playingId, this.isLooping = false});

  SoundPlaybackState copyWith({String? playingId, bool? isLooping}) {
    return SoundPlaybackState(
      playingId: playingId,
      isLooping: isLooping ?? this.isLooping,
    );
  }

  static const idle = SoundPlaybackState();
}

class SoundPlaybackNotifier extends Notifier<SoundPlaybackState> {
  @override
  SoundPlaybackState build() => SoundPlaybackState.idle;

  AudioService get _audio => ref.read(audioServiceProvider);

  Future<void> playOnce(SoundItem sound) async {
    if (state.playingId == sound.id && !state.isLooping) {
      await _audio.stopAll();
      state = SoundPlaybackState.idle;
      return;
    }
    await _audio.playOnce(sound.id, sound.assetPath);
    state = SoundPlaybackState(playingId: sound.id, isLooping: false);

    Future.delayed(const Duration(seconds: 5), () {
      if (state.playingId == sound.id && !state.isLooping) {
        if (_audio.currentlyPlayingId != sound.id) {
          state = SoundPlaybackState.idle;
        }
      }
    });
  }

  Future<void> toggleLoop(SoundItem sound) async {
    if (!sound.isLoopable) {
      debugPrint('Sound ${sound.id} is not loopable');
      return;
    }

    if (state.playingId == sound.id && state.isLooping) {
      await _audio.stopLoop();
      state = SoundPlaybackState.idle;
      return;
    }

    await _audio.startLoop(sound.id, sound.assetPath);
    state = SoundPlaybackState(playingId: sound.id, isLooping: true);
  }

  Future<void> stopAll() async {
    await _audio.stopAll();
    state = SoundPlaybackState.idle;
  }
}
