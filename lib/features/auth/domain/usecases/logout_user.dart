import 'package:injectable/injectable.dart';
import 'package:tava/core/usecase/usecase.dart';
import 'package:tava/core/utils/either.dart';
import 'package:tava/features/auth/domain/repositories/auth_repository.dart';

/// Use case for logging out a user.
@injectable
class LogoutUser implements UseCase<void, NoParams> {

  /// Creates an instance of [LogoutUser].
  LogoutUser(this.repository);
  /// The repository responsible for handling authentication operations.
  final AuthRepository repository;

  @override
  FutureEitherUnit call([NoParams? params]) {
    return repository.logout();
  }
}
