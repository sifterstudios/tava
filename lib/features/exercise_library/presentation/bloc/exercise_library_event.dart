part of 'exercise_library_bloc.dart';

abstract class ExerciseLibraryEvent extends Equatable {
  const ExerciseLibraryEvent();

  @override
  List<Object?> get props => [];
}

class LoadExercises extends ExerciseLibraryEvent {}

class AddExercise extends ExerciseLibraryEvent {
  final Exercise exercise;

  const AddExercise(this.exercise);

  @override
  List<Object> get props => [exercise];
}

class UpdateExercise extends ExerciseLibraryEvent {
  final Exercise exercise;

  const UpdateExercise(this.exercise);

  @override
  List<Object> get props => [exercise];
}

class DeleteExercise extends ExerciseLibraryEvent {
  final String exerciseId;

  const DeleteExercise(this.exerciseId);

  @override
  List<Object> get props => [exerciseId];
}

class ToggleExerciseFavorite extends ExerciseLibraryEvent {
  final Exercise exercise;

  const ToggleExerciseFavorite(this.exercise);

  @override
  List<Object> get props => [exercise];
}

class FilterByCategory extends ExerciseLibraryEvent {
  final ExerciseCategory? category;

  const FilterByCategory(this.category);

  @override
  List<Object?> get props => [category];
}

class SearchExercises extends ExerciseLibraryEvent {
  final String query;

  const SearchExercises(this.query);

  @override
  List<Object> get props => [query];
}