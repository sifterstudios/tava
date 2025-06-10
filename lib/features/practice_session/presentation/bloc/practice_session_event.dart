part of 'practice_session_bloc.dart';

abstract class PracticeSessionEvent extends Equatable {
  const PracticeSessionEvent();

  @override
  List<Object?> get props => [];
}

class LoadPracticeSession extends PracticeSessionEvent {}

class StartExercise extends PracticeSessionEvent {

  const StartExercise(this.exercise);
  final Exercise exercise;

  @override
  List<Object> get props => [exercise];
}

class CompleteExercise extends PracticeSessionEvent {

  const CompleteExercise({this.rating, this.notes});
  final int? rating;
  final String? notes;

  @override
  List<Object?> get props => [rating, notes];
}

class PauseSession extends PracticeSessionEvent {}

class ResumeSession extends PracticeSessionEvent {}

class AddMoodMetrics extends PracticeSessionEvent {

  const AddMoodMetrics(this.moodMetrics);
  final MoodMetrics moodMetrics;

  @override
  List<Object> get props => [moodMetrics];
}

class EndSession extends PracticeSessionEvent {}