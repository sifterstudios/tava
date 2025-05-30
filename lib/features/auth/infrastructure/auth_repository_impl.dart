import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import 'package:tava/core/error/failures.dart';
import 'package:tava/core/utils/either.dart';
import 'package:tava/features/auth/domain/entities/user.dart';
import 'package:tava/features/auth/domain/repositories/auth_repository.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final SupabaseClient _supabaseClient;

  AuthRepositoryImpl(this._supabaseClient);

  @override
  FutureEitherResult<User> getCurrentUser() async {
    try {
      final session = _supabaseClient.auth.currentSession;
      if (session == null) {
        return Left(AuthFailure('No active session found', message: 'hello'));
      }

      final userData = await _supabaseClient
          .from('users')
          .select()
          .eq('id', session.user.id)
          .single();

      return Right(
        User(
          id: userData['id'] as String,
          email: userData['email'] as String,
          name: userData['name'] as String,
        ),
      );
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  FutureEitherResult<User> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        return Left(const AuthFailure('Login failed'));
      }

      final userData = await _supabaseClient
          .from('users')
          .select()
          .eq('id', response.user!.id)
          .single();

      return Right(
        User(
          id: userData['id'] as String,
          email: userData['email'] as String,
          name: userData['name'] as String,
        ),
      );
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  FutureEitherResult<User> register({
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
        return Left(const AuthFailure('Registration failed'));
      }

      // Create user profile in the users table
      await _supabaseClient.from('users').insert({
        'id': response.user!.id,
        'email': email,
        'name': name,
      });

      return Right(
        User(
          id: response.user!.id,
          email: email,
          name: name,
        ),
      );
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  FutureEitherUnit logout() async {
    try {
      await _supabaseClient.auth.signOut();
      return const Right(unit);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }
}
