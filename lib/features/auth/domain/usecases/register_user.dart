import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:tava/core/usecase/usecase.dart';
import 'package:tava/core/utils/either.dart';
import 'package:tava/features/auth/domain/entities/tava_user.dart';
import 'package:tava/features/auth/domain/repositories/auth_repository.dart';

/// Parameters needed for registering a user.
class RegisterParams extends Equatable {
  /// Creates an instance of [RegisterParams].
  const RegisterParams({
    required this.email,
    required this.password,
    required this.name,
  });

  /// The email address of the user.
  final String email;

  /// The password for the user account.
  final String password;

  /// The name of the user.
  final String name;

  @override
  List<Object> get props => [email, password, name];
}

/// Use case for registering a new user in the application.
@injectable
class RegisterUser implements UseCase<TavaUser, RegisterParams> {
  /// Creates an instance of [RegisterUser] with the provided [repository].
  RegisterUser(this.repository);

  /// The repository responsible for user authentication operations.
  final AuthRepository repository;

  @override
  FutureEitherResult<TavaUser> call(RegisterParams params) {
    return repository.register(
      email: params.email,
      password: params.password,
      name: params.name,
    );
  }
}
