import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tava/core/error/failures.dart';
import 'package:tava/core/utils/either.dart';
import 'package:tava/features/auth/domain/entities/user.dart' as domain;
import 'package:tava/features/auth/domain/repositories/auth_repository.dart';

@prod
@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._supabaseClient);
  final SupabaseClient _supabaseClient;

  @override
  FutureEitherResult<domain.User> getCurrentUser() async {
    try {
      final authUser = _supabaseClient.auth.currentUser;
      if (authUser == null) {
        return const Left(AuthFailure(message: 'No active session found'));
      }
      return Right(_mapUser(authUser));
    } on Object catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }

  @override
  FutureEitherResult<domain.User> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final authUser = response.user;
      if (authUser == null) {
        return const Left(AuthFailure(message: 'Login failed'));
      }
      return Right(_mapUser(authUser));
    } on Object catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }

  @override
  FutureEitherResult<domain.User> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final response = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );
      final authUser = response.user;
      if (authUser == null) {
        return const Left(AuthFailure(message: 'Registration failed'));
      }
      await _supabaseClient.from('profiles').upsert({
        'id': authUser.id,
        'email': email,
        'name': name,
        'updated_at': DateTime.now().toIso8601String(),
      });
      return Right(_mapUser(authUser, fallbackName: name));
    } on Object catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }

  @override
  FutureEitherUnit logout() async {
    try {
      await _supabaseClient.auth.signOut();
      return right(unit);
    } on Object catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }

  domain.User _mapUser(User authUser, {String? fallbackName}) {
    final meta = authUser.userMetadata ?? {};
    return domain.User(
      id: authUser.id,
      email: authUser.email ?? '',
      name: (meta['name'] as String?) ?? fallbackName,
      createdAt: DateTime.tryParse(authUser.createdAt) ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}
