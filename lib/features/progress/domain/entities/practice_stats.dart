import 'package:equatable/equatable.dart';
import 'package:tava/features/exercise_library/domain/entities/exercise.dart';

class PracticeStats extends Equatable {
  const PracticeStats({
    required this.totalPracticeTime,
    required this.totalSessions,
    required this.averageBpm,
    required this.timeByCategory,
    required this.timeByExercise,
    required this.dailyPracticeTimes,
    required this.weeklyPracticeTimes,
    this.bpmTrend = const [],
  });

  final Duration totalPracticeTime;
  final int totalSessions;
  final int averageBpm;
  final Map<ExerciseCategory, Duration> timeByCategory;
  final Map<String, Duration> timeByExercise;
  final List<DailyPracticeTime> dailyPracticeTimes;
  final List<WeeklyPracticeTime> weeklyPracticeTimes;
  final List<BpmTrendPoint> bpmTrend;

  @override
  List<Object> get props => [
        totalPracticeTime,
        totalSessions,
        averageBpm,
        timeByCategory,
        timeByExercise,
        dailyPracticeTimes,
        weeklyPracticeTimes,
        bpmTrend,
      ];
}

class DailyPracticeTime extends Equatable {
  const DailyPracticeTime({
    required this.date,
    required this.duration,
  });
  final DateTime date;
  final Duration duration;

  @override
  List<Object> get props => [date, duration];
}

class WeeklyPracticeTime extends Equatable {
  const WeeklyPracticeTime({
    required this.weekStart,
    required this.duration,
  });
  final DateTime weekStart;
  final Duration duration;

  @override
  List<Object> get props => [weekStart, duration];
}

class BpmTrendPoint extends Equatable {
  const BpmTrendPoint({
    required this.date,
    required this.averageBpm,
    this.isSeed = false,
  });

  final DateTime date;
  final double averageBpm;
  final bool isSeed;

  @override
  List<Object> get props => [date, averageBpm, isSeed];
}
