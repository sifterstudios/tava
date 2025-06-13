import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:tava/core/usecase/usecase.dart';
import 'package:tava/core/utils/either.dart';
import 'package:tava/features/auth/domain/entities/tava_user.dart';
import 'package:tava/features/auth/domain/repositories/auth_repository.dart';

/// Parameters needed for logging in a Tava user.
class LoginParams extends Equatable {
  /// Creates an instance of [LoginParams].
  const LoginParams({
    required this.email,
    required this.password,
  });

  /// The email address of the user.
  final String email;

  /// The password of the user.
  final String password;

  @override
  List<Object> get props => [email, password];
}

/// Use case for logging in a user with email and password.
@injectable
class LoginUser implements UseCase<TavaUser, LoginParams> {
  /// Creates an instance of [LoginUser] with the provided [repository].
  LoginUser(this.repository);

  /// The repository that handles authentication operations.
  final AuthRepository repository;

  @override
  FutureEitherResult<TavaUser> call(LoginParams params) {
    return repository.login(
      email: params.email,
      password: params.password,
    );
  }
}
