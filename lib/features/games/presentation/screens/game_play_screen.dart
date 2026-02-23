import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/game_item.dart';
import '../games/game_widget_factory.dart';
import '../providers/game_config_provider.dart';
import '../widgets/game_settings_sheet.dart';

class GamePlayScreen extends ConsumerStatefulWidget {
  final String gameId;

  const GamePlayScreen({super.key, required this.gameId});

  @override
  ConsumerState<GamePlayScreen> createState() => _GamePlayScreenState();
}

class _GamePlayScreenState extends ConsumerState<GamePlayScreen> {
  bool _showUI = true;
  Timer? _hideUITimer;
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

    _scheduleHideUI();
  }

  void _scheduleHideUI() {
    _hideUITimer?.cancel();
    _hideUITimer = Timer(const Duration(seconds: 3), () {
      if (mounted) setState(() => _showUI = false);
    });
  }

  void _onTapScreen() {
    setState(() => _showUI = !_showUI);
    if (_showUI) _scheduleHideUI();
  }

  void _exitGame() {
    // 退出沉浸式，恢复系统栏
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  void _showSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => GameSettingsSheet(mode: _mode!),
    );
  }

  @override
  void dispose() {
    _hideUITimer?.cancel();
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

            // 透明层：点击显示/隐藏控件（不阻挡子组件，仅作为 tap 目标）
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _onTapScreen,
              ),
            ),

            // 左上角关闭按钮，点击退出沉浸式
              Positioned(
                left: 0,
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

              // Top bar
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                top: _showUI ? 0 : -120,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        const SizedBox(width: 48),
                        Expanded(
                          child: Text(
                            mode.title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: _showSettings,
                          icon: Icon(
                            Icons.tune_rounded,
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom hint
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                bottom: _showUI ? 0 : -80,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      '点击左上角关闭退出  |  点击屏幕显示/隐藏控件',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.4),
                        fontSize: 12,
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
