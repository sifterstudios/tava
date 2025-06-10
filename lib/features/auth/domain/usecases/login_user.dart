import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:tava/core/usecase/usecase.dart';
import 'package:tava/core/utils/either.dart';
import 'package:tava/features/auth/domain/entities/tava_user.dart';
import 'package:tava/features/auth/domain/repositories/auth_repository.dart';

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

@injectable
class LoginUser implements UseCase<TavaUser, LoginParams> {
  final AuthRepository repository;

  LoginUser(this.repository);

  @override
  FutureEitherResult<TavaUser> call(LoginParams params) {
    return repository.login(
      email: params.email,
      password: params.password,
    );
  }
}