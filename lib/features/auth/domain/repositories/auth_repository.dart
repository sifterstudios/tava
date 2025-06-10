import 'package:tava/core/utils/either.dart';
import 'package:tava/features/auth/domain/entities/tava_user.dart';

abstract class AuthRepository {
  FutureEitherResult<TavaUser> getCurrentUser();
  
  FutureEitherResult<TavaUser> login({
    required String email,
    required String password,
  });
  
  FutureEitherResult<TavaUser> register({
    required String email,
    required String password,
    required String name,
  });
  
  FutureEitherUnit logout();
}