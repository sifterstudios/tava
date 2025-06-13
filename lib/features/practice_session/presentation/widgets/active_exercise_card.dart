import 'package:flutter/material.dart';
import 'package:tava/features/exercise_library/domain/entities/exercise.dart';
import 'package:tava/features/practice_session/domain/entities/exercise_category.dart';

class ActiveExerciseCard extends StatelessWidget {
  final Exercise exercise;
  final VoidCallback onComplete;

  const ActiveExerciseCard({
    super.key,
    required this.exercise,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: theme.colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exercise.name,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                      if (exercise.description != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          exercise.description!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                FilledButton(
                  onPressed: onComplete,
                  style: FilledButton.styleFrom(
                    backgroundColor: theme.colorScheme.onPrimaryContainer,
                    foregroundColor: theme.colorScheme.primaryContainer,
                  ),
                  child: const Text('Complete'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Chip(
                  label: Text(exercise.category?.name ?? 'No category'),
                  backgroundColor: _getCategoryColor(exercise.category, theme),
                  labelStyle: TextStyle(
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(width: 8),
                if (exercise.targetBpm != null)
                  Chip(
                    label: Text('${exercise.targetBpm} BPM'),
                    backgroundColor: theme.colorScheme.primary.withOpacity(0.7),
                    labelStyle: TextStyle(
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(ExerciseCategory? category, ThemeData theme) {
    // Use the category's color if provided, otherwise default to theme primary
    if (category?.color != null) {
      return Color(int.parse(category!.color!));
    }
    return theme.colorScheme.primary.withOpacity(0.7);
  }
}
