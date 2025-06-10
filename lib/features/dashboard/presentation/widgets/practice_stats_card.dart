import 'package:flutter/material.dart';
import 'package:tava/features/progress/domain/entities/practice_stats.dart';

class PracticeStatsCard extends StatelessWidget {

  const PracticeStatsCard({super.key, this.stats});
  final PracticeStats? stats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (stats == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'No practice data yet',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Start practicing to see your stats',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: _StatItem(
                    label: 'Total Time',
                    value: _formatDuration(stats!.totalPracticeTime),
                    icon: Icons.timer,
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    label: 'Sessions',
                    value: stats!.totalSessions.toString(),
                    icon: Icons.calendar_today,
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    label: 'Avg. BPM',
                    value: stats!.averageBpm.toString(),
                    icon: Icons.speed,
                  ),
                ),
              ],
            ),
          ],
        ),
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
}

class _StatItem extends StatelessWidget {

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
  });
  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Icon(icon, color: theme.colorScheme.primary),
        const SizedBox(height: 8),
        Text(
          value,
          style: theme.textTheme.titleMedium,
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}