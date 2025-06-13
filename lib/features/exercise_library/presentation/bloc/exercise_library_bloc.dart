import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:tava/features/exercise_library/domain/entities/exercise.dart';
import 'package:tava/features/practice_session/domain/entities/exercise_category.dart';

part 'exercise_library_event.dart';

part 'exercise_library_state.dart';

/// Bloc for managing the exercise library state.
@injectable
class ExerciseLibraryBloc
    extends Bloc<ExerciseLibraryEvent, ExerciseLibraryState> {
  /// Creates an instance of [ExerciseLibraryBloc].
  ExerciseLibraryBloc() : super(const ExerciseLibraryState.initial()) {
    on<LoadExercises>(_onLoadExercises);
    on<AddExercise>(_onAddExercise);
    on<UpdateExercise>(_onUpdateExercise);
    on<DeleteExercise>(_onDeleteExercise);
    on<ToggleExerciseFavorite>(_onToggleExerciseFavorite);
    on<FilterByCategory>(_onFilterByCategory);
    on<SearchExercises>(_onSearchExercises);
  }

  Future<void> _onLoadExercises(
    LoadExercises event,
    Emitter<ExerciseLibraryState> emit,
  ) async {
    emit(state.copyWith(status: ExerciseLibraryStatus.loading));

    // TODO(sifterstudios): This would normally call a repository method,
    // but for now we'll use mock data
    await Future<void>.delayed(const Duration(milliseconds: 500));

    final exercises = _getMockExercises();

    emit(state.copyWith(
      status: ExerciseLibraryStatus.success,
      exercises: exercises,
      filteredExercises: exercises,
    ));
  }

  void _onAddExercise(
    AddExercise event,
    Emitter<ExerciseLibraryState> emit,
  ) {
    final updatedExercises = List<Exercise>.from(state.exercises)
      ..add(event.exercise);

    emit(state.copyWith(
      exercises: updatedExercises,
      filteredExercises: _applyFilters(
        updatedExercises,
        state.selectedCategory,
        state.searchQuery,
      ),
    ));
  }

  void _onUpdateExercise(
    UpdateExercise event,
    Emitter<ExerciseLibraryState> emit,
  ) {
    final updatedExercises = List<Exercise>.from(state.exercises);
    final index = updatedExercises.indexWhere((e) => e.id == event.exercise.id);

    if (index != -1) {
      updatedExercises[index] = event.exercise;

      emit(state.copyWith(
        exercises: updatedExercises,
        filteredExercises: _applyFilters(
          updatedExercises,
          state.selectedCategory,
          state.searchQuery,
        ),
      ));
    }
  }

  void _onDeleteExercise(
    DeleteExercise event,
    Emitter<ExerciseLibraryState> emit,
  ) {
    final updatedExercises = List<Exercise>.from(state.exercises)
      ..removeWhere((e) => e.id == event.exerciseId);

    emit(state.copyWith(
      exercises: updatedExercises,
      filteredExercises: _applyFilters(
        updatedExercises,
        state.selectedCategory,
        state.searchQuery,
      ),
    ));
  }

  void _onToggleExerciseFavorite(
    ToggleExerciseFavorite event,
    Emitter<ExerciseLibraryState> emit,
  ) {
    final updatedExercises = List<Exercise>.from(state.exercises);
    final index = updatedExercises.indexWhere((e) => e.id == event.exercise.id);

    if (index != -1) {
      updatedExercises[index] = event.exercise.copyWith(
        isFavorite: !event.exercise.isFavorite,
      );

      emit(state.copyWith(
        exercises: updatedExercises,
        filteredExercises: _applyFilters(
          updatedExercises,
          state.selectedCategory,
          state.searchQuery,
        ),
      ));
    }
  }

  void _onFilterByCategory(
    FilterByCategory event,
    Emitter<ExerciseLibraryState> emit,
  ) {
    emit(state.copyWith(
      selectedCategory: event.category,
      filteredExercises: _applyFilters(
        state.exercises,
        event.category,
        state.searchQuery,
      ),
    ));
  }

  void _onSearchExercises(
    SearchExercises event,
    Emitter<ExerciseLibraryState> emit,
  ) {
    emit(state.copyWith(
      searchQuery: event.query,
      filteredExercises: _applyFilters(
        state.exercises,
        state.selectedCategory,
        event.query,
      ),
    ));
  }

  List<Exercise> _applyFilters(
    List<Exercise> exercises,
    ExerciseCategory? category,
    String? query,
  ) {
    var filtered = exercises;

    // Apply category filter
    if (category != null) {
      filtered = filtered.where((e) => e.category == category).toList();
    }

    // Apply search query
    if (query != null && query.isNotEmpty) {
      final lowercaseQuery = query.toLowerCase();
      filtered = filtered.where((e) {
        return e.name.toLowerCase().contains(lowercaseQuery) ||
            (e.description?.toLowerCase().contains(lowercaseQuery) ?? false) ||
            e.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery));
      }).toList();
    }

    return filtered;
  }

  List<Exercise> _getMockExercises() {
    return [
      Exercise(
        id: '1',
        name: 'C Major Scale',
        description: 'Basic C major scale practice',
        category: ExerciseCategory(
          id: 'scales',
          name: 'Scales',
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
          updatedAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        categoryId: 'scales',
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
        category: ExerciseCategory(
          id: 'technique',
          name: 'Technique',
          createdAt: DateTime.now().subtract(const Duration(days: 25)),
          updatedAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
        categoryId: 'technique',
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
        category: ExerciseCategory(
          id: 'repertoire',
          name: 'Repertoire',
          createdAt: DateTime.now().subtract(const Duration(days: 20)),
          updatedAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        categoryId: 'repertoire',
        targetBpm: 100,
        tags: const ['repertoire', 'advanced'],
        isFavorite: true,
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
        isArchived: false,
      ),
      Exercise(
        id: '4',
        name: 'Sight Reading Exercise #1',
        description: 'Basic sight reading exercise',
        category: ExerciseCategory(
          id: 'sightReading',
          name: 'Sight Reading',
          createdAt: DateTime.now().subtract(const Duration(days: 15)),
          updatedAt: DateTime.now().subtract(const Duration(days: 5)),
        ),
        categoryId: 'sightReading',
        targetBpm: 80,
        tags: const ['sight reading', 'beginner'],
        isFavorite: false,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        updatedAt: DateTime.now().subtract(const Duration(days: 5)),
        isArchived: false,
      ),
    ];
  }

  /// Returns a list of unique exercise categories from the current state.
  List<ExerciseCategory> get categories => state.exercises
      .map((e) => e.category)
      .where((e) => e != null)
      .cast<ExerciseCategory>()
      .toSet()
      .toList();
}
