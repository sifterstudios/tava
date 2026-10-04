import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:tava/core/utils/either.dart';
import 'package:tava/features/exercise_library/domain/entities/exercise.dart';
import 'package:tava/features/exercise_library/domain/repositories/exercise_repository.dart';

@Environment('dev')
@LazySingleton(as: ExerciseRepository)
class MockExerciseRepository implements ExerciseRepository {
  final List<Exercise> _exercises = [
    Exercise(
      id: '1',
      name: 'C Major Scale',
      description: 'Basic C major scale practice',
      category: ExerciseCategory.scales,
      targetBpm: 120,
      tags: const ['scale', 'beginner'],
      isFavorite: true,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
      isArchived: false,
    ),
    Exercise(
      id: '2',
      name: 'Finger Exercise #4',
      description: 'Finger independence exercise',
      category: ExerciseCategory.technique,
      targetBpm: 90,
      tags: const ['technique', 'intermediate'],
      isFavorite: false,
      createdAt: DateTime.now().subtract(const Duration(days: 25)),
      updatedAt: DateTime.now().subtract(const Duration(days: 3)),
      isArchived: false,
    ),
    Exercise(
      id: '3',
      name: 'Bach Prelude',
      description: 'Bach Prelude in C Major',
      category: ExerciseCategory.repertoire,
      targetBpm: 72,
      tags: const ['classical', 'advanced'],
      isFavorite: true,
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      isArchived: false,
    ),
  ];

  @override
  FutureEitherResult<List<Exercise>> getExercises() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return right(List.of(_exercises));
  }

  @override
  FutureEitherResult<Exercise> upsertExercise(Exercise exercise) async {
    final index = _exercises.indexWhere((e) => e.id == exercise.id);
    if (index >= 0) {
      _exercises[index] = exercise;
    } else {
      _exercises.add(exercise);
    }
    return right(exercise);
  }

  @override
  FutureEitherUnit deleteExercise(String id) async {
    _exercises.removeWhere((e) => e.id == id);
    return right(unit);
  }

  @override
  FutureEitherResult<Exercise> toggleFavorite(Exercise exercise) {
    return upsertExercise(exercise.copyWith(isFavorite: !exercise.isFavorite));
  }
}
