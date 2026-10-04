import 'package:injectable/injectable.dart';
import 'package:tava/core/usecase/usecase.dart';
import 'package:tava/core/utils/either.dart';
import 'package:tava/features/practice_session/domain/entities/practice_session.dart';
import 'package:tava/features/practice_session/domain/repositories/practice_session_repository.dart';

@injectable
class GetRecentSessions implements UseCase<List<PracticeSession>, NoParams> {
  GetRecentSessions(this.repository);
  final PracticeSessionRepository repository;

  @override
  FutureEitherResult<List<PracticeSession>> call([NoParams? params]) {
    return repository.getRecentSessions();
  }
}
