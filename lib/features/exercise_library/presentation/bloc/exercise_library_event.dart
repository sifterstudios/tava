part of 'exercise_library_bloc.dart';

/// Base class for exercise library events in the application.
abstract class ExerciseLibraryEvent extends Equatable {
  /// Constructor for the ExerciseLibraryEvent class.
  const ExerciseLibraryEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load exercises from the repository.
class LoadExercises extends ExerciseLibraryEvent {}

/// Event to load exercise categories from the repository.
class AddExercise extends ExerciseLibraryEvent {
  /// Creates an instance of AddExercise with the provided exercise.
  const AddExercise(this.exercise);

  /// Event to add a new exercise to the library.
  final Exercise exercise;

  @override
  List<Object> get props => [exercise];
}

/// Event to update an existing exercise in the library.
class UpdateExercise extends ExerciseLibraryEvent {
  /// Creates an instance of UpdateExercise with the provided exercise.
  const UpdateExercise(this.exercise);

  /// Event to update an existing exercise in the library.
  final Exercise exercise;

  @override
  List<Object> get props => [exercise];
}

/// Event to delete an exercise from the library.;
class DeleteExercise extends ExerciseLibraryEvent {
  /// Creates an instance of DeleteExercise with the provided exercise ID.
  const DeleteExercise(this.exerciseId);

  /// Event to delete an exercise from the library.
  final String exerciseId;

  @override
  List<Object> get props => [exerciseId];
}

/// Event to toggle the favorite status of an exercise.
class ToggleExerciseFavorite extends ExerciseLibraryEvent {
  /// Creates an instance of ToggleExerciseFavorite with the provided exercise.
  const ToggleExerciseFavorite(this.exercise);

  /// Event to toggle the favorite status of an exercise.
  final Exercise exercise;

  @override
  List<Object> get props => [exercise];
}

/// Event to filter exercises by category.
class FilterByCategory extends ExerciseLibraryEvent {
  /// Creates an instance of FilterByCategory with the provided category.
  const FilterByCategory(this.category);

  /// Event to filter exercises by a specific category.
  final ExerciseCategory? category;

  @override
  List<Object?> get props => [category];
}

/// Event to search exercises by a query string.
class SearchExercises extends ExerciseLibraryEvent {
  /// Creates an instance of SearchExercises with the provided query.
  const SearchExercises(this.query);

  /// Event to search exercises by a query string.
  final String query;

  @override
  List<Object> get props => [query];
}
