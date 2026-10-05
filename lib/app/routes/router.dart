import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tava/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:tava/features/auth/presentation/pages/login_page.dart';
import 'package:tava/features/auth/presentation/pages/signup_page.dart';
import 'package:tava/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:tava/features/exercise_library/presentation/pages/exercise_library_page.dart';
import 'package:tava/features/metronome/presentation/pages/metronome_page.dart';
import 'package:tava/features/practice_session/presentation/pages/practice_session_page.dart';
import 'package:tava/features/progress/presentation/pages/progress_page.dart';
import 'package:tava/features/settings/presentation/pages/settings_page.dart';
import 'package:tava/features/splash/presentation/pages/splash_page.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    unawaited(_subscription.cancel());
    super.dispose();
  }
}

GoRouter createAppRouter(AuthBloc authBloc) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/splash',
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    redirect: (context, state) {
      final authState = authBloc.state;
      final location = state.matchedLocation;
      final isSplash = location == '/splash';
      final isAuthRoute = location == '/login' || location == '/signup';

      if (authState is AuthInitial) {
        return isSplash ? null : '/splash';
      }

      // Keep current route during in-flight auth (login, logout, etc.).
      if (authState is AuthLoading) {
        return null;
      }

      if (authState is AuthUnauthenticated || authState is AuthError) {
        if (isAuthRoute || isSplash) return isAuthRoute ? null : '/login';
        return '/login';
      }

      if (authState is AuthAuthenticated) {
        if (isSplash || isAuthRoute) return '/dashboard';
        return null;
      }

      return null;
    },
    routes: [
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
      GoRoute(
        path: '/session',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const PracticeSessionPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/dashboard',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: DashboardPage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/library',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: ExerciseLibraryPage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/metronome',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: MetronomePage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/progress',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: ProgressPage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: SettingsPage(),
                ),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/',
        redirect: (context, state) => '/dashboard',
      ),
    ],
  );
}

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  static const _destinations = <(IconData, IconData, String)>[
    (Icons.home_outlined, Icons.home_rounded, 'Home'),
    (Icons.library_music_outlined, Icons.library_music_rounded, 'Library'),
    (Icons.speed_outlined, Icons.speed_rounded, 'Metronome'),
    (Icons.show_chart_outlined, Icons.show_chart_rounded, 'Progress'),
    (Icons.settings_outlined, Icons.settings_rounded, 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isHome = navigationShell.currentIndex == 0;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: navigationShell.goBranch,
        destinations: [
          for (final destination in _destinations)
            NavigationDestination(
              icon: Icon(destination.$1),
              selectedIcon: Icon(destination.$2),
              label: destination.$3,
            ),
        ],
      ),
      floatingActionButton: isHome
          ? FloatingActionButton.extended(
              onPressed: () => context.push('/session'),
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Practice'),
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
            )
          : null,
    );
  }
}
