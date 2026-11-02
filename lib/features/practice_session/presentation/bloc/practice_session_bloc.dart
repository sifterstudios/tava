import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:tava/core/services/weather_service.dart';
import 'package:tava/features/exercise_library/domain/entities/exercise.dart';
import 'package:tava/features/practice_session/domain/entities/exercise_record.dart';
import 'package:tava/features/practice_session/domain/entities/mood_metrics.dart';
import 'package:tava/features/practice_session/domain/entities/practice_session.dart';
import 'package:tava/features/practice_session/domain/repositories/practice_session_repository.dart';
import 'package:tava/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:uuid/uuid.dart';

part 'practice_session_event.dart';
part 'practice_session_state.dart';

@injectable
class PracticeSessionBloc
    extends Bloc<PracticeSessionEvent, PracticeSessionState> {
  PracticeSessionBloc(
    this._repository,
    this._weatherService,
    this._settingsBloc,
  ) : super(const PracticeSessionState.initial()) {
    on<LoadPracticeSession>(_onLoadPracticeSession);
    on<StartExercise>(_onStartExercise);
    on<CompleteExercise>(_onCompleteExercise);
    on<PauseSession>(_onPauseSession);
    on<ResumeSession>(_onResumeSession);
    on<AddMoodMetrics>(_onAddMoodMetrics);
    on<EndSession>(_onEndSession);
  }

  final PracticeSessionRepository _repository;
  final WeatherService _weatherService;
  final SettingsBloc _settingsBloc;

  Future<void> _onLoadPracticeSession(
    LoadPracticeSession event,
    Emitter<PracticeSessionState> emit,
  ) async {
    emit(state.copyWith(status: PracticeSessionStatus.loading));

    final trackWeather = _settingsBloc.state.trackWeather;
    final weather = await _weatherService.currentWeather(enabled: trackWeather);

    final session = PracticeSession(
      id: const Uuid().v4(),
      startTime: DateTime.now(),
      duration: Duration.zero,
      exercises: const [],
      isActive: true,
      weatherInfo: weather,
    );

    emit(
      state.copyWith(
        status: PracticeSessionStatus.success,
        session: session,
        isRunning: true,
      ),
    );
  }

  void _onStartExercise(
    StartExercise event,
    Emitter<PracticeSessionState> emit,
  ) {
    if (state.session == null) return;
    emit(
      state.copyWith(
        currentExercise: event.exercise,
        currentExerciseStartTime: DateTime.now(),
      ),
    );
  }

  void _onCompleteExercise(
    CompleteExercise event,
    Emitter<PracticeSessionState> emit,
  ) {
    if (state.session == null ||
        state.currentExercise == null ||
        state.currentExerciseStartTime == null) {
      return;
    }

    final rating = event.rating?.clamp(1, 5);
    final now = DateTime.now();
    final duration = now.difference(state.currentExerciseStartTime!);

    final exerciseRecord = ExerciseRecord(
      id: const Uuid().v4(),
      exerciseId: state.currentExercise!.id,
      name: state.currentExercise!.name,
      bpm: state.currentExercise!.targetBpm,
      duration: duration,
      rating: rating,
      notes: event.notes,
    );

    final updatedCompletedExercises =
        List<ExerciseRecord>.from(state.completedExercises)
          ..add(exerciseRecord);

    final updatedSession = state.session!.copyWith(
      exercises: updatedCompletedExercises,
      duration: state.session!.duration + duration,
    );

    emit(
      state.copyWith(
        session: updatedSession,
        completedExercises: updatedCompletedExercises,
        currentExercise: null,
        currentExerciseStartTime: null,
      ),
    );
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
    final metrics = event.moodMetrics;
    final clamped = MoodMetrics(
      energyLevel: metrics.energyLevel.clamp(1, 5),
      focusLevel: metrics.focusLevel.clamp(1, 5),
      sleepQuality: metrics.sleepQuality.clamp(1, 5),
      hadAlcohol: metrics.hadAlcohol,
      notes: metrics.notes,
    );
    emit(
      state.copyWith(
        session: state.session!.copyWith(moodMetrics: clamped),
      ),
    );
  }

  Future<void> _onEndSession(
    EndSession event,
    Emitter<PracticeSessionState> emit,
  ) async {
    if (state.session == null) return;

    final now = DateTime.now();
    var completed = List<ExerciseRecord>.from(state.completedExercises);
    var sessionDuration = state.session!.duration;

    if (state.currentExercise != null &&
        state.currentExerciseStartTime != null) {
      final duration = now.difference(state.currentExerciseStartTime!);
      completed = [
        ...completed,
        ExerciseRecord(
          id: const Uuid().v4(),
          exerciseId: state.currentExercise!.id,
          name: state.currentExercise!.name,
          bpm: state.currentExercise!.targetBpm,
          duration: duration,
          notes: 'Incomplete',
        ),
      ];
      sessionDuration += duration;
    } else if (sessionDuration == Duration.zero) {
      sessionDuration = now.difference(state.session!.startTime);
    }

    final updatedSession = state.session!.copyWith(
      endTime: now,
      isActive: false,
      exercises: completed,
      duration: sessionDuration,
    );

    final result = await _repository.saveSession(
      updatedSession,
      exercises: completed,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: PracticeSessionStatus.failure,
          errorMessage: failure.message,
          session: updatedSession,
          completedExercises: completed,
          currentExercise: null,
          currentExerciseStartTime: null,
          isRunning: false,
        ),
      ),
      (saved) => emit(
        state.copyWith(
          status: PracticeSessionStatus.saved,
          session: saved,
          completedExercises: completed,
          currentExercise: null,
          currentExerciseStartTime: null,
          isRunning: false,
        ),
      ),
    );
  }
}
