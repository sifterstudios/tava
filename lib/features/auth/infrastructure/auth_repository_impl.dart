import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import 'package:tava/core/error/failures.dart';
import 'package:tava/core/utils/either.dart';
import 'package:tava/features/auth/domain/entities/tava_user.dart';
import 'package:tava/features/auth/domain/repositories/auth_repository.dart';

/// Implementation of [AuthRepository] using Supabase for authentication.
@prod
@Injectable()
class AuthRepositoryImpl implements AuthRepository {
  /// Creates an instance of [AuthRepositoryImpl].
  AuthRepositoryImpl(this._supabaseClient);

  final SupabaseClient _supabaseClient;

  @override
  FutureEitherResult<TavaUser> getCurrentUser() async {
    try {
      final session = _supabaseClient.auth.currentSession;
      if (session == null) {
        return const Left(AuthFailure(message: 'No active session found'));
      }

      // For now, just return a mock user
      return Right(
        TavaUser(
          id: session.user.id,
          email: session.user.email ?? 'user@example.com',
          name: 'Test User',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
    } on Exception catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }

  @override
  FutureEitherResult<TavaUser> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        return const Left(AuthFailure(message: 'Login failed'));
      }

      return Right(
        TavaUser(
          id: response.user!.id,
          email: email,
          name: 'Test User',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
    } on Exception catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }

  @override
  FutureEitherResult<TavaUser> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final response = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user == null) {
        return const Left(AuthFailure(message: 'Registration failed'));
      }

      return Right(
        TavaUser(
          id: response.user!.id,
          email: email,
          name: name,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
    } on Exception catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }

  @override
  FutureEitherUnit logout() async {
    try {
      await _supabaseClient.auth.signOut();
      return right(unit);
    } on Exception catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }
}
