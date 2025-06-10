import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:tava/features/exercise_library/domain/entities/exercise.dart';
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
  final GetActiveSession _getActiveSession;
  final GetRecentSessions _getRecentSessions;
  final GetPracticeStats _getPracticeStats;

  DashboardBloc({
    required GetActiveSession getActiveSession,
    required GetRecentSessions getRecentSessions,
    required GetPracticeStats getPracticeStats,
  })  : _getActiveSession = getActiveSession,
        _getRecentSessions = getRecentSessions,
        _getPracticeStats = getPracticeStats,
        super(const DashboardState.initial()) {
    on<LoadDashboardData>(_onLoadDashboardData);
  }

  Future<void> _onLoadDashboardData(
    LoadDashboardData event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(status: DashboardStatus.loading));

    // Get active session if exists
    final activeSessionResult = await _getActiveSession();
    PracticeSession? activeSession;
    
    activeSessionResult.fold(
      (failure) => null, // Ignore failures for active session
      (session) => activeSession = session,
    );

    // Get recent sessions
    final recentSessionsResult = await _getRecentSessions();
    List<PracticeSession> recentSessions = [];
    
    recentSessionsResult.fold(
      (failure) => emit(state.copyWith(
        status: DashboardStatus.failure,
        errorMessage: failure.message,
      )),
      (sessions) => recentSessions = sessions,
    );

    // Get practice stats
    final practiceStatsResult = await _getPracticeStats();
    PracticeStats? practiceStats;
    
    practiceStatsResult.fold(
      (failure) => emit(state.copyWith(
        status: DashboardStatus.failure,
        errorMessage: failure.message,
      )),
      (stats) => practiceStats = stats,
    );

    if (state.status != DashboardStatus.failure) {
      emit(state.copyWith(
        status: DashboardStatus.success,
        activeSession: activeSession,
        recentSessions: recentSessions,
        practiceStats: practiceStats,
        weatherInfo: activeSession?.weatherInfo,
        // In a real app, we'd fetch suggested exercises based on practice history
        suggestedExercises: _getDummySuggestedExercises(),
      ));
    }
  }

  // Temporary method to generate dummy data
  List<Exercise> _getDummySuggestedExercises() {
    return [
      Exercise(
        id: '1',
        name: 'C Major Scale',
        category: ExerciseCategory.scales,
        tags: ['scale', 'beginner'],
        isFavorite: true,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now().subtract(const Duration(days: 2)),
        isArchived: false,
      ),
      Exercise(
        id: '2',
        name: 'Finger Exercise #4',
        category: ExerciseCategory.technique,
        tags: ['technique', 'intermediate'],
        isFavorite: false,
        createdAt: DateTime.now().subtract(const Duration(days: 25)),
        updatedAt: DateTime.now().subtract(const Duration(days: 3)),
        isArchived: false,
      ),
      Exercise(
        id: '3',
        name: 'Bach Prelude',
        category: ExerciseCategory.repertoire,
        tags: ['classical', 'advanced'],
        isFavorite: true,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
        isArchived: false,
      ),
      Exercise(
        id: '4',
        name: 'Sight Reading Ex. 12',
        category: ExerciseCategory.sightReading,
        tags: ['sight reading', 'intermediate'],
        isFavorite: false,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        updatedAt: DateTime.now(),
        isArchived: false,
      ),
    ];
  }
}