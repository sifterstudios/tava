import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:tava/core/usecase/usecase.dart';
import 'package:tava/core/utils/either.dart';
import 'package:tava/features/auth/domain/entities/user.dart';
import 'package:tava/features/auth/domain/repositories/auth_repository.dart';

class RegisterParams extends Equatable {

  const RegisterParams({
    required this.email,
    required this.password,
    required this.name,
  });
  final String email;
  final String password;
  final String name;

  @override
  List<Object> get props => [email, password, name];
}

@injectable
class RegisterUser implements UseCase<User, RegisterParams> {

  RegisterUser(this.repository);
  final AuthRepository repository;

  @override
  FutureEitherResult<User> call(RegisterParams params) {
    return repository.register(
      email: params.email,
      password: params.password,
      name: params.name,
    );
  }
}