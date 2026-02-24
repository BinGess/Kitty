import 'package:go_router/go_router.dart';
import '../../features/sounds/presentation/screens/sounds_screen.dart';
import '../../features/personality_test/presentation/screens/test_intro_screen.dart';
import '../../features/personality_test/presentation/screens/question_screen.dart';
import '../../features/personality_test/presentation/screens/analyzing_screen.dart';
import '../../features/personality_test/presentation/screens/result_screen.dart';
import '../../features/health/presentation/screens/health_dashboard_screen.dart';
import '../../features/games/presentation/screens/game_menu_screen.dart';
import '../../features/games/presentation/screens/game_play_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/profile/presentation/screens/more_screen.dart';
import '../../features/profile/presentation/screens/cat_list_screen.dart';
import '../../features/profile/presentation/screens/about_screen.dart';
import '../../features/theater/presentation/screens/theater_screen.dart';
import 'scaffold_with_nav_bar.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    // 游戏全屏路由：不显示底部导航栏
    GoRoute(
      path: '/game-play/:gameId',
      name: 'gamePlay',
      builder: (context, state) => GamePlayScreen(
        gameId: state.pathParameters['gameId']!,
      ),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNavBar(navigationShell: navigationShell);
      },
      branches: [
        // Tab 1: Sounds
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/sounds',
              name: 'sounds',
              builder: (context, state) => const SoundsScreen(),
            ),
          ],
        ),
        // Tab 2: Personality Test
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/test',
              name: 'test',
              builder: (context, state) => const TestIntroScreen(),
              routes: [
                GoRoute(
                  path: 'question',
                  name: 'question',
                  builder: (context, state) => const QuestionScreen(),
                ),
                GoRoute(
                  path: 'analyzing',
                  name: 'analyzing',
                  builder: (context, state) => const AnalyzingScreen(),
                ),
                GoRoute(
                  path: 'result',
                  name: 'result',
                  builder: (context, state) => const ResultScreen(),
                ),
              ],
            ),
          ],
        ),
        // Tab 3: Health
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/health',
              name: 'health',
              builder: (context, state) => const HealthDashboardScreen(),
            ),
          ],
        ),
        // Tab 4: Games
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/games',
              name: 'games',
              builder: (context, state) => const GameMenuScreen(),
            ),
          ],
        ),
        // Tab 5: More
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/more',
              name: 'more',
              builder: (context, state) => const MoreScreen(),
              routes: [
                GoRoute(
                  path: 'theater',
                  name: 'theater',
                  builder: (context, state) => const TheaterScreen(),
                ),
                GoRoute(
                  path: 'cats',
                  name: 'cats',
                  builder: (context, state) => const CatListScreen(),
                ),
                GoRoute(
                  path: 'about',
                  name: 'about',
                  builder: (context, state) => const AboutScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
