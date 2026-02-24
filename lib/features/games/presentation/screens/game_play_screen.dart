import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/game_item.dart';
import '../games/game_widget_factory.dart';
import '../providers/game_config_provider.dart';

class GamePlayScreen extends ConsumerStatefulWidget {
  final String gameId;

  const GamePlayScreen({super.key, required this.gameId});

  @override
  ConsumerState<GamePlayScreen> createState() => _GamePlayScreenState();
}

class _GamePlayScreenState extends ConsumerState<GamePlayScreen> {
  GameMode? _mode;

  @override
  void initState() {
    super.initState();
    _mode = GameMode.values.firstWhere(
      (m) => m.id == widget.gameId,
      orElse: () => GameMode.laser,
    );

    // 沉浸式：自动隐藏 Home Bar 及系统通知栏
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  void _exitGame() {
    // 退出沉浸式，恢复系统栏
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mode = _mode!;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _exitGame();
      },
      child: Scaffold(
        backgroundColor: mode.backgroundColor,
        body: Stack(
          children: [
            // 游戏内容区域（不响应父级 tap，由各游戏自行处理点击）
            Positioned.fill(
              child: Consumer(
                builder: (context, ref, _) {
                  final config = ref.watch(gameConfigProvider);
                  final gameWidget = buildGameWidget(
                    mode: mode,
                    config: config,
                  );
                  return gameWidget;
                },
              ),
            ),
            // 右上角关闭按钮，点击退出沉浸式
            Positioned(
              right: 0,
              top: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Material(
                    color: Colors.white.withValues(alpha: 0.15),
                    shape: const CircleBorder(),
                    child: InkWell(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        _exitGame();
                      },
                      customBorder: const CircleBorder(),
                      child: const Padding(
                        padding: EdgeInsets.all(12),
                        child: Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
