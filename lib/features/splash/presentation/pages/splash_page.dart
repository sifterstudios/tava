import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:tava/core/di/injection.dart';
import 'package:tava/features/auth/presentation/bloc/auth_bloc.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthBloc>()..add(CheckAuthStatus()),
      child: const SplashView(),
    );
  }
}

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.go('/dashboard');
        } else if (state is AuthUnauthenticated || state is AuthError) {
          context.go('/login');
        }
      },
      child: PlatformScaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF00FFFF).withOpacity(0.1),
                const Color(0xFF00BFA5).withOpacity(0.1),
              ],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00FFFF).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: const Color(0xFF00FFFF).withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: PlatformWidget(
                    material: (_, __) => const Icon(
                      Icons.music_note,
                      size: 60,
                      color: Color(0xFF00FFFF),
                    ),
                    cupertino: (_, __) => const Icon(
                      CupertinoIcons.music_note,
                      size: 60,
                      color: Color(0xFF00FFFF),
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // App name
                PlatformText(
                  'TAVA',
                  style: platformThemeData(
                    context,
                    material: (data) => data.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: data.colorScheme.onSurface,
                    ),
                    cupertino: (data) => data.textTheme.navLargeTitleTextStyle.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                    ),
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Tagline
                PlatformText(
                  'Track your practice journey',
                  style: platformThemeData(
                    context,
                    material: (data) => data.textTheme.bodyLarge?.copyWith(
                      color: data.colorScheme.onSurface.withOpacity(0.7),
                    ),
                    cupertino: (data) => data.textTheme.textStyle.copyWith(
                      color: CupertinoColors.secondaryLabel,
                    ),
                  ),
                ),
                
                const SizedBox(height: 48),
                
                // Loading indicator
                PlatformCircularProgressIndicator(
                  material: (_, __) => MaterialProgressIndicatorData(
                    color: const Color(0xFF00FFFF),
                  ),
                  cupertino: (_, __) => CupertinoProgressIndicatorData(
                    color: const Color(0xFF00FFFF),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}