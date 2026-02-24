import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../sounds/data/repositories/sound_repository.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String slogan = '懂猫，听猫咪说';
  static const String iconAsset = 'assets/images/icons/app_icon.png';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _textAnim;
  late final Animation<double> _textOpacity;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _textAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _textOpacity = CurvedAnimation(
      parent: _textAnim,
      curve: Curves.easeOut,
    );

    _precacheHomeImages();
    _textAnim.forward();
    _scheduleNavigate();
  }

  Future<void> _precacheHomeImages() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      for (final sound in SoundRepository.allSounds) {
        await precacheImage(AssetImage(sound.imagePath), context);
      }
    });
  }

  void _scheduleNavigate() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted || _navigated) return;
      _navigated = true;
      context.go('/sounds');
    });
  }

  @override
  void dispose() {
    _textAnim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SafeArea(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 14,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: Image.asset(
                        SplashScreen.iconAsset,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FadeTransition(
                    opacity: _textOpacity,
                    child: Text(
                      '瞄~瞄~',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.onBackground.withValues(alpha: 0.6),
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    '猫咪说',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onBackground,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    SplashScreen.slogan,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
