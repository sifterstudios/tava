import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tava/core/error/failures.dart';
import 'package:tava/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:tava/features/exercise_library/domain/entities/exercise.dart';
import 'package:tava/features/exercise_library/domain/repositories/exercise_repository.dart';
import 'package:tava/features/practice_session/domain/entities/practice_session.dart';
import 'package:tava/features/practice_session/domain/usecases/get_active_session.dart';
import 'package:tava/features/practice_session/domain/usecases/get_recent_sessions.dart';
import 'package:tava/features/progress/domain/entities/practice_stats.dart';
import 'package:tava/features/progress/domain/usecases/get_practice_stats.dart';

class _MockGetActive extends Mock implements GetActiveSession {}

class _MockGetRecent extends Mock implements GetRecentSessions {}

class _MockGetStats extends Mock implements GetPracticeStats {}

class _MockExercises extends Mock implements ExerciseRepository {}

void main() {
  late _MockGetActive getActive;
  late _MockGetRecent getRecent;
  late _MockGetStats getStats;
  late _MockExercises exercises;

  final now = DateTime(2026, 10, 5);
  final favorite = Exercise(
    id: '1',
    name: 'Favorite scale',
    category: ExerciseCategory.scales,
    tags: const [],
    isFavorite: true,
    createdAt: now,
    updatedAt: now,
    isArchived: false,
  );
  final other = Exercise(
    id: '2',
    name: 'Other',
    category: ExerciseCategory.technique,
    tags: const [],
    isFavorite: false,
    createdAt: now,
    updatedAt: now.subtract(const Duration(days: 1)),
    isArchived: false,
  );
  final archived = Exercise(
    id: '3',
    name: 'Archived',
    category: ExerciseCategory.repertoire,
    tags: const [],
    isFavorite: true,
    createdAt: now,
    updatedAt: now,
    isArchived: true,
  );
  const stats = PracticeStats(
    totalPracticeTime: Duration(hours: 2),
    totalSessions: 3,
    averageBpm: 90,
    timeByCategory: {},
    timeByExercise: {},
    dailyPracticeTimes: [],
    weeklyPracticeTimes: [],
  );
  final session = PracticeSession(
    id: 's1',
    startTime: now,
    duration: const Duration(minutes: 20),
    exercises: const [],
    isActive: false,
  );

  setUp(() {
    getActive = _MockGetActive();
    getRecent = _MockGetRecent();
    getStats = _MockGetStats();
    exercises = _MockExercises();
  });

  DashboardBloc buildBloc() => DashboardBloc(
        getActiveSession: getActive,
        getRecentSessions: getRecent,
        getPracticeStats: getStats,
        exerciseRepository: exercises,
      );

  group('DashboardBloc', () {
    blocTest<DashboardBloc, DashboardState>(
      'loads real session/stats/exercise data',
      build: () {
        when(() => getActive()).thenAnswer((_) async => const Right(null));
        when(() => getRecent()).thenAnswer((_) async => Right([session]));
        when(() => getStats()).thenAnswer((_) async => Right(stats));
        when(() => exercises.getExercises()).thenAnswer(
          (_) async => Right([other, favorite, archived]),
        );
        return buildBloc();
      },
      act: (bloc) => bloc.add(LoadDashboardData()),
      expect: () => [
        isA<DashboardState>()
            .having((s) => s.status, 'status', DashboardStatus.loading),
        isA<DashboardState>()
            .having((s) => s.status, 'status', DashboardStatus.success)
            .having((s) => s.recentSessions, 'recent', [session])
            .having((s) => s.practiceStats, 'stats', stats)
            .having(
              (s) => s.suggestedExercises.map((e) => e.id).toList(),
              'suggested ids',
              ['1', '2'],
            ),
      ],
    );

    blocTest<DashboardBloc, DashboardState>(
      'emits failure when every source fails',
      build: () {
        when(() => getActive()).thenAnswer(
          (_) async => const Left(ServerFailure(message: 'down')),
        );
        when(() => getRecent()).thenAnswer(
          (_) async => const Left(ServerFailure(message: 'down')),
        );
        when(() => getStats()).thenAnswer(
          (_) async => const Left(ServerFailure(message: 'down')),
        );
        when(() => exercises.getExercises()).thenAnswer(
          (_) async => const Left(ServerFailure(message: 'down')),
        );
        return buildBloc();
      },
      act: (bloc) => bloc.add(LoadDashboardData()),
      expect: () => [
        isA<DashboardState>()
            .having((s) => s.status, 'status', DashboardStatus.loading),
        isA<DashboardState>()
            .having((s) => s.status, 'status', DashboardStatus.failure)
            .having((s) => s.errorMessage, 'error', 'down'),
      ],
    );
  });
}
