import 'package:tava/core/utils/either.dart';
import 'package:tava/features/auth/domain/entities/tava_user.dart';

/// Repository interface for authentication operations.
abstract class AuthRepository {
  /// Tries to get the current authenticated user.
  FutureEitherResult<TavaUser> getCurrentUser();

  /// Tries to log in a user with the provided email and password.
  FutureEitherResult<TavaUser> login({
    required String email,
    required String password,
  });

  /// Tries to register a new user with the provided email, password, and name.
  FutureEitherResult<TavaUser> register({
    required String email,
    required String password,
    required String name,
  });

  /// Tries to log out the current user.
  FutureEitherUnit logout();
}
