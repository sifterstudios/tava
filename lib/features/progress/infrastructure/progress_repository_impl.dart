import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tava/core/cache/hive_cache.dart';
import 'package:tava/core/config/app_config.dart';
import 'package:tava/core/error/failures.dart';
import 'package:tava/core/utils/either.dart';
import 'package:tava/features/progress/domain/entities/practice_stats.dart';
import 'package:tava/features/progress/domain/usecases/get_practice_stats.dart';

@Environment('prod')
@LazySingleton(as: ProgressRepository)
class ProgressRepositoryImpl implements ProgressRepository {
  ProgressRepositoryImpl(this._client, this._cache);

  final SupabaseClient _client;
  final HiveCache _cache;

  @override
  FutureEitherResult<PracticeStats?> getPracticeStats() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        return const Left(AuthFailure(message: 'Sign in to view progress'));
      }

      final sessions = await _client
          .from('practice_sessions')
          .select()
          .eq('user_id', userId)
          .eq('is_active', false);

      final records = await _client
          .from('exercise_records')
          .select()
          .eq('user_id', userId);

      final bpmRows = await _client
          .from('bpm_samples')
          .select()
          .eq('user_id', userId)
          .order('recorded_on');

      final sessionList = sessions as List;
      final recordList = records as List;
      final bpmList = bpmRows as List;

      if (sessionList.isEmpty && recordList.isEmpty) {
        return const Right(null);
      }

      final totalMs = sessionList.fold<int>(
        0,
        (sum, row) => sum + ((row as Map)['duration_ms'] as int? ?? 0),
      );

      final timeByExercise = <String, Duration>{};
      final bpms = <int>[];
      for (final row in recordList) {
        final map = row as Map<String, dynamic>;
        final name = map['name'] as String? ?? 'Exercise';
        final duration = Duration(milliseconds: map['duration_ms'] as int? ?? 0);
        timeByExercise[name] = (timeByExercise[name] ?? Duration.zero) + duration;
        final bpm = map['bpm'] as int?;
        if (bpm != null) bpms.add(bpm);
      }

      final daily = <DailyPracticeTime>[
        for (final row in sessionList)
          DailyPracticeTime(
            date: DateTime.parse((row as Map)['start_time'] as String),
            duration: Duration(milliseconds: row['duration_ms'] as int? ?? 0),
          ),
      ]..sort((a, b) => a.date.compareTo(b.date));

      final avgBpm = bpms.isEmpty
          ? 0
          : (bpms.reduce((a, b) => a + b) / bpms.length).round();

      final realTrend = [
        for (final row in bpmList)
          BpmTrendPoint(
            date: DateTime.parse((row as Map)['recorded_on'] as String),
            averageBpm: (row['average_bpm'] as num).toDouble(),
          ),
      ];

      final stats = PracticeStats(
        totalPracticeTime: Duration(milliseconds: totalMs),
        totalSessions: sessionList.length,
        averageBpm: avgBpm,
        timeByCategory: const {},
        timeByExercise: timeByExercise,
        dailyPracticeTimes: daily,
        weeklyPracticeTimes: const [],
        // Real samples only in the chart series; seed is separate for preview.
        bpmTrend: realTrend.isEmpty ? seedBpmTrend() : realTrend,
      );

      await _cache.putJson('practice_stats', {
        'total_ms': totalMs,
        'sessions': sessionList.length,
        'avg_bpm': avgBpm,
      });

      return Right(stats);
    } on Object catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  /// Demo samples used only when the user has no real BPM trend yet.
  static List<BpmTrendPoint> seedBpmTrend() {
    if (!AppConfig.showSeededBpmTrend) return const [];
    final now = DateTime.now();
    return [
      for (var i = 13; i >= 0; i--)
        BpmTrendPoint(
          date: DateTime(now.year, now.month, now.day).subtract(Duration(days: i)),
          averageBpm: 84 + ((14 - i) * 0.7) + (i.isEven ? 1.5 : -1),
          isSeed: true,
        ),
    ];
  }
}
