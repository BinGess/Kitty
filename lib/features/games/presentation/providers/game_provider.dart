import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/game_item.dart';

final selectedGameProvider =
    NotifierProvider<SelectedGameNotifier, GameMode?>(
        SelectedGameNotifier.new);

class SelectedGameNotifier extends Notifier<GameMode?> {
  @override
  GameMode? build() => null;

  void select(GameMode mode) => state = mode;
  void clear() => state = null;
}
