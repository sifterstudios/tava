import 'package:flutter/material.dart';
import 'package:tava/features/exercise_library/domain/entities/exercise.dart';

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
                  label: Text(_getCategoryName(exercise.category)),
                  backgroundColor: theme.colorScheme.primary.withOpacity(0.7),
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

  String _getCategoryName(ExerciseCategory category) {
    switch (category) {
      case ExerciseCategory.technique:
        return 'Technique';
      case ExerciseCategory.repertoire:
        return 'Repertoire';
      case ExerciseCategory.scales:
        return 'Scales';
      case ExerciseCategory.etudes:
        return 'Etudes';
      case ExerciseCategory.sightReading:
        return 'Sight Reading';
      case ExerciseCategory.improvisation:
        return 'Improvisation';
      case ExerciseCategory.other:
        return 'Other';
    }
  }
}