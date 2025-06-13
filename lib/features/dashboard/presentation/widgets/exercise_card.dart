import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:tava/features/exercise_library/domain/entities/exercise.dart';
import 'package:tava/features/practice_session/domain/entities/exercise_category.dart';

/// A card widget that displays an exercise with its details and
/// allows tapping for more actions.
class ExerciseCard extends StatelessWidget {
  /// Creates an [ExerciseCard] widget.
  const ExerciseCard({
    required this.exercise,
    required this.onTap,
    super.key,
  });

  /// The exercise to display in the card.
  final Exercise exercise;

  /// Callback function to be called when the card is tapped.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: platformThemeData(
            context,
            material: (data) => data.colorScheme.surface,
            cupertino: (data) => CupertinoColors.systemBackground,
          ),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: platformThemeData(
              context,
              material: (data) =>
                  data.colorScheme.outline.withValues(alpha: 0.2),
              cupertino: (data) => CupertinoColors.separator,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(exercise.category)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: PlatformText(
                    _getCategoryName(exercise.category),
                    style: TextStyle(
                      color: _getCategoryColor(exercise.category),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                if (exercise.isFavorite)
                  PlatformWidget(
                    material: (_, __) => const Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 16,
                    ),
                    cupertino: (_, __) => const Icon(
                      CupertinoIcons.heart_fill,
                      color: CupertinoColors.systemRed,
                      size: 16,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            PlatformText(
              exercise.name,
              style: platformThemeData(
                context,
                material: (data) => data.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                cupertino: (data) => data.textTheme.textStyle.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            if (exercise.targetBpm != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  PlatformWidget(
                    material: (_, __) => const Icon(
                      Icons.speed,
                      size: 12,
                      color: Color(0xFF00FFFF),
                    ),
                    cupertino: (_, __) => const Icon(
                      CupertinoIcons.metronome,
                      size: 12,
                      color: Color(0xFF00FFFF),
                    ),
                  ),
                  const SizedBox(width: 4),
                  PlatformText(
                    '${exercise.targetBpm} BPM',
                    style: platformThemeData(
                      context,
                      material: (data) => data.textTheme.bodySmall?.copyWith(
                        color:
                            data.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      cupertino: (data) => data.textTheme.textStyle.copyWith(
                        color: CupertinoColors.secondaryLabel,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getCategoryName(ExerciseCategory? category) {
    if (category == null) {
      return 'Unknown';
    }

    return category.id;
  }

  Color _getCategoryColor(ExerciseCategory? category) {
    if (category == null) {
      return const Color(0xFF9E9E9E); // Default color for unknown categories
    }

    switch (category.id) {
      case 'Tech':
        return const Color(0xFF00FFFF);
      case 'Rep':
        return const Color(0xFF6200EA);
      case 'Scales':
        return const Color(0xFF00BFA5);
      case 'Etude':
        return const Color(0xFFFF6D00);
      case 'Sight':
        return const Color(0xFF2196F3);
      case 'Improv':
        return const Color(0xFF4CAF50);
      case 'Other':
        return const Color(0xFF9E9E9E);
    }
    return const Color(0xFF9E9E9E);
  }
}
