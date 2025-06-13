import 'package:equatable/equatable.dart';

class PracticeStats extends Equatable {
  final Duration totalPracticeTime;
  final int totalSessions;
  final int averageBpm;
  final Map<String, Duration> timeByCategory; // Now uses category ID instead of enum
  final Map<String, Duration> timeByExercise;
  final List<DailyPracticeTime> dailyPracticeTimes;
  final List<WeeklyPracticeTime> weeklyPracticeTimes;

  const PracticeStats({
    required this.totalPracticeTime,
    required this.totalSessions,
    required this.averageBpm,
    required this.timeByCategory,
    required this.timeByExercise,
    required this.dailyPracticeTimes,
    required this.weeklyPracticeTimes,
  });

  @override
  List<Object> get props => [
        totalPracticeTime,
        totalSessions,
        averageBpm,
        timeByCategory,
        timeByExercise,
        dailyPracticeTimes,
        weeklyPracticeTimes,
      ];
}

class DailyPracticeTime extends Equatable {
  final DateTime date;
  final Duration duration;

  const DailyPracticeTime({
    required this.date,
    required this.duration,
  });

  @override
  List<Object> get props => [date, duration];
}

class WeeklyPracticeTime extends Equatable {
  final DateTime weekStart;
  final Duration duration;

  const WeeklyPracticeTime({
    required this.weekStart,
    required this.duration,
  });

  @override
  List<Object> get props => [weekStart, duration];
}