import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:tava/features/exercise_library/domain/entities/exercise.dart';
import 'package:tava/features/practice_session/domain/entities/exercise_record.dart';
import 'package:tava/features/practice_session/domain/entities/mood_metrics.dart';
import 'package:tava/features/practice_session/domain/entities/practice_session.dart';
import 'package:tava/features/practice_session/domain/entities/weather_info.dart';
import 'package:uuid/uuid.dart';

part 'practice_session_event.dart';
part 'practice_session_state.dart';

@injectable
class PracticeSessionBloc extends Bloc<PracticeSessionEvent, PracticeSessionState> {
  PracticeSessionBloc() : super(const PracticeSessionState.initial()) {
    on<LoadPracticeSession>(_onLoadPracticeSession);
    on<StartExercise>(_onStartExercise);
    on<CompleteExercise>(_onCompleteExercise);
    on<PauseSession>(_onPauseSession);
    on<ResumeSession>(_onResumeSession);
    on<AddMoodMetrics>(_onAddMoodMetrics);
    on<EndSession>(_onEndSession);
  }

  Future<void> _onLoadPracticeSession(
    LoadPracticeSession event,
    Emitter<PracticeSessionState> emit,
  ) async {
    emit(state.copyWith(status: PracticeSessionStatus.loading));

    // This would normally call a repository method to check for an active session
    // For now, we'll create a new session
    
    final session = PracticeSession(
      id: const Uuid().v4(),
      startTime: DateTime.now(),
      duration: Duration.zero,
      exercises: const [],
      isActive: true,
      weatherInfo: WeatherInfo(
        condition: WeatherCondition.clear,
        temperature: 22.5,
        humidity: 65,
        pressure: 1013.2,
        recordedAt: DateTime.now(),
      ),
    );
    
    emit(state.copyWith(
      status: PracticeSessionStatus.success,
      session: session,
      isRunning: true,
    ),);
  }

  void _onStartExercise(
    StartExercise event,
    Emitter<PracticeSessionState> emit,
  ) {
    if (state.session == null) return;
    
    emit(state.copyWith(
      currentExercise: event.exercise,
      currentExerciseStartTime: DateTime.now(),
    ),);
  }

  void _onCompleteExercise(
    CompleteExercise event,
    Emitter<PracticeSessionState> emit,
  ) {
    if (state.session == null || state.currentExercise == null || state.currentExerciseStartTime == null) {
      return;
    }
    
    final now = DateTime.now();
    final duration = now.difference(state.currentExerciseStartTime!);
    
    final exerciseRecord = ExerciseRecord(
      id: const Uuid().v4(),
      exerciseId: state.currentExercise!.id,
      name: state.currentExercise!.name,
      bpm: state.currentExercise!.targetBpm,
      duration: duration,
      rating: event.rating,
      notes: event.notes,
    );
    
    final updatedCompletedExercises = List<ExerciseRecord>.from(state.completedExercises)
      ..add(exerciseRecord);
    
    final updatedSession = state.session!.copyWith(
      exercises: updatedCompletedExercises,
      duration: state.session!.duration + duration,
    );
    
    emit(state.copyWith(
      session: updatedSession,
      completedExercises: updatedCompletedExercises,
    ),);
  }

  void _onPauseSession(
    PauseSession event,
    Emitter<PracticeSessionState> emit,
  ) {
    emit(state.copyWith(isRunning: false));
  }

  void _onResumeSession(
    ResumeSession event,
    Emitter<PracticeSessionState> emit,
  ) {
    emit(state.copyWith(isRunning: true));
  }

  void _onAddMoodMetrics(
    AddMoodMetrics event,
    Emitter<PracticeSessionState> emit,
  ) {
    if (state.session == null) return;
    
    final updatedSession = state.session!.copyWith(
      moodMetrics: event.moodMetrics,
    );
    
    emit(state.copyWith(session: updatedSession));
  }

  void _onEndSession(
    EndSession event,
    Emitter<PracticeSessionState> emit,
  ) {
    if (state.session == null) return;
    
    final now = DateTime.now();
    var updatedState = state;
    
    // If there's a current exercise, complete it first
    if (state.currentExercise != null && state.currentExerciseStartTime != null) {
      final duration = now.difference(state.currentExerciseStartTime!);
      
      final exerciseRecord = ExerciseRecord(
        id: const Uuid().v4(),
        exerciseId: state.currentExercise!.id,
        name: state.currentExercise!.name,
        bpm: state.currentExercise!.targetBpm,
        duration: duration,
        notes: 'Incomplete',
      );
      
      final updatedExercises = List<ExerciseRecord>.from(state.completedExercises)..add(exerciseRecord);
      
      updatedState = state.copyWith(
        completedExercises: updatedExercises,
      );
    }
    
    final updatedSession = updatedState.session!.copyWith(
      endTime: now,
      isActive: false,
    );
    
    // This would normally call a repository method to save the session
    
    emit(updatedState.copyWith(
      status: PracticeSessionStatus.saved,
      session: updatedSession,
      isRunning: false,
    ),);
  }
}