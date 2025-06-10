import 'package:flutter/material.dart';
import 'package:tava/features/practice_session/domain/entities/practice_session.dart';

class RecentSessionCard extends StatelessWidget {

  const RecentSessionCard({required this.session, super.key});
  final PracticeSession session;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final date = session.startTime;
    final formattedDate =
        '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.music_note),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    formattedDate,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                Text(
                  _formatDuration(session.duration),
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
            if (session.exercises.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                '${session.exercises.length} exercises',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 4),
              Text(
                session.exercises.map((e) => e.name).join(', '),
                style: theme.textTheme.bodySmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            if (session.notes != null && session.notes!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                session.notes!,
                style: theme.textTheme.bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
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