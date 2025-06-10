import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:tava/features/exercise_library/domain/entities/exercise.dart';
import 'package:tava/features/practice_session/domain/entities/practice_session.dart';
import 'package:tava/features/practice_session/domain/entities/weather_info.dart';
import 'package:tava/features/progress/domain/entities/practice_stats.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

@injectable
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(const DashboardState.initial()) {
    on<LoadDashboardData>(_onLoadDashboardData);
  }

  Future<void> _onLoadDashboardData(
      LoadDashboardData event,
      Emitter<DashboardState> emit,
      ) async {
    emit(state.copyWith(status: DashboardStatus.loading));

    // In a real app, we'd fetch data from repositories
    // For now, we'll use mock data
    await Future.delayed(const Duration(milliseconds: 500));

    final mockPracticeStats = PracticeStats(
      totalPracticeTime: const Duration(hours: 10, minutes: 30),
      totalSessions: 15,
      averageBpm: 95,
      timeByCategory: const {
        ExerciseCategory.scales: Duration(hours: 3, minutes: 15),
        ExerciseCategory.technique: Duration(hours: 2, minutes: 45),
        ExerciseCategory.repertoire: Duration(hours: 4, minutes: 30),
      },
      timeByExercise: const {
        'C Major Scale': Duration(hours: 2, minutes: 15),
        'Bach Prelude': Duration(hours: 1, minutes: 45),
      },
      dailyPracticeTimes: [
        DailyPracticeTime(
          date: DateTime.now().subtract(const Duration(days: 6)),
          duration: const Duration(minutes: 45),
        ),
        DailyPracticeTime(
          date: DateTime.now().subtract(const Duration(days: 5)),
          duration: const Duration(minutes: 30),
        ),
        DailyPracticeTime(
          date: DateTime.now().subtract(const Duration(days: 4)),
          duration: const Duration(hours: 1, minutes: 15),
        ),
        DailyPracticeTime(
          date: DateTime.now().subtract(const Duration(days: 3)),
          duration: const Duration(minutes: 45),
        ),
        DailyPracticeTime(
          date: DateTime.now().subtract(const Duration(days: 2)),
          duration: const Duration(hours: 1),),
        DailyPracticeTime(
          date: DateTime.now().subtract(const Duration(days: 1)),
          duration: const Duration(minutes: 30),
        ),
        DailyPracticeTime(
          date: DateTime.now(),
          duration: const Duration(hours: 1, minutes: 15),
        ),
      ],
      weeklyPracticeTimes: [
        WeeklyPracticeTime(
          weekStart: DateTime.now().subtract(const Duration(days: 21)),
          duration: const Duration(hours: 3, minutes: 30),
        ),
        WeeklyPracticeTime(
          weekStart: DateTime.now().subtract(const Duration(days: 14)),
          duration: const Duration(hours: 4, minutes: 15),
        ),
        WeeklyPracticeTime(
          weekStart: DateTime.now().subtract(const Duration(days: 7)),
          duration: const Duration(hours: 5, minutes: 45),
        ),
      ],
    );

    emit(state.copyWith(
      status: DashboardStatus.success,
      practiceStats: mockPracticeStats,
      suggestedExercises: _getDummySuggestedExercises(),
    ),);
  }

  // Temporary method to generate dummy data
  List<Exercise> _getDummySuggestedExercises() {
    return [
      Exercise(
        id: '1',
        name: 'C Major Scale',
        category: ExerciseCategory.scales,
        tags: const ['scale', 'beginner'],
        isFavorite: true,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now().subtract(const Duration(days: 2)),
        isArchived: false,
      ),
      Exercise(
        id: '2',
        name: 'Finger Exercise #4',
        category: ExerciseCategory.technique,
        tags: const ['technique', 'intermediate'],
        isFavorite: false,
        createdAt: DateTime.now().subtract(const Duration(days: 25)),
        updatedAt: DateTime.now().subtract(const Duration(days: 3)),
        isArchived: false,
      ),
      Exercise(
        id: '3',
        name: 'Bach Prelude',
        category: ExerciseCategory.repertoire,
        tags: const ['classical', 'advanced'],
        isFavorite: true,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
        isArchived: false,
      ),
      Exercise(
        id: '4',
        name: 'Sight Reading Ex. 12',
        category: ExerciseCategory.sightReading,
        tags: const ['sight reading', 'intermediate'],
        isFavorite: false,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        updatedAt: DateTime.now(),
        isArchived: false,
      ),
    ];
  }
}