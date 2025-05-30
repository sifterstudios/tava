part of 'practice_session_bloc.dart';

abstract class PracticeSessionEvent extends Equatable {
  const PracticeSessionEvent();

  @override
  List<Object?> get props => [];
}

class LoadPracticeSession extends PracticeSessionEvent {}

class StartExercise extends PracticeSessionEvent {
  final Exercise exercise;

  const StartExercise(this.exercise);

  @override
  List<Object> get props => [exercise];
}

class CompleteExercise extends PracticeSessionEvent {
  final int? rating;
  final String? notes;

  const CompleteExercise({this.rating, this.notes});

  @override
  List<Object?> get props => [rating, notes];
}

class PauseSession extends PracticeSessionEvent {}

class ResumeSession extends PracticeSessionEvent {}

class AddMoodMetrics extends PracticeSessionEvent {
  final MoodMetrics moodMetrics;

  const AddMoodMetrics(this.moodMetrics);

  @override
  List<Object> get props => [moodMetrics];
}

class EndSession extends PracticeSessionEvent {}