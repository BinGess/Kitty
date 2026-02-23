import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/audio/audio_service.dart';
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

final soundPlaybackProvider =
    NotifierProvider<SoundPlaybackNotifier, SoundPlaybackState>(
        SoundPlaybackNotifier.new);

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
