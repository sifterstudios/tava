import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tava/features/auth/presentation/pages/login_page.dart';
import 'package:tava/features/auth/presentation/pages/signup_page.dart';
import 'package:tava/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:tava/features/exercise_library/presentation/pages/exercise_library_page.dart';
import 'package:tava/features/metronome/presentation/pages/metronome_page.dart';
import 'package:tava/features/progress/presentation/pages/progress_page.dart';
import 'package:tava/features/settings/presentation/pages/settings_page.dart';
import 'package:tava/features/splash/presentation/pages/splash_page.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>();

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
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardPage(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const DashboardPage(),
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
);

class ScaffoldWithBottomNavBar extends StatefulWidget {
  const ScaffoldWithBottomNavBar({
    required this.child, super.key,
  });

  final Widget child;

  @override
  State<ScaffoldWithBottomNavBar> createState() =>
      _ScaffoldWithBottomNavBarState();
}

class _ScaffoldWithBottomNavBarState extends State<ScaffoldWithBottomNavBar> {
  int _currentIndex = 0;

  static final List<(String path, IconData icon, String label)> _tabs = [
    ('/dashboard', Icons.home_rounded, 'Home'),
    ('/library', Icons.library_music_rounded, 'Library'),
    ('/metronome', Icons.speed_rounded, 'Metronome'),
    ('/progress', Icons.show_chart_rounded, 'Progress'),
    ('/settings', Icons.settings_rounded, 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
          context.go(_tabs[index].$1);
        },
        backgroundColor: theme.colorScheme.surface,
        destinations: _tabs
            .map(
              (tab) => NavigationDestination(
                icon: Icon(tab.$2),
                label: tab.$3,
              ),
            )
            .toList(),
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton.extended(
              onPressed: () => context.go('/dashboard/start-session'),
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Practice'),
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
            )
          : null,
    );
  }
}
