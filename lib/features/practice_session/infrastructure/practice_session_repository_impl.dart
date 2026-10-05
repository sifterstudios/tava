import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tava/core/cache/hive_cache.dart';
import 'package:tava/core/error/failures.dart';
import 'package:tava/core/utils/either.dart';
import 'package:tava/features/practice_session/domain/entities/exercise_record.dart';
import 'package:tava/features/practice_session/domain/entities/mood_metrics.dart';
import 'package:tava/features/practice_session/domain/entities/practice_session.dart';
import 'package:tava/features/practice_session/domain/entities/weather_info.dart';
import 'package:tava/features/practice_session/domain/repositories/practice_session_repository.dart';

@Environment('prod')
@LazySingleton(as: PracticeSessionRepository)
class PracticeSessionRepositoryImpl implements PracticeSessionRepository {
  PracticeSessionRepositoryImpl(this._client, this._cache);

  final SupabaseClient _client;
  final HiveCache _cache;

  @override
  FutureEitherResult<PracticeSession?> getActiveSession() async {
    try {
      final userId = _requireUserId();
      final rows = await _client
          .from('practice_sessions')
          .select()
          .eq('user_id', userId)
          .eq('is_active', true)
          .order('start_time', ascending: false)
          .limit(1);

      if ((rows as List).isEmpty) return const Right(null);
      return Right(_sessionFromRow(rows.first as Map<String, dynamic>));
    } on Object catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  FutureEitherResult<List<PracticeSession>> getRecentSessions({
    int limit = 10,
  }) async {
    try {
      final userId = _requireUserId();
      final rows = await _client
          .from('practice_sessions')
          .select()
          .eq('user_id', userId)
          .order('start_time', ascending: false)
          .limit(limit);

      final sessions = (rows as List)
          .map((row) => _sessionFromRow(row as Map<String, dynamic>))
          .toList();
      await _cache.putJson(
        'recent_sessions',
        sessions.map(_sessionToCache).toList(),
      );
      return Right(sessions);
    } on Object catch (e) {
      final cached = await _cache.getJson<List<PracticeSession>>(
        'recent_sessions',
        (decoded) => (decoded as List)
            .map((e) => _sessionFromCache(e as Map<String, dynamic>))
            .toList(),
      );
      if (cached != null) return Right(cached);
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  FutureEitherResult<PracticeSession> saveSession(
    PracticeSession session, {
    required List<ExerciseRecord> exercises,
  }) async {
    try {
      final userId = _requireUserId();
      final payload = {
        'id': session.id,
        'user_id': userId,
        'start_time': session.startTime.toIso8601String(),
        'end_time': session.endTime?.toIso8601String(),
        'duration_ms': session.duration.inMilliseconds,
        'is_active': session.isActive,
        'energy_level': session.moodMetrics?.energyLevel,
        'focus_level': session.moodMetrics?.focusLevel,
        'sleep_quality': session.moodMetrics?.sleepQuality,
        'had_alcohol': session.moodMetrics?.hadAlcohol,
        'mood_notes': session.moodMetrics?.notes,
        'weather_condition': session.weatherInfo?.condition.name,
        'weather_temperature': session.weatherInfo?.temperature,
        'weather_humidity': session.weatherInfo?.humidity,
        'weather_pressure': session.weatherInfo?.pressure,
        'weather_recorded_at':
            session.weatherInfo?.recordedAt.toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      final row = await _client
          .from('practice_sessions')
          .upsert(payload)
          .select()
          .single();

      await _client
          .from('exercise_records')
          .delete()
          .eq('session_id', session.id);
      if (exercises.isNotEmpty) {
        await _client.from('exercise_records').insert([
          for (final exercise in exercises)
            {
              'id': exercise.id,
              'session_id': session.id,
              'user_id': userId,
              'exercise_id': exercise.exerciseId,
              'name': exercise.name,
              'bpm': exercise.bpm,
              'duration_ms': exercise.duration.inMilliseconds,
              'rating': exercise.rating,
              'notes': exercise.notes,
            },
        ]);
      }

      // Upsert daily BPM sample from completed exercise tempos.
      final bpms = exercises.map((e) => e.bpm).whereType<int>().toList();
      if (bpms.isNotEmpty) {
        final avg = bpms.reduce((a, b) => a + b) / bpms.length;
        final day = DateTime.now().toIso8601String().substring(0, 10);
        await _client.from('bpm_samples').upsert({
          'user_id': userId,
          'recorded_on': day,
          'average_bpm': avg,
          'sample_count': bpms.length,
        });
      }

      return Right(_sessionFromRow(row));
    } on Object catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  String _requireUserId() {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw StateError('Not signed in');
    }
    return userId;
  }

  PracticeSession _sessionFromRow(Map<String, dynamic> row) {
    MoodMetrics? mood;
    if (row['energy_level'] != null) {
      mood = MoodMetrics(
        energyLevel: row['energy_level'] as int,
        focusLevel: row['focus_level'] as int? ?? 3,
        sleepQuality: row['sleep_quality'] as int? ?? 3,
        hadAlcohol: row['had_alcohol'] as bool? ?? false,
        notes: row['mood_notes'] as String?,
      );
    }

    WeatherInfo? weather;
    if (row['weather_condition'] != null) {
      weather = WeatherInfo(
        condition: WeatherCondition.values.firstWhere(
          (c) => c.name == row['weather_condition'],
          orElse: () => WeatherCondition.unknown,
        ),
        temperature: (row['weather_temperature'] as num?)?.toDouble() ?? 0,
        humidity: row['weather_humidity'] as int? ?? 0,
        pressure: (row['weather_pressure'] as num?)?.toDouble() ?? 0,
        recordedAt: row['weather_recorded_at'] == null
            ? DateTime.now()
            : DateTime.parse(row['weather_recorded_at'] as String),
      );
    }

    return PracticeSession(
      id: row['id'] as String,
      startTime: DateTime.parse(row['start_time'] as String),
      endTime: row['end_time'] == null
          ? null
          : DateTime.parse(row['end_time'] as String),
      duration: Duration(milliseconds: row['duration_ms'] as int? ?? 0),
      exercises: const [],
      moodMetrics: mood,
      weatherInfo: weather,
      isActive: row['is_active'] as bool? ?? false,
    );
  }

  Map<String, dynamic> _sessionToCache(PracticeSession s) => {
        'id': s.id,
        'start_time': s.startTime.toIso8601String(),
        'end_time': s.endTime?.toIso8601String(),
        'duration_ms': s.duration.inMilliseconds,
        'is_active': s.isActive,
        'energy_level': s.moodMetrics?.energyLevel,
        'focus_level': s.moodMetrics?.focusLevel,
        'sleep_quality': s.moodMetrics?.sleepQuality,
        'had_alcohol': s.moodMetrics?.hadAlcohol,
        'mood_notes': s.moodMetrics?.notes,
        'weather_condition': s.weatherInfo?.condition.name,
        'weather_temperature': s.weatherInfo?.temperature,
        'weather_humidity': s.weatherInfo?.humidity,
        'weather_pressure': s.weatherInfo?.pressure,
        'weather_recorded_at': s.weatherInfo?.recordedAt.toIso8601String(),
      };

  PracticeSession _sessionFromCache(Map<String, dynamic> row) =>
      _sessionFromRow(row);
}
