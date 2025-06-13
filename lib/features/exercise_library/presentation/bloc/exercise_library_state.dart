part of 'exercise_library_bloc.dart';

/// Base class for exercise library events in the application.
enum ExerciseLibraryStatus {
  /// Represents the initial state of the exercise library.
  initial,

  /// Represents the state when exercises are being loaded.
  loading,

  /// Represents the state when exercises have been successfully loaded.
  success,

  /// Represents the state when there was an error loading exercises.
  failure
}

/// Represents the state of the exercise library.
class ExerciseLibraryState extends Equatable {
  /// Constructs an [ExerciseLibraryState] with the given parameters.
  const ExerciseLibraryState({
    required this.status,
    required this.exercises,
    required this.filteredExercises,
    this.selectedCategory,
    this.searchQuery,
    this.errorMessage,
  });

  /// Creates an initial state of [ExerciseLibraryState] with default values.
  const ExerciseLibraryState.initial()
      : status = ExerciseLibraryStatus.initial,
        exercises = const [],
        filteredExercises = const [],
        selectedCategory = null,
        searchQuery = null,
        errorMessage = null;

  /// Creates an instance of [ExerciseLibraryState].
  final ExerciseLibraryStatus status;

  /// The list of all exercises in the library.
  final List<Exercise> exercises;

  /// The list of exercises filtered by the selected category or search query.
  final List<Exercise> filteredExercises;

  /// The currently selected exercise category, if any.
  final ExerciseCategory? selectedCategory;

  /// The search query used to filter exercises, if any.
  final String? searchQuery;

  /// An optional error message if there was an error loading exercises.
  final String? errorMessage;

  /// Creates a copy of the current state with the given parameters.
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

  /// Returns a list of unique exercise categories from the exercises.
  List<ExerciseCategory> get categories {
    return exercises
        .map((e) => e.category)
        .where((c) => c != null)
        .cast<ExerciseCategory>()
        .toSet()
        .toList();
  }
}
