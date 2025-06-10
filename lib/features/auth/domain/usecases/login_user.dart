import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:tava/core/usecase/usecase.dart';
import 'package:tava/core/utils/either.dart';
import 'package:tava/features/auth/domain/entities/user.dart';
import 'package:tava/features/auth/domain/repositories/auth_repository.dart';

class LoginParams extends Equatable {

  const LoginParams({
    required this.email,
    required this.password,
  });
  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];
}

@injectable
class LoginUser implements UseCase<User, LoginParams> {

  LoginUser(this.repository);
  final AuthRepository repository;

  @override
  FutureEitherResult<User> call(LoginParams params) {
    return repository.login(
      email: params.email,
      password: params.password,
    );
  }
}