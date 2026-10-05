import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:tava/features/exercise_library/domain/entities/exercise.dart';
import 'package:tava/features/exercise_library/domain/repositories/exercise_repository.dart';
import 'package:tava/features/practice_session/domain/entities/practice_session.dart';
import 'package:tava/features/practice_session/domain/entities/weather_info.dart';
import 'package:tava/features/practice_session/domain/usecases/get_active_session.dart';
import 'package:tava/features/practice_session/domain/usecases/get_recent_sessions.dart';
import 'package:tava/features/progress/domain/entities/practice_stats.dart';
import 'package:tava/features/progress/domain/usecases/get_practice_stats.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

@injectable
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc({
    required GetActiveSession getActiveSession,
    required GetRecentSessions getRecentSessions,
    required GetPracticeStats getPracticeStats,
    required ExerciseRepository exerciseRepository,
  })  : _getActiveSession = getActiveSession,
        _getRecentSessions = getRecentSessions,
        _getPracticeStats = getPracticeStats,
        _exerciseRepository = exerciseRepository,
        super(const DashboardState.initial()) {
    on<LoadDashboardData>(_onLoadDashboardData);
  }

  final GetActiveSession _getActiveSession;
  final GetRecentSessions _getRecentSessions;
  final GetPracticeStats _getPracticeStats;
  final ExerciseRepository _exerciseRepository;

  Future<void> _onLoadDashboardData(
    LoadDashboardData event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(status: DashboardStatus.loading));

    final activeResult = await _getActiveSession();
    final recentResult = await _getRecentSessions();
    final statsResult = await _getPracticeStats();
    final exercisesResult = await _exerciseRepository.getExercises();

    final failures = <String>[
      ...activeResult.fold((f) => [f.message], (_) => const <String>[]),
      ...recentResult.fold((f) => [f.message], (_) => const <String>[]),
      ...statsResult.fold((f) => [f.message], (_) => const <String>[]),
      ...exercisesResult.fold((f) => [f.message], (_) => const <String>[]),
    ];

    final activeSession = activeResult.fold((_) => null, (s) => s);
    final recentSessions =
        recentResult.fold((_) => const <PracticeSession>[], (s) => s);
    final practiceStats = statsResult.fold((_) => null, (s) => s);
    final suggested = exercisesResult.fold(
      (_) => const <Exercise>[],
      _suggestedFromLibrary,
    );

    final weatherInfo = activeSession?.weatherInfo ??
        recentSessions
            .map((s) => s.weatherInfo)
            .whereType<WeatherInfo>()
            .firstOrNull;

    if (failures.length == 4) {
      emit(
        state.copyWith(
          status: DashboardStatus.failure,
          errorMessage: failures.first,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: DashboardStatus.success,
        activeSession: activeSession,
        recentSessions: recentSessions,
        practiceStats: practiceStats,
        suggestedExercises: suggested,
        weatherInfo: weatherInfo,
        errorMessage: failures.isEmpty ? null : failures.join('; '),
      ),
    );
  }

  List<Exercise> _suggestedFromLibrary(List<Exercise> exercises) {
    final live = exercises.where((e) => !e.isArchived).toList()
      ..sort((a, b) {
        if (a.isFavorite != b.isFavorite) {
          return a.isFavorite ? -1 : 1;
        }
        return b.updatedAt.compareTo(a.updatedAt);
      });
    return live.take(4).toList();
  }
}
