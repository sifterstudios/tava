import 'package:injectable/injectable.dart';
import 'package:tava/core/usecase/usecase.dart';
import 'package:tava/core/utils/either.dart';
import 'package:tava/features/practice_session/domain/entities/practice_session.dart';

abstract class PracticeSessionRepository {
  FutureEitherResult<PracticeSession?> getActiveSession();
}

@injectable
class GetActiveSession implements UseCase<PracticeSession?, NoParams> {
  final PracticeSessionRepository repository;

  GetActiveSession(this.repository);

  @override
  FutureEitherResult<PracticeSession?> call([NoParams? params]) {
    return repository.getActiveSession();
  }
}