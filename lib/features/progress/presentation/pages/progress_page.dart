import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tava/core/di/injection.dart';
import 'package:tava/core/widgets/empty_state.dart';
import 'package:tava/features/progress/domain/entities/practice_stats.dart'
    show BpmTrendPoint, PracticeStats;
import 'package:tava/features/progress/presentation/bloc/progress_bloc.dart';
import 'package:tava/features/progress/presentation/widgets/category_breakdown_chart.dart';
import 'package:tava/features/progress/presentation/widgets/practice_history_chart.dart';
import 'package:tava/features/progress/presentation/widgets/stats_card.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProgressBloc>()..add(LoadProgressData()),
      child: const ProgressView(),
    );
  }
}

class ProgressView extends StatelessWidget {
  const ProgressView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress'),
      ),
      body: BlocBuilder<ProgressBloc, ProgressState>(
        builder: (context, state) {
          if (state.status == ProgressStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == ProgressStatus.failure) {
            return EmptyState(
              icon: Icons.show_chart_rounded,
              title: 'Could not load progress',
              message: state.errorMessage ?? 'Try again in a moment.',
              actionLabel: 'Retry',
              onAction: () =>
                  context.read<ProgressBloc>().add(LoadProgressData()),
            );
          }

          final stats = state.practiceStats;
          if (stats == null || stats.totalSessions == 0) {
            return const EmptyState(
              icon: Icons.music_note_rounded,
              title: 'No practice data yet',
              message: 'Finish a session and your trends will appear here.',
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: StatsCard(
                        title: 'Total practice',
                        value: _formatDuration(stats.totalPracticeTime),
                        icon: Icons.timer_outlined,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: StatsCard(
                        title: 'Sessions',
                        value: stats.totalSessions.toString(),
                        icon: Icons.calendar_today_outlined,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text('Practice history', style: theme.textTheme.titleLarge),
                const SizedBox(height: 8),
                SizedBox(
                  height: 200,
                  child: PracticeHistoryChart(
                    dailyPracticeTimes: stats.dailyPracticeTimes,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Practice by category',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 200,
                  child: CategoryBreakdownChart(
                    categoryData: stats.timeByCategory,
                  ),
                ),
                if (stats.bpmTrend.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Text(
                        'Average BPM trend',
                        style: theme.textTheme.titleLarge,
                      ),
                      if (stats.bpmTrend.any((p) => p.isSeed)) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: colors.secondaryContainer,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            'Sample preview',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colors.onSecondaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  _BpmTrendChart(points: stats.bpmTrend),
                ],
                const SizedBox(height: 24),
                Text(
                  'Most practiced exercises',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                _TopExercises(stats: stats),
                const SizedBox(height: 12),
                Text(
                  'Average tempo: ${stats.averageBpm} BPM',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours > 0) return '$hours h $minutes min';
    return '$minutes min';
  }
}

class _BpmTrendChart extends StatelessWidget {
  const _BpmTrendChart({required this.points});

  final List<BpmTrendPoint> points;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final spots = <FlSpot>[
      for (var i = 0; i < points.length; i++)
        FlSpot(i.toDouble(), points[i].averageBpm),
    ];
    final isSeed = points.any((p) => p.isSeed);

    return Semantics(
      label: isSeed
          ? 'Sample BPM trend preview'
          : 'Average BPM trend over ${points.length} days',
      child: Container(
        height: 200,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: LineChart(
          LineChartData(
            gridData: const FlGridData(show: false),
            titlesData: const FlTitlesData(show: false),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                color: isSeed ? colors.secondary : colors.primary,
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: false),
                dashArray: isSeed ? [8, 6] : null,
                belowBarData: BarAreaData(
                  show: true,
                  color: (isSeed ? colors.secondary : colors.primary)
                      .withValues(alpha: 0.16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopExercises extends StatelessWidget {
  const _TopExercises({required this.stats});

  final PracticeStats stats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final entries = stats.timeByExercise.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final top = entries.take(5).toList();

    if (top.isEmpty) {
      return Text(
        'Exercise breakdown will appear after you log sessions.',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      );
    }

    final totalMinutes = top.fold<int>(
      0,
      (sum, entry) => sum + entry.value.inMinutes,
    );

    return Column(
      children: top.map((entry) {
        final percent =
            totalMinutes == 0 ? 0.0 : entry.value.inMinutes / totalMinutes;
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  entry.key,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: percent,
                    minHeight: 8,
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 72,
                child: Text(
                  _formatDuration(entry.value),
                  textAlign: TextAlign.end,
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours > 0) return '$hours h $minutes m';
    return '$minutes min';
  }
}
