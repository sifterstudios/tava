import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tava/core/di/injection.dart';
import 'package:tava/features/exercise_library/domain/entities/exercise.dart';
import 'package:tava/features/progress/domain/entities/practice_stats.dart';
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
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress'),
        actions: [
          IconButton(
            icon: const Icon(Icons.date_range),
            onPressed: () {
              // Show date range picker
            },
          ),
        ],
      ),
      body: BlocBuilder<ProgressBloc, ProgressState>(
        builder: (context, state) {
          if (state.status == ProgressStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state.status == ProgressStatus.failure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Failed to load progress data',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<ProgressBloc>()
                      ..add(LoadProgressData()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          
          if (state.practiceStats == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.music_note, size: 64),
                  const SizedBox(height: 16),
                  Text(
                    'No practice data yet',
                    style: theme.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start practicing to see your progress',
                    style: theme.textTheme.bodyLarge,
                  ),
                ],
              ),
            );
          }
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Summary stats
                Row(
                  children: [
                    Expanded(
                      child: StatsCard(
                        title: 'Total Practice',
                        value: _formatDuration(state.practiceStats!.totalPracticeTime),
                        icon: Icons.timer,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: StatsCard(
                        title: 'Sessions',
                        value: state.practiceStats!.totalSessions.toString(),
                        icon: Icons.calendar_today,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Practice time chart
                Text(
                  'Practice History',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 200,
                  child: PracticeHistoryChart(
                    dailyPracticeTimes: state.practiceStats!.dailyPracticeTimes,
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Category breakdown
                Text(
                  'Practice by Category',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 200,
                  child: CategoryBreakdownChart(
                    categoryData: state.practiceStats!.timeByCategory,
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // BPM progress
                Text(
                  'Average BPM Progress',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                _buildBpmProgressChart(state),
                
                const SizedBox(height: 24),
                
                // Top exercises
                Text(
                  'Most Practiced Exercises',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                _buildTopExercises(state, theme),
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
    
    if (hours > 0) {
      return '$hours h $minutes min';
    } else {
      return '$minutes min';
    }
  }

  Widget _buildBpmProgressChart(ProgressState state) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(8),
      ),
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: const [
                FlSpot(0, 80),
                FlSpot(1, 82),
                FlSpot(2, 85),
                FlSpot(3, 84),
                FlSpot(4, 87),
                FlSpot(5, 90),
                FlSpot(6, 92),
              ],
              isCurved: true,
              color: Colors.cyanAccent,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.cyanAccent.withOpacity(0.2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopExercises(ProgressState state, ThemeData theme) {
    // This would normally use state.practiceStats!.timeByExercise
    // but for this example we'll use mock data
    
    final mockTopExercises = {
      'C Major Scale': const Duration(hours: 2, minutes: 15),
      'Bach Prelude': const Duration(hours: 1, minutes: 45),
      'Finger Exercise #4': const Duration(hours: 1, minutes: 30),
      'Improvisation': const Duration(hours: 1, minutes: 15),
      'Sight Reading': const Duration(minutes: 45),
    };
    
    return Column(
      children: mockTopExercises.entries.map((entry) {
        final percent = entry.value.inMinutes / 
            mockTopExercises.values.fold<int>(
              0, 
              (sum, duration) => sum + duration.inMinutes
            ) * 100;
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(entry.key),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: percent / 100,
                    backgroundColor: theme.colorScheme.primaryContainer,
                    color: theme.colorScheme.primary,
                    minHeight: 8,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 60,
                child: Text(
                  _formatDuration(entry.value),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}