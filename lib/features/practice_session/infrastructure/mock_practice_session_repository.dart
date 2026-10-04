import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:tava/core/utils/either.dart';
import 'package:tava/features/practice_session/domain/entities/exercise_record.dart';
import 'package:tava/features/practice_session/domain/entities/practice_session.dart';
import 'package:tava/features/practice_session/domain/repositories/practice_session_repository.dart';

/// Offline/demo fallback when Supabase is unavailable.
@Environment('dev')
@LazySingleton(as: PracticeSessionRepository)
class MockPracticeSessionRepository implements PracticeSessionRepository {
  @override
  FutureEitherResult<PracticeSession?> getActiveSession() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return right(null);
  }

  @override
  FutureEitherResult<List<PracticeSession>> getRecentSessions({
    int limit = 10,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return right(const []);
  }

  @override
  FutureEitherResult<PracticeSession> saveSession(
    PracticeSession session, {
    required List<ExerciseRecord> exercises,
  }) async {
    return right(session.copyWith(exercises: exercises, isActive: false));
  }
}
