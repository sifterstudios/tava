import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:tava/features/auth/presentation/pages/login_page.dart';
import 'package:tava/features/auth/presentation/pages/signup_page.dart';
import 'package:tava/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:tava/features/exercise_library/presentation/pages/exercise_library_page.dart';
import 'package:tava/features/metronome/presentation/pages/metronome_page.dart';
import 'package:tava/features/practice_session/presentation/pages/practice_session_page.dart';
import 'package:tava/features/progress/presentation/pages/progress_page.dart';
import 'package:tava/features/settings/presentation/pages/settings_page.dart';
import 'package:tava/features/splash/presentation/pages/splash_page.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  routes: [
    // Splash and Auth routes
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupPage(),
    ),
    
    // Main app shell with bottom navigation
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return PlatformScaffoldWithBottomNavBar(child: child);
      },
      routes: [
        // Dashboard tab
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const DashboardPage(),
          routes: [
            GoRoute(
              path: 'start-session',
              builder: (context, state) => const PracticeSessionPage(),
            ),
          ],
        ),
        
        // Library tab
        GoRoute(
          path: '/library',
          builder: (context, state) => const ExerciseLibraryPage(),
        ),
        
        // Metronome tab
        GoRoute(
          path: '/metronome',
          builder: (context, state) => const MetronomePage(),
        ),
        
        // Progress tab
        GoRoute(
          path: '/progress',
          builder: (context, state) => const ProgressPage(),
        ),
        
        // Settings tab
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsPage(),
        ),
      ],
    ),
  ],
);

class PlatformScaffoldWithBottomNavBar extends StatefulWidget {
  const PlatformScaffoldWithBottomNavBar({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<PlatformScaffoldWithBottomNavBar> createState() => 
      _PlatformScaffoldWithBottomNavBarState();
}

class _PlatformScaffoldWithBottomNavBarState 
    extends State<PlatformScaffoldWithBottomNavBar> {
  int _currentIndex = 0;

  static final List<(String path, IconData materialIcon, IconData cupertinoIcon, String label)> _tabs = [
    ('/dashboard', Icons.home_rounded, CupertinoIcons.home, 'Home'),
    ('/library', Icons.library_music_rounded, CupertinoIcons.music_albums, 'Library'),
    ('/metronome', Icons.speed_rounded, CupertinoIcons.metronome, 'Metronome'),
    ('/progress', Icons.show_chart_rounded, CupertinoIcons.chart_bar, 'Progress'),
    ('/settings', Icons.settings_rounded, CupertinoIcons.settings, 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      body: widget.child,
      bottomNavBar: PlatformNavBar(
        currentIndex: _currentIndex,
        itemChanged: (index) {
          setState(() => _currentIndex = index);
          context.go(_tabs[index].$1);
        },
        items: _tabs.map((tab) => BottomNavigationBarItem(
          icon: PlatformWidget(
            material: (_, __) => Icon(tab.$2),
            cupertino: (_, __) => Icon(tab.$3),
          ),
          label: tab.$4,
        )).toList(),
        material: (_, __) => MaterialNavBarData(
          backgroundColor: Theme.of(context).colorScheme.surface,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          type: BottomNavigationBarType.fixed,
        ),
        cupertino: (_, __) => CupertinoTabBarData(
          backgroundColor: CupertinoTheme.of(context).barBackgroundColor,
          activeColor: const Color(0xFF00FFFF),
          inactiveColor: CupertinoColors.inactiveGray,
        ),
      ),
      material: (_, __) => MaterialScaffoldData(
        floatingActionButton: _currentIndex == 0
            ? FloatingActionButton.extended(
                onPressed: () => context.go('/dashboard/start-session'),
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text('Practice'),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              )
            : null,
      ),
    );
  }
}