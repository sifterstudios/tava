import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tava/core/cache/hive_cache.dart';
import 'package:tava/core/error/failures.dart';
import 'package:tava/core/utils/either.dart';
import 'package:tava/features/exercise_library/domain/entities/exercise.dart';
import 'package:tava/features/exercise_library/domain/repositories/exercise_repository.dart';

@Environment('prod')
@LazySingleton(as: ExerciseRepository)
class ExerciseRepositoryImpl implements ExerciseRepository {
  ExerciseRepositoryImpl(this._client, this._cache);

  final SupabaseClient _client;
  final HiveCache _cache;

  static const _cacheKey = 'exercises';

  @override
  FutureEitherResult<List<Exercise>> getExercises() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        return const Left(AuthFailure(message: 'Sign in to load exercises'));
      }

      final rows = await _client
          .from('exercises')
          .select()
          .eq('user_id', userId)
          .order('updated_at', ascending: false);

      final exercises = (rows as List<dynamic>)
          .map((row) => _fromRow(row as Map<String, dynamic>))
          .toList();

      await _cache.putJson(
        _cacheKey,
        exercises.map(_toCacheMap).toList(),
      );
      return Right(exercises);
    } on Object catch (e) {
      final cached = await _cache.getJson<List<Exercise>>(
        _cacheKey,
        (decoded) => (decoded as List<dynamic>)
            .map((e) => _fromCacheMap(e as Map<String, dynamic>))
            .toList(),
      );
      if (cached != null) return Right(cached);
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  FutureEitherResult<Exercise> upsertExercise(Exercise exercise) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        return const Left(AuthFailure(message: 'Sign in to save exercises'));
      }

      final payload = {
        'id': exercise.id,
        'user_id': userId,
        'name': exercise.name,
        'description': exercise.description,
        'category': exercise.category.name,
        'target_bpm': exercise.targetBpm,
        'target_duration_ms': exercise.targetDuration?.inMilliseconds,
        'source': exercise.source,
        'tags': exercise.tags,
        'is_favorite': exercise.isFavorite,
        'is_archived': exercise.isArchived,
        'updated_at': DateTime.now().toIso8601String(),
        'created_at': exercise.createdAt.toIso8601String(),
      };

      final row = await _client
          .from('exercises')
          .upsert(payload)
          .select()
          .single();

      final saved = _fromRow(row);
      await _refreshCache();
      return Right(saved);
    } on Object catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  FutureEitherUnit deleteExercise(String id) async {
    try {
      await _client.from('exercises').delete().eq('id', id);
      await _refreshCache();
      return right(unit);
    } on Object catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  FutureEitherResult<Exercise> toggleFavorite(Exercise exercise) {
    return upsertExercise(
      exercise.copyWith(isFavorite: !exercise.isFavorite),
    );
  }

  Future<void> _refreshCache() async {
    final result = await getExercises();
    result.fold((_) {}, (_) {});
  }

  Exercise _fromRow(Map<String, dynamic> row) {
    return Exercise(
      id: row['id'] as String,
      name: row['name'] as String,
      description: row['description'] as String?,
      category: ExerciseCategory.values.firstWhere(
        (c) => c.name == row['category'],
        orElse: () => ExerciseCategory.other,
      ),
      targetBpm: row['target_bpm'] as int?,
      targetDuration: row['target_duration_ms'] == null
          ? null
          : Duration(milliseconds: row['target_duration_ms'] as int),
      source: row['source'] as String?,
      tags: List<String>.from(row['tags'] as List? ?? const []),
      isFavorite: row['is_favorite'] as bool? ?? false,
      createdAt: DateTime.parse(row['created_at'] as String),
      updatedAt: DateTime.parse(row['updated_at'] as String),
      isArchived: row['is_archived'] as bool? ?? false,
    );
  }

  Map<String, dynamic> _toCacheMap(Exercise e) => {
        'id': e.id,
        'name': e.name,
        'description': e.description,
        'category': e.category.name,
        'target_bpm': e.targetBpm,
        'target_duration_ms': e.targetDuration?.inMilliseconds,
        'source': e.source,
        'tags': e.tags,
        'is_favorite': e.isFavorite,
        'created_at': e.createdAt.toIso8601String(),
        'updated_at': e.updatedAt.toIso8601String(),
        'is_archived': e.isArchived,
      };

  Exercise _fromCacheMap(Map<String, dynamic> row) => _fromRow(row);
}
