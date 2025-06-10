import 'package:injectable/injectable.dart';
import 'package:tava/core/usecase/usecase.dart';
import 'package:tava/core/utils/either.dart';
import 'package:tava/features/auth/domain/entities/user.dart';
import 'package:tava/features/auth/domain/repositories/auth_repository.dart';

@injectable
class CheckAuth implements UseCase<User, NoParams> {

  CheckAuth(this.repository);
  final AuthRepository repository;

  @override
  FutureEitherResult<User> call([NoParams? params]) {
    return repository.getCurrentUser();
  }
}