import 'package:injectable/injectable.dart';
import 'package:tava/core/usecase/usecase.dart';
import 'package:tava/core/utils/either.dart';
import 'package:tava/features/auth/domain/entities/tava_user.dart';
import 'package:tava/features/auth/domain/repositories/auth_repository.dart';

@injectable
class CheckAuth implements UseCase<TavaUser, NoParams> {
  final AuthRepository repository;

  CheckAuth(this.repository);

  @override
  FutureEitherResult<TavaUser> call([NoParams? params]) {
    return repository.getCurrentUser();
  }
}