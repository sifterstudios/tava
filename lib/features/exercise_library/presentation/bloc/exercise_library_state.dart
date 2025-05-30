part of 'exercise_library_bloc.dart';

enum ExerciseLibraryStatus { initial, loading, success, failure }

class ExerciseLibraryState extends Equatable {
  final ExerciseLibraryStatus status;
  final List<Exercise> exercises;
  final List<Exercise> filteredExercises;
  final ExerciseCategory? selectedCategory;
  final String? searchQuery;
  final String? errorMessage;

  const ExerciseLibraryState({
    required this.status,
    required this.exercises,
    required this.filteredExercises,
    this.selectedCategory,
    this.searchQuery,
    this.errorMessage,
  });

  const ExerciseLibraryState.initial()
      : status = ExerciseLibraryStatus.initial,
        exercises = const [],
        filteredExercises = const [],
        selectedCategory = null,
        searchQuery = null,
        errorMessage = null;

  ExerciseLibraryState copyWith({
    ExerciseLibraryStatus? status,
    List<Exercise>? exercises,
    List<Exercise>? filteredExercises,
    ExerciseCategory? selectedCategory,
    String? searchQuery,
    String? errorMessage,
  }) {
    return ExerciseLibraryState(
      status: status ?? this.status,
      exercises: exercises ?? this.exercises,
      filteredExercises: filteredExercises ?? this.filteredExercises,
      selectedCategory: selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        exercises,
        filteredExercises,
        selectedCategory,
        searchQuery,
        errorMessage,
      ];
}