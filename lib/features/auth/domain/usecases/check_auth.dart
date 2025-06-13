import 'package:injectable/injectable.dart';
import 'package:tava/core/usecase/usecase.dart';
import 'package:tava/core/utils/either.dart';
import 'package:tava/features/auth/domain/entities/tava_user.dart';
import 'package:tava/features/auth/domain/repositories/auth_repository.dart';

/// Use case for checking the current authentication status of the user.
@injectable
class CheckAuth implements UseCase<TavaUser, NoParams> {
  /// Checks the current authentication status of the user.
  CheckAuth(this.repository);

  /// An instance of [AuthRepository] to interact with authentication data.
  final AuthRepository repository;

  @override
  FutureEitherResult<TavaUser> call([NoParams? params]) {
    return repository.getCurrentUser();
  }
}
