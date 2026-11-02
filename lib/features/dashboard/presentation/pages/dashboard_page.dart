import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tava/core/di/injection.dart';
import 'package:tava/core/widgets/empty_state.dart';
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
        title: const Text('Tava'),
        actions: [
          IconButton(
            tooltip: 'Settings',
            icon: const Icon(Icons.person_outline_rounded),
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
            return EmptyState(
              icon: Icons.cloud_off_rounded,
              title: 'Could not load your journal',
              message:
                  state.errorMessage ?? 'Check your connection and try again.',
              actionLabel: 'Retry',
              onAction: () =>
                  context.read<DashboardBloc>().add(LoadDashboardData()),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<DashboardBloc>().add(LoadDashboardData());
            },
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      Text(
                        'Practice journal',
                        style: theme.textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Pick up where you left off, or start fresh.',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (state.activeSession != null) ...[
                        const _ActiveSessionBanner(),
                        const SizedBox(height: 16),
                      ],
                      const QuickStartCard(),
                      const SizedBox(height: 24),
                      Text(
                        'Practice stats',
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      PracticeStatsCard(stats: state.practiceStats),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Text(
                            'Recent sessions',
                            style: theme.textTheme.titleLarge,
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () => context.go('/progress'),
                            child: const Text('See all'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (state.recentSessions.isEmpty)
                        Text(
                          'No sessions yet. Start practicing to build history.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        )
                      else
                        ...state.recentSessions.map(
                          (session) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: RecentSessionCard(session: session),
                          ),
                        ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Text(
                            'Suggested exercises',
                            style: theme.textTheme.titleLarge,
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () => context.go('/library'),
                            child: const Text('See all'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (state.suggestedExercises.isEmpty)
                        Text(
                          'Your library suggestions will show up here.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        )
                      else
                        SizedBox(
                          height: 140,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: state.suggestedExercises.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 8),
                            itemBuilder: (context, index) {
                              final exercise = state.suggestedExercises[index];
                              return ExerciseCard(
                                exercise: exercise,
                                onTap: () => context.go('/library'),
                              );
                            },
                          ),
                        ),
                      if (state.weatherInfo != null) ...[
                        const SizedBox(height: 24),
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
    final colors = theme.colorScheme;

    return Material(
      color: colors.primaryContainer,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () => context.push('/session'),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                Icons.music_note_rounded,
                color: colors.onPrimaryContainer,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Practice in progress',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colors.onPrimaryContainer,
                      ),
                    ),
                    Text(
                      'Continue your open session',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colors.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
              FilledButton(
                onPressed: () => context.push('/session'),
                style: FilledButton.styleFrom(
                  backgroundColor: colors.onPrimaryContainer,
                  foregroundColor: colors.primaryContainer,
                ),
                child: const Text('Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
