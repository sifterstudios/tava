import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:tava/core/di/injection.dart';
import 'package:tava/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:tava/features/dashboard/presentation/widgets/exercise_card.dart';
import 'package:tava/features/dashboard/presentation/widgets/practice_stats_card.dart';
import 'package:tava/features/dashboard/presentation/widgets/quick_start_card.dart';
import 'package:tava/features/dashboard/presentation/widgets/recent_session_card.dart';
import 'package:tava/features/dashboard/presentation/widgets/weather_card.dart';

/// The main dashboard page that displays the user's practice journal.
class DashboardPage extends StatelessWidget {
  /// Creates a new instance of [DashboardPage].
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<DashboardBloc>()..add(LoadDashboardData()),
      child: const DashboardView(),
    );
  }
}

/// The view for the dashboard, displaying practice stats, recent sessions,
/// suggested exercises, and weather information.
class DashboardView extends StatelessWidget {
  /// Creates a new instance of [DashboardView].
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: const Text('Practice Journal'),
        material: (_, __) => MaterialAppBarData(
          actions: [
            IconButton(
              icon: const Icon(Icons.person_outline),
              onPressed: () => context.go('/settings'),
            ),
          ],
        ),
        cupertino: (_, __) => CupertinoNavigationBarData(
          trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Icon(CupertinoIcons.person),
            onPressed: () => context.go('/settings'),
          ),
        ),
      ),
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state.status == DashboardStatus.loading) {
            return const Center(
              child: PlatformCircularProgressIndicator(),
            );
          }

          if (state.status == DashboardStatus.failure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PlatformText(
                    'Failed to load dashboard',
                    style: platformThemeData(
                      context,
                      material: (data) => data.textTheme.titleLarge,
                      cupertino: (data) => data.textTheme.navTitleTextStyle,
                    ),
                  ),
                  const SizedBox(height: 16),
                  PlatformElevatedButton(
                    onPressed: () =>
                        context.read<DashboardBloc>()..add(LoadDashboardData()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<DashboardBloc>().add(LoadDashboardData());
            },
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      if (state.activeSession != null) ...[
                        const _ActiveSessionBanner(),
                        const SizedBox(height: 16),
                      ],
                      const QuickStartCard(),
                      const SizedBox(height: 16),
                      PlatformText(
                        'Practice Stats',
                        style: platformThemeData(
                          context,
                          material: (data) => data.textTheme.titleLarge,
                          cupertino: (data) => data.textTheme.navTitleTextStyle,
                        ),
                      ),
                      const SizedBox(height: 8),
                      PracticeStatsCard(stats: state.practiceStats),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          PlatformText(
                            'Recent Sessions',
                            style: platformThemeData(
                              context,
                              material: (data) => data.textTheme.titleLarge,
                              cupertino: (data) =>
                                  data.textTheme.navTitleTextStyle,
                            ),
                          ),
                          const Spacer(),
                          PlatformTextButton(
                            onPressed: () => context.go('/progress'),
                            child: const Text('See All'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ...state.recentSessions.map((session) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: RecentSessionCard(session: session),
                          )),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          PlatformText(
                            'Suggested Exercises',
                            style: platformThemeData(
                              context,
                              material: (data) => data.textTheme.titleLarge,
                              cupertino: (data) =>
                                  data.textTheme.navTitleTextStyle,
                            ),
                          ),
                          const Spacer(),
                          PlatformTextButton(
                            onPressed: () => context.go('/library'),
                            child: const Text('See All'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 140,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.suggestedExercises.length,
                          itemBuilder: (context, index) {
                            final exercise = state.suggestedExercises[index];
                            return Padding(
                              padding: EdgeInsets.only(
                                right:
                                    index < state.suggestedExercises.length - 1
                                        ? 8
                                        : 0,
                              ),
                              child: ExerciseCard(
                                exercise: exercise,
                                onTap: () {
                                  // Handle exercise tap
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      if (state.weatherInfo != null) ...[
                        const SizedBox(height: 16),
                        WeatherCard(weatherInfo: state.weatherInfo!),
                      ],
                    ]),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ActiveSessionBanner extends StatelessWidget {
  const _ActiveSessionBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: platformThemeData(
          context,
          material: (data) => data.colorScheme.primaryContainer,
          cupertino: (data) => const Color(0xFF00FFFF).withValues(alpha: 0.1),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          PlatformWidget(
            material: (_, __) => Icon(
              Icons.music_note,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
            cupertino: (_, __) => const Icon(
              CupertinoIcons.music_note,
              color: Color(0xFF00FFFF),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PlatformText(
                  'Practice in progress',
                  style: platformThemeData(
                    context,
                    material: (data) => data.textTheme.titleMedium?.copyWith(
                      color: data.colorScheme.onPrimaryContainer,
                    ),
                    cupertino: (data) =>
                        data.textTheme.navTitleTextStyle.copyWith(
                      color: const Color(0xFF00FFFF),
                    ),
                  ),
                ),
                PlatformText(
                  'Tap to continue',
                  style: platformThemeData(
                    context,
                    material: (data) => data.textTheme.bodyMedium?.copyWith(
                      color: data.colorScheme.onPrimaryContainer,
                    ),
                    cupertino: (data) => data.textTheme.textStyle.copyWith(
                      color: CupertinoColors.secondaryLabel,
                    ),
                  ),
                ),
              ],
            ),
          ),
          PlatformElevatedButton(
            onPressed: () => context.go('/dashboard/start-session'),
            material: (_, __) => MaterialElevatedButtonData(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Theme.of(context).colorScheme.onPrimaryContainer,
                foregroundColor: Theme.of(context).colorScheme.primaryContainer,
              ),
            ),
            cupertino: (_, __) => CupertinoElevatedButtonData(
              color: const Color(0xFF00FFFF),
            ),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }
}
