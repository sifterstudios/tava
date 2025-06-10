part of 'exercise_library_bloc.dart';

abstract class ExerciseLibraryEvent extends Equatable {
  const ExerciseLibraryEvent();

  @override
  List<Object?> get props => [];
}

class LoadExercises extends ExerciseLibraryEvent {}

class AddExercise extends ExerciseLibraryEvent {

  const AddExercise(this.exercise);
  final Exercise exercise;

  @override
  List<Object> get props => [exercise];
}

class UpdateExercise extends ExerciseLibraryEvent {

  const UpdateExercise(this.exercise);
  final Exercise exercise;

  @override
  List<Object> get props => [exercise];
}

class DeleteExercise extends ExerciseLibraryEvent {

  const DeleteExercise(this.exerciseId);
  final String exerciseId;

  @override
  List<Object> get props => [exerciseId];
}

class ToggleExerciseFavorite extends ExerciseLibraryEvent {

  const ToggleExerciseFavorite(this.exercise);
  final Exercise exercise;

  @override
  List<Object> get props => [exercise];
}

class FilterByCategory extends ExerciseLibraryEvent {

  const FilterByCategory(this.category);
  final ExerciseCategory? category;

  @override
  List<Object?> get props => [category];
}

class SearchExercises extends ExerciseLibraryEvent {

  const SearchExercises(this.query);
  final String query;

  @override
  List<Object> get props => [query];
}