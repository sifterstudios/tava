import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tava/core/di/injection.dart';
import 'package:tava/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:tava/features/dashboard/presentation/widgets/exercise_card.dart';
import 'package:tava/features/dashboard/presentation/widgets/practice_stats_card.dart';
import 'package:tava/features/dashboard/presentation/widgets/quick_start_card.dart';
import 'package:tava/features/dashboard/presentation/widgets/recent_session_card.dart';
import 'package:tava/features/dashboard/presentation/widgets/weather_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<DashboardBloc>()..add(LoadDashboardData()),
      child: const DashboardView(),
    );
  }
}

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Practice Journal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => context.go('/settings'),
          ),
        ],
      ),
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state.status == DashboardStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == DashboardStatus.failure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Failed to load dashboard',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<DashboardBloc>()
                      ..add(LoadDashboardData()),
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
                      Text(
                        'Practice Stats',
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      PracticeStatsCard(stats: state.practiceStats),

                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Text(
                            'Recent Sessions',
                            style: theme.textTheme.titleLarge,
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () => context.go('/progress'),
                            child: const Text('See All'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ...state.recentSessions.map((session) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: RecentSessionCard(session: session),
                      ),),

                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Text(
                            'Suggested Exercises',
                            style: theme.textTheme.titleLarge,
                          ),
                          const Spacer(),
                          TextButton(
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
                                right: index < state.suggestedExercises.length - 1
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
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.music_note,
            color: theme.colorScheme.onPrimaryContainer,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Practice in progress',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                Text(
                  'Tap to continue',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => context.go('/dashboard/start-session'),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.onPrimaryContainer,
              foregroundColor: theme.colorScheme.primaryContainer,
            ),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }
}