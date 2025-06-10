import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:tava/core/utils/either.dart';
import 'package:tava/features/exercise_library/domain/entities/exercise.dart';
import 'package:tava/features/progress/domain/entities/practice_stats.dart';
import 'package:tava/features/progress/domain/usecases/get_practice_stats.dart';

@dev
@LazySingleton(as: ProgressRepository)
class MockProgressRepository implements ProgressRepository {
  @override
  FutureEitherResult<PracticeStats?> getPracticeStats() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Return mock data
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
      ),
    );
  }
}