part of 'exercise_library_bloc.dart';

enum ExerciseLibraryStatus { initial, loading, success, failure }

class ExerciseLibraryState extends Equatable {
  const ExerciseLibraryState({
    required this.status,
    required this.exercises,
    required this.filteredExercises,
    this.selectedCategory,
    this.searchQuery = '',
    this.errorMessage,
  });

  const ExerciseLibraryState.initial()
      : status = ExerciseLibraryStatus.initial,
        exercises = const [],
        filteredExercises = const [],
        selectedCategory = null,
        searchQuery = '',
        errorMessage = null;

  static const Object _unset = Object();

  final ExerciseLibraryStatus status;
  final List<Exercise> exercises;
  final List<Exercise> filteredExercises;
  final ExerciseCategory? selectedCategory;
  final String searchQuery;
  final String? errorMessage;

  ExerciseLibraryState copyWith({
    ExerciseLibraryStatus? status,
    List<Exercise>? exercises,
    List<Exercise>? filteredExercises,
    Object? selectedCategory = _unset,
    String? searchQuery,
    Object? errorMessage = _unset,
  }) {
    return ExerciseLibraryState(
      status: status ?? this.status,
      exercises: exercises ?? this.exercises,
      filteredExercises: filteredExercises ?? this.filteredExercises,
      selectedCategory: identical(selectedCategory, _unset)
          ? this.selectedCategory
          : selectedCategory as ExerciseCategory?,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: identical(errorMessage, _unset)
          ? this.errorMessage
          : errorMessage as String?,
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
