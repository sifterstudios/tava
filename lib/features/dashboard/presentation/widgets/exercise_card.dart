import 'package:flutter/material.dart';
import 'package:tava/features/exercise_library/domain/entities/exercise.dart';

class ExerciseCard extends StatelessWidget {

  const ExerciseCard({
    required this.exercise, required this.onTap, super.key,
  });
  final Exercise exercise;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: 200,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      exercise.name,
                      style: theme.textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (exercise.isFavorite)
                    const Icon(
                      Icons.favorite,
                      color: Colors.redAccent,
                      size: 18,
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                _getCategoryName(exercise.category),
                style: theme.textTheme.bodySmall,
              ),
              if (exercise.targetBpm != null) ...[
                const SizedBox(height: 4),
                Text(
                  '${exercise.targetBpm} BPM',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ],
          ),
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