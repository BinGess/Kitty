import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/providers/current_cat_provider.dart';
import '../../../../core/providers/play_reward_provider.dart';
import '../../data/models/game_item.dart';
import '../games/game_widget_factory.dart';
import '../providers/game_config_provider.dart';

class GamePlayScreen extends ConsumerStatefulWidget {
  final String gameId;

  const GamePlayScreen({super.key, required this.gameId});

  @override
  ConsumerState<GamePlayScreen> createState() => _GamePlayScreenState();
}

class _GamePlayScreenState extends ConsumerState<GamePlayScreen>
    with SingleTickerProviderStateMixin {
  static const Duration _sessionDuration = Duration(seconds: 30);
  static const Duration _finalPhaseDuration = Duration(seconds: 5);
  static const Duration _autoExitDelay = Duration(milliseconds: 1800);

  GameMode? _mode;
  late final Ticker _ticker;
  bool _finalPhaseActive = false;
  bool _finalCaptured = false;
  bool _sessionEnding = false;
  String? _endingMessage;
  Duration _lastTickElapsed = Duration.zero;
  int _finalCountdown = _finalPhaseDuration.inSeconds;

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

    _ticker = createTicker(_onTick)..start();
  }

  void _onTick(Duration elapsed) {
    if (!mounted || _sessionEnding) return;

    if (!_finalPhaseActive &&
        elapsed >= (_sessionDuration - _finalPhaseDuration)) {
      setState(() {
        _finalPhaseActive = true;
      });
    }

    if (_finalPhaseActive) {
      final remainingMs = (_sessionDuration - elapsed).inMilliseconds;
      final clampedMs = remainingMs.clamp(0, _sessionDuration.inMilliseconds);
      final secondsLeft = (clampedMs / 1000).ceil();
      if (secondsLeft != _finalCountdown) {
        setState(() {
          _finalCountdown = secondsLeft;
        });
      }
    }

    if (_lastTickElapsed < _sessionDuration && elapsed >= _sessionDuration) {
      _finishAndExit(captured: _finalCaptured);
    }
    _lastTickElapsed = elapsed;
    setState(() {});
  }

  void _onFinalCapture() {
    if (_finalCaptured || _sessionEnding) return;
    setState(() {
      _finalCaptured = true;
    });
    _finishAndExit(captured: true);
  }

  void _finishAndExit({required bool captured}) {
    if (_sessionEnding) return;
    _sessionEnding = true;
    _ticker.stop();
    _syncPlayReward(captured);
  }

  Future<void> _syncPlayReward(bool captured) async {
    final l10n = AppLocalizations.of(context)!;
    String message;
    final cat = ref.read(currentCatProvider);
    if (cat != null) {
      final stats = await ref
          .read(playRewardServiceProvider)
          .recordSession(
            cat: cat,
            gameId: _mode?.id ?? GameMode.laser.id,
            captured: captured,
            sessionDuration: _lastTickElapsed > Duration.zero
                ? _lastTickElapsed
                : _sessionDuration,
          );
      if (captured) {
        message = stats.captureGoalReached
            ? l10n.gameRewardCapturedGoal(stats.lastRewardMl.toString())
            : l10n.gameRewardCapturedProgress(
                stats.lastRewardMl.toString(),
                stats.capturesToday,
                stats.captureGoal,
              );
        message = '$message (${stats.modeLabel})';
      } else {
        message = l10n.gameRewardSessionEnd(
          stats.capturesToday,
          stats.captureGoal,
        );
      }
    } else {
      message = captured
          ? l10n.gameRewardCapturedNoCat
          : l10n.gameRewardSessionEndNoCat;
    }

    if (!mounted) return;
    setState(() {
      _finalPhaseActive = false;
      _endingMessage = message;
    });

    Future.delayed(_autoExitDelay, () {
      if (!mounted) return;
      _exitGame();
    });
  }

  void _exitGame() {
    _ticker.stop();
    // 退出沉浸式，恢复系统栏
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
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
            // 收尾可捕获目标：游戏尾段会出现可抓取终局目标，补齐“追逐-捕获”闭环
            Positioned.fill(
              child: _FinalCaptureOverlay(
                mode: mode,
                active: _finalPhaseActive && !_sessionEnding,
                countdown: _finalCountdown,
                onCaptured: _onFinalCapture,
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
            // 顶部进度条：显示剩余游戏时间
            if (!_sessionEnding)
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                child: _TimeProgressBar(
                  elapsed: _lastTickElapsed,
                  total: _sessionDuration,
                  color: mode.accentColor,
                ),
              ),
            if (_endingMessage != null)
              Positioned.fill(
                child: IgnorePointer(
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.45),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        _endingMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
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

class _FinalCaptureOverlay extends StatefulWidget {
  final GameMode mode;
  final bool active;
  final int countdown;
  final VoidCallback onCaptured;

  const _FinalCaptureOverlay({
    required this.mode,
    required this.active,
    required this.countdown,
    required this.onCaptured,
  });

  @override
  State<_FinalCaptureOverlay> createState() => _FinalCaptureOverlayState();
}

class _FinalCaptureOverlayState extends State<_FinalCaptureOverlay>
    with SingleTickerProviderStateMixin {
  final math.Random _rng = math.Random();
  late final Ticker _ticker;
  Offset _targetNorm = const Offset(0.5, 0.58);
  Duration _lastMoveElapsed = Duration.zero;
  double _waveT = 0;
  bool _captured = false;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
    _syncTicker();
  }

  @override
  void didUpdateWidget(covariant _FinalCaptureOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active && !oldWidget.active) {
      _captured = false;
      _targetNorm = _randomNorm();
      _lastMoveElapsed = Duration.zero;
    }
    _syncTicker();
  }

  void _syncTicker() {
    if (widget.active && !_captured) {
      if (!_ticker.isActive) {
        _ticker.start();
      }
    } else {
      _ticker.stop();
    }
  }

  void _onTick(Duration elapsed) {
    if (!mounted || !widget.active || _captured) return;

    final moveEvery = const Duration(milliseconds: 900);
    if (elapsed - _lastMoveElapsed >= moveEvery) {
      _lastMoveElapsed = elapsed;
      _targetNorm = _randomNorm();
    }

    setState(() {
      _waveT = (math.sin(elapsed.inMilliseconds / 280) + 1) / 2;
    });
  }

  Offset _randomNorm() {
    return Offset(
      0.15 + _rng.nextDouble() * 0.7,
      0.2 + _rng.nextDouble() * 0.62,
    );
  }

  Offset _resolveTargetCenter(Size size, EdgeInsets padding) {
    const targetSize = 96.0;
    const sideGap = 24.0;
    final leftMin = sideGap + targetSize / 2;
    final leftMax = size.width - sideGap - targetSize / 2;
    final topMin = padding.top + 100;
    final topMax = size.height - padding.bottom - 120;

    final x = leftMin + (leftMax - leftMin) * _targetNorm.dx;
    final y = topMin + (topMax - topMin) * _targetNorm.dy;
    return Offset(x, y);
  }

  void _onTapDown(PointerDownEvent event, Size size, EdgeInsets padding) {
    if (!widget.active || _captured) return;
    final targetCenter = _resolveTargetCenter(size, padding);
    final distance = (event.localPosition - targetCenter).distance;
    if (distance <= 68) {
      setState(() {
        _captured = true;
      });
      widget.onCaptured();
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (!widget.active && !_captured) return const SizedBox.shrink();

    final mediaQuery = MediaQuery.of(context);
    final targetColor = switch (widget.mode) {
      GameMode.laser => const Color(0xFFFF4D4D),
      GameMode.shadowPeek => const Color(0xFF9CCC65),
      GameMode.catchMouse => const Color(0xFFFFC107),
      GameMode.rainbow => const Color(0xFF9C27B0),
      GameMode.holeAmbush => const Color(0xFFFF8A65),
      GameMode.featherWand => const Color(0xFF26A69A),
    };
    final targetEmoji = switch (widget.mode) {
      GameMode.laser => '🔴',
      GameMode.shadowPeek => '🐦',
      GameMode.catchMouse => '🐟',
      GameMode.rainbow => '✨',
      GameMode.holeAmbush => '🐾',
      GameMode.featherWand => '🪶',
    };

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        final targetCenter = _resolveTargetCenter(size, mediaQuery.padding);
        final ringScaleA = 1 + _waveT * 0.85;
        final ringScaleB = 1 + (((_waveT + 0.5) % 1.0) * 0.85);

        return Listener(
          behavior: HitTestBehavior.translucent,
          onPointerDown: (event) => _onTapDown(event, size, mediaQuery.padding),
          child: Stack(
            children: [
              Positioned(
                top: mediaQuery.padding.top + 12,
                left: 20,
                right: 20,
                child: IgnorePointer(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.15),
                      ),
                    ),
                    child: Text(
                      l10n.gameFinalTargetBanner(widget.countdown),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: targetCenter.dx - 48,
                top: targetCenter.dy - 48,
                child: IgnorePointer(
                  child: SizedBox(
                    width: 96,
                    height: 96,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        _WaveRing(
                          color: targetColor,
                          scale: ringScaleA,
                          alpha: 0.42 * (1 - _waveT * 0.35),
                        ),
                        _WaveRing(
                          color: targetColor,
                          scale: ringScaleB,
                          alpha: 0.34 * (_waveT * 0.8 + 0.2),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          width: _captured ? 68 : 80,
                          height: _captured ? 68 : 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Colors.white.withValues(alpha: 0.95),
                                targetColor.withValues(alpha: 0.92),
                                targetColor.withValues(alpha: 0.7),
                              ],
                              stops: const [0.0, 0.58, 1.0],
                            ),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.85),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: targetColor.withValues(alpha: 0.6),
                                blurRadius: 22,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            _captured ? '✓' : targetEmoji,
                            style: TextStyle(
                              fontSize: _captured ? 34 : 30,
                              color: _captured
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.95),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TimeProgressBar extends StatelessWidget {
  final Duration elapsed;
  final Duration total;
  final Color color;

  const _TimeProgressBar({
    required this.elapsed,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final remaining = (1.0 - elapsed.inMilliseconds / total.inMilliseconds)
        .clamp(0.0, 1.0);
    return SizedBox(
      height: 3,
      child: LinearProgressIndicator(
        value: remaining,
        backgroundColor: Colors.white.withValues(alpha: 0.08),
        valueColor: AlwaysStoppedAnimation<Color>(
          color.withValues(alpha: 0.55),
        ),
        minHeight: 3,
      ),
    );
  }
}

class _WaveRing extends StatelessWidget {
  final Color color;
  final double scale;
  final double alpha;

  const _WaveRing({
    required this.color,
    required this.scale,
    required this.alpha,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: color.withValues(alpha: alpha.clamp(0.0, 1.0)),
            width: 4,
          ),
        ),
      ),
    );
  }
}
