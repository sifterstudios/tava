import 'package:equatable/equatable.dart';
import 'package:tava/features/practice_session/domain/entities/exercise_record.dart';
import 'package:tava/features/practice_session/domain/entities/mood_metrics.dart';
import 'package:tava/features/practice_session/domain/entities/weather_info.dart';

class PracticeSession extends Equatable {
  final String id;
  final DateTime startTime;
  final DateTime? endTime;
  final Duration duration;
  final String? notes;
  final List<ExerciseRecord> exercises;
  final MoodMetrics? moodMetrics;
  final WeatherInfo? weatherInfo;
  final bool isActive;

  const PracticeSession({
    required this.id,
    required this.startTime,
    this.endTime,
    required this.duration,
    this.notes,
    required this.exercises,
    this.moodMetrics,
    this.weatherInfo,
    required this.isActive,
  });

  PracticeSession copyWith({
    String? id,
    DateTime? startTime,
    DateTime? endTime,
    Duration? duration,
    String? notes,
    List<ExerciseRecord>? exercises,
    MoodMetrics? moodMetrics,
    WeatherInfo? weatherInfo,
    bool? isActive,
  }) {
    return PracticeSession(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      duration: duration ?? this.duration,
      notes: notes ?? this.notes,
      exercises: exercises ?? this.exercises,
      moodMetrics: moodMetrics ?? this.moodMetrics,
      weatherInfo: weatherInfo ?? this.weatherInfo,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [
    id,
    startTime,
    endTime,
    duration,
    notes,
    exercises,
    moodMetrics,
    weatherInfo,
    isActive,
  ];
}