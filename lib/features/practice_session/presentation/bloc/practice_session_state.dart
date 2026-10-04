part of 'practice_session_bloc.dart';

enum PracticeSessionStatus { initial, loading, success, failure, saved }

class PracticeSessionState extends Equatable {
  const PracticeSessionState({
    required this.status,
    required this.completedExercises,
    required this.isRunning,
    this.session,
    this.currentExercise,
    this.currentExerciseStartTime,
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

  static const Object _unset = Object();

  final PracticeSessionStatus status;
  final PracticeSession? session;
  final Exercise? currentExercise;
  final DateTime? currentExerciseStartTime;
  final List<ExerciseRecord> completedExercises;
  final bool isRunning;
  final String? errorMessage;

  PracticeSessionState copyWith({
    PracticeSessionStatus? status,
    Object? session = _unset,
    Object? currentExercise = _unset,
    Object? currentExerciseStartTime = _unset,
    List<ExerciseRecord>? completedExercises,
    bool? isRunning,
    Object? errorMessage = _unset,
  }) {
    return PracticeSessionState(
      status: status ?? this.status,
      session: identical(session, _unset)
          ? this.session
          : session as PracticeSession?,
      currentExercise: identical(currentExercise, _unset)
          ? this.currentExercise
          : currentExercise as Exercise?,
      currentExerciseStartTime: identical(currentExerciseStartTime, _unset)
          ? this.currentExerciseStartTime
          : currentExerciseStartTime as DateTime?,
      completedExercises: completedExercises ?? this.completedExercises,
      isRunning: isRunning ?? this.isRunning,
      errorMessage: identical(errorMessage, _unset)
          ? this.errorMessage
          : errorMessage as String?,
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
