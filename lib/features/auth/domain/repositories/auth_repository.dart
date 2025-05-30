import 'package:tava/core/utils/either.dart';
import 'package:tava/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  FutureEitherResult<User> getCurrentUser();

  FutureEitherResult<User> login({
    required String email,
    required String password,
  });

  FutureEitherResult<User> register({
    required String email,
    required String password,
    required String name,
  });

  FutureEitherUnit logout();
}