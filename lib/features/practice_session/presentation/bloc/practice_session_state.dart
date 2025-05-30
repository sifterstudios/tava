part of 'practice_session_bloc.dart';

enum PracticeSessionStatus { initial, loading, success, failure, saved }

class PracticeSessionState extends Equatable {
  final PracticeSessionStatus status;
  final PracticeSession? session;
  final Exercise? currentExercise;
  final DateTime? currentExerciseStartTime;
  final List<ExerciseRecord> completedExercises;
  final bool isRunning;
  final String? errorMessage;

  const PracticeSessionState({
    required this.status,
    this.session,
    this.currentExercise,
    this.currentExerciseStartTime,
    required this.completedExercises,
    required this.isRunning,
    this.errorMessage,
  });

  const PracticeSessionState.initial()
      : status = PracticeSessionStatus.initial,
        session = null,
        currentExercise = null,
        currentExerciseStartTime = null,
        completedExercises = const [],
        isRunning = false,
        errorMessage = null;

  PracticeSessionState copyWith({
    PracticeSessionStatus? status,
    PracticeSession? session,
    Exercise? currentExercise,
    DateTime? currentExerciseStartTime,
    List<ExerciseRecord>? completedExercises,
    bool? isRunning,
    String? errorMessage,
  }) {
    return PracticeSessionState(
      status: status ?? this.status,
      session: session ?? this.session,
      currentExercise: currentExercise,
      currentExerciseStartTime: currentExerciseStartTime,
      completedExercises: completedExercises ?? this.completedExercises,
      isRunning: isRunning ?? this.isRunning,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        session,
        currentExercise,
        currentExerciseStartTime,
        completedExercises,
        isRunning,
        errorMessage,
      ];
}