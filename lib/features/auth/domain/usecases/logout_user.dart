import 'package:injectable/injectable.dart';
import 'package:tava/core/usecase/usecase.dart';
import 'package:tava/core/utils/either.dart';
import 'package:tava/features/auth/domain/repositories/auth_repository.dart';

@injectable
class LogoutUser implements UseCase<void, NoParams> {

  LogoutUser(this.repository);
  final AuthRepository repository;

  @override
  FutureEitherUnit call([NoParams? params]) {
    return repository.logout();
  }
}