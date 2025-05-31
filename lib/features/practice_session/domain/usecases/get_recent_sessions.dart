import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:tava/core/usecase/usecase.dart';
import 'package:tava/core/utils/either.dart';
import 'package:tava/features/practice_session/domain/entities/practice_session.dart';
import 'package:tava/features/practice_session/domain/usecases/get_active_session.dart';

@injectable
class GetRecentSessions implements UseCase<List<PracticeSession>, NoParams> {
  final PracticeSessionRepository repository;

  GetRecentSessions(this.repository);

  @override
  FutureEitherResult<List<PracticeSession>> call([NoParams? params]) async {
    // This would normally call a repository method, but for now we'll return mock data
    return right([]); // Using right from fpdart
  }
}