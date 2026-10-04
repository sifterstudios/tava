import 'package:tava/core/utils/either.dart';
import 'package:tava/features/practice_session/domain/entities/exercise_record.dart';
import 'package:tava/features/practice_session/domain/entities/practice_session.dart';

abstract class PracticeSessionRepository {
  FutureEitherResult<PracticeSession?> getActiveSession();
  FutureEitherResult<List<PracticeSession>> getRecentSessions({int limit = 10});
  FutureEitherResult<PracticeSession> saveSession(
    PracticeSession session, {
    required List<ExerciseRecord> exercises,
  });
}
