import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioService {
  final Map<String, AudioPlayer> _players = {};
  String? _currentlyPlayingId;
  String? _loopingId;

  String? get currentlyPlayingId => _currentlyPlayingId;
  String? get loopingId => _loopingId;
  bool get isLooping => _loopingId != null;

  Future<void> preload(String id, String assetPath) async {
    if (_players.containsKey(id)) return;
    final player = AudioPlayer();
    player.setPlayerMode(PlayerMode.lowLatency);
    player.onPlayerComplete.listen((_) {
      if (_currentlyPlayingId == id && _loopingId != id) {
        _currentlyPlayingId = null;
      }
    });
    _players[id] = player;
  }

  Future<void> playOnce(String id, String assetPath) async {
    await stopAll();
    final player = _getOrCreatePlayer(id);
    try {
      await player.setReleaseMode(ReleaseMode.stop);
      await player.setSource(AssetSource(assetPath));
      await player.resume();
      _currentlyPlayingId = id;
    } catch (e) {
      debugPrint('AudioService: Failed to play $id: $e');
      _currentlyPlayingId = null;
    }
  }

  Future<void> startLoop(String id, String assetPath) async {
    await stopAll();
    final player = _getOrCreatePlayer(id);
    try {
      await player.setReleaseMode(ReleaseMode.loop);
      await player.setSource(AssetSource(assetPath));
      await player.resume();
      _currentlyPlayingId = id;
      _loopingId = id;
    } catch (e) {
      debugPrint('AudioService: Failed to loop $id: $e');
      _currentlyPlayingId = null;
      _loopingId = null;
    }
  }

  Future<void> stopLoop() async {
    if (_loopingId != null) {
      final player = _players[_loopingId];
      if (player != null) {
        await player.stop();
        await player.setReleaseMode(ReleaseMode.stop);
      }
      _currentlyPlayingId = null;
      _loopingId = null;
    }
  }

  Future<void> stopAll() async {
    await stopLoop();
    if (_currentlyPlayingId != null) {
      final player = _players[_currentlyPlayingId];
      if (player != null) {
        await player.stop();
      }
      _currentlyPlayingId = null;
    }
  }

  AudioPlayer _getOrCreatePlayer(String id) {
    if (!_players.containsKey(id)) {
      final player = AudioPlayer();
      player.setPlayerMode(PlayerMode.lowLatency);
      player.onPlayerComplete.listen((_) {
        if (_currentlyPlayingId == id && _loopingId != id) {
          _currentlyPlayingId = null;
        }
      });
      _players[id] = player;
    }
    return _players[id]!;
  }

  void dispose() {
    for (final player in _players.values) {
      player.dispose();
    }
    _players.clear();
    _currentlyPlayingId = null;
    _loopingId = null;
  }
}
