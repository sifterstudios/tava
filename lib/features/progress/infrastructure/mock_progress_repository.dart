import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:tava/core/utils/either.dart';
import 'package:tava/features/exercise_library/domain/entities/exercise.dart';
import 'package:tava/features/progress/domain/entities/practice_stats.dart';
import 'package:tava/features/progress/domain/usecases/get_practice_stats.dart';
import 'package:tava/features/progress/infrastructure/progress_repository_impl.dart';

@Environment('dev')
@LazySingleton(as: ProgressRepository)
class MockProgressRepository implements ProgressRepository {
  @override
  FutureEitherResult<PracticeStats?> getPracticeStats() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final now = DateTime.now();
    return right(
      PracticeStats(
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
          for (var i = 6; i >= 0; i--)
            DailyPracticeTime(
              date: now.subtract(Duration(days: i)),
              duration: Duration(minutes: 20 + i * 5),
            ),
        ],
        weeklyPracticeTimes: const [],
        bpmTrend: ProgressRepositoryImpl.seedBpmTrend(),
      ),
    );
  }
}
