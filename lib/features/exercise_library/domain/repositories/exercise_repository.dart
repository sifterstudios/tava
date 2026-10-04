import 'package:tava/core/utils/either.dart';
import 'package:tava/features/exercise_library/domain/entities/exercise.dart';

abstract class ExerciseRepository {
  FutureEitherResult<List<Exercise>> getExercises();
  FutureEitherResult<Exercise> upsertExercise(Exercise exercise);
  FutureEitherUnit deleteExercise(String id);
  FutureEitherResult<Exercise> toggleFavorite(Exercise exercise);
}
