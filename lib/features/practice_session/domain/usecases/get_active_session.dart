import 'package:injectable/injectable.dart';
import 'package:tava/core/usecase/usecase.dart';
import 'package:tava/core/utils/either.dart';
import 'package:tava/features/practice_session/domain/entities/practice_session.dart';
import 'package:tava/features/practice_session/domain/repositories/practice_session_repository.dart';

@injectable
class GetActiveSession implements UseCase<PracticeSession?, NoParams> {
  GetActiveSession(this.repository);
  final PracticeSessionRepository repository;

  @override
  FutureEitherResult<PracticeSession?> call([NoParams? params]) {
    return repository.getActiveSession();
  }
}
