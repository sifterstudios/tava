import 'package:injectable/injectable.dart';
import 'package:tava/core/usecase/usecase.dart';
import 'package:tava/core/utils/either.dart';
import 'package:tava/features/progress/domain/entities/practice_stats.dart';

abstract class ProgressRepository {
  FutureEitherResult<PracticeStats?> getPracticeStats();
}

@injectable
class GetPracticeStats implements UseCase<PracticeStats?, NoParams> {

  GetPracticeStats(this.repository);
  final ProgressRepository repository;

  @override
  FutureEitherResult<PracticeStats?> call([NoParams? params]) {
    return repository.getPracticeStats();
  }
}