import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tava/core/services/weather_service.dart';
import 'package:tava/features/exercise_library/domain/entities/exercise.dart';
import 'package:tava/features/practice_session/domain/entities/exercise_record.dart';
import 'package:tava/features/practice_session/domain/entities/practice_session.dart';
import 'package:tava/features/practice_session/domain/repositories/practice_session_repository.dart';
import 'package:tava/features/practice_session/presentation/bloc/practice_session_bloc.dart';
import 'package:tava/features/settings/domain/usecases/get_settings.dart';
import 'package:tava/features/settings/domain/usecases/update_settings.dart';
import 'package:tava/features/settings/presentation/bloc/settings_bloc.dart';

class _MockRepo extends Mock implements PracticeSessionRepository {}

class _MockWeather extends Mock implements WeatherService {}

class _MockGetSettings extends Mock implements GetSettings {}

class _MockUpdateSettings extends Mock implements UpdateSettings {}

void main() {
  late _MockRepo repo;
  late _MockWeather weather;
  late SettingsBloc settingsBloc;

  final exercise = Exercise(
    id: 'ex-1',
    name: 'C Major Scale',
    category: ExerciseCategory.scales,
    tags: const ['scale'],
    isFavorite: false,
    createdAt: DateTime(2026),
    updatedAt: DateTime(2026),
    isArchived: false,
    targetBpm: 90,
  );

  setUpAll(() {
    registerFallbackValue(
      PracticeSession(
        id: 's',
        startTime: DateTime(2026),
        duration: Duration.zero,
        exercises: const [],
        isActive: true,
      ),
    );
    registerFallbackValue(<ExerciseRecord>[]);
  });

  setUp(() {
    repo = _MockRepo();
    weather = _MockWeather();
    settingsBloc = SettingsBloc(
      getSettings: _MockGetSettings(),
      updateSettings: _MockUpdateSettings(),
    );
    when(
      () => weather.currentWeather(enabled: any(named: 'enabled')),
    ).thenAnswer((_) async => null);
    when(
      () => repo.saveSession(any(), exercises: any(named: 'exercises')),
    ).thenAnswer((invocation) async {
      final session =
          invocation.positionalArguments.first as PracticeSession;
      return Right(session);
    });
  });

  tearDown(() async {
    await settingsBloc.close();
  });

  PracticeSessionBloc buildBloc() =>
      PracticeSessionBloc(repo, weather, settingsBloc);

  group('PracticeSessionBloc', () {
    blocTest<PracticeSessionBloc, PracticeSessionState>(
      'creates a session on load',
      build: buildBloc,
      act: (bloc) => bloc.add(LoadPracticeSession()),
      wait: const Duration(milliseconds: 10),
      expect: () => [
        isA<PracticeSessionState>().having(
          (s) => s.status,
          'status',
          PracticeSessionStatus.loading,
        ),
        isA<PracticeSessionState>()
            .having(
              (s) => s.status,
              'status',
              PracticeSessionStatus.success,
            )
            .having((s) => s.session, 'session', isNotNull)
            .having((s) => s.isRunning, 'running', isTrue),
      ],
    );

    blocTest<PracticeSessionBloc, PracticeSessionState>(
      'preserves current exercise across pause/resume',
      build: buildBloc,
      act: (bloc) async {
        bloc.add(LoadPracticeSession());
        await Future<void>.delayed(const Duration(milliseconds: 20));
        bloc.add(StartExercise(exercise));
        await Future<void>.delayed(const Duration(milliseconds: 20));
        bloc.add(PauseSession());
        await Future<void>.delayed(const Duration(milliseconds: 20));
        bloc.add(ResumeSession());
      },
      wait: const Duration(milliseconds: 120),
      verify: (bloc) {
        expect(bloc.state.currentExercise, exercise);
        expect(bloc.state.isRunning, isTrue);
      },
    );

    blocTest<PracticeSessionBloc, PracticeSessionState>(
      'completes exercise and clears the active slot',
      build: buildBloc,
      act: (bloc) async {
        bloc.add(LoadPracticeSession());
        await Future<void>.delayed(const Duration(milliseconds: 20));
        bloc.add(StartExercise(exercise));
        await Future<void>.delayed(const Duration(milliseconds: 20));
        bloc.add(const CompleteExercise(rating: 4));
      },
      wait: const Duration(milliseconds: 100),
      verify: (bloc) {
        expect(bloc.state.currentExercise, isNull);
        expect(bloc.state.completedExercises, hasLength(1));
        expect(bloc.state.completedExercises.first.rating, 4);
      },
    );
  });
}
