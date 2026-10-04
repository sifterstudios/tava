import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:tava/features/exercise_library/domain/entities/exercise.dart';
import 'package:tava/features/exercise_library/domain/repositories/exercise_repository.dart';

part 'exercise_library_event.dart';
part 'exercise_library_state.dart';

@injectable
class ExerciseLibraryBloc
    extends Bloc<ExerciseLibraryEvent, ExerciseLibraryState> {
  ExerciseLibraryBloc(this._repository)
      : super(const ExerciseLibraryState.initial()) {
    on<LoadExercises>(_onLoadExercises);
    on<AddExercise>(_onAddExercise);
    on<UpdateExercise>(_onUpdateExercise);
    on<DeleteExercise>(_onDeleteExercise);
    on<ToggleExerciseFavorite>(_onToggleExerciseFavorite);
    on<FilterByCategory>(_onFilterByCategory);
    on<SearchExercises>(_onSearchExercises);
  }

  final ExerciseRepository _repository;

  Future<void> _onLoadExercises(
    LoadExercises event,
    Emitter<ExerciseLibraryState> emit,
  ) async {
    emit(state.copyWith(status: ExerciseLibraryStatus.loading));
    final result = await _repository.getExercises();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ExerciseLibraryStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (exercises) => emit(
        state.copyWith(
          status: ExerciseLibraryStatus.success,
          exercises: exercises,
          filteredExercises: _applyFilters(
            exercises,
            state.selectedCategory,
            state.searchQuery,
          ),
          errorMessage: null,
        ),
      ),
    );
  }

  Future<void> _onAddExercise(
    AddExercise event,
    Emitter<ExerciseLibraryState> emit,
  ) async {
    final result = await _repository.upsertExercise(event.exercise);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ExerciseLibraryStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) => add(LoadExercises()),
    );
  }

  Future<void> _onUpdateExercise(
    UpdateExercise event,
    Emitter<ExerciseLibraryState> emit,
  ) async {
    final result = await _repository.upsertExercise(event.exercise);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ExerciseLibraryStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) => add(LoadExercises()),
    );
  }

  Future<void> _onDeleteExercise(
    DeleteExercise event,
    Emitter<ExerciseLibraryState> emit,
  ) async {
    final result = await _repository.deleteExercise(event.exerciseId);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ExerciseLibraryStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) => add(LoadExercises()),
    );
  }

  Future<void> _onToggleExerciseFavorite(
    ToggleExerciseFavorite event,
    Emitter<ExerciseLibraryState> emit,
  ) async {
    final result = await _repository.toggleFavorite(event.exercise);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ExerciseLibraryStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) => add(LoadExercises()),
    );
  }

  void _onFilterByCategory(
    FilterByCategory event,
    Emitter<ExerciseLibraryState> emit,
  ) {
    emit(
      state.copyWith(
        selectedCategory: event.category,
        filteredExercises: _applyFilters(
          state.exercises,
          event.category,
          state.searchQuery,
        ),
      ),
    );
  }

  void _onSearchExercises(
    SearchExercises event,
    Emitter<ExerciseLibraryState> emit,
  ) {
    emit(
      state.copyWith(
        searchQuery: event.query,
        filteredExercises: _applyFilters(
          state.exercises,
          state.selectedCategory,
          event.query,
        ),
      ),
    );
  }

  List<Exercise> _applyFilters(
    List<Exercise> exercises,
    ExerciseCategory? category,
    String? query,
  ) {
    var filtered = exercises.where((e) => !e.isArchived).toList();
    if (category != null) {
      filtered = filtered.where((e) => e.category == category).toList();
    }
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
}
