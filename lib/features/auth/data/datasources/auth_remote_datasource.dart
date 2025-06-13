import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tava/core/error/failures.dart';
import 'package:tava/features/auth/data/models/user_model.dart';

/// Abstract class for remote data source handling authentication operations.
abstract class AuthRemoteDataSource {
  /// Retrieves the currently logged-in user.
  Future<UserModel> getCurrentUser();

  /// Logs in a user with the provided email and password.
  Future<UserModel> login({required String email, required String password});

  /// Registers a new user with the provided email, password, and name.
  Future<UserModel> register(
      {required String email, required String password, required String name});

  /// Logs out the currently logged-in user.
  Future<void> logout();
}

/// Implementation of [AuthRemoteDataSource] using Supabase for authentication.
@Injectable(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {

  /// Constructor for [AuthRemoteDataSourceImpl].
  AuthRemoteDataSourceImpl({required this.supabaseClient});
  /// Supabase client for interacting with the Supabase backend.
  final SupabaseClient supabaseClient;

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final user = supabaseClient.auth.currentUser;
      if (user == null) {
        throw AuthFailure(message: 'No user logged in');
      }

      return UserModel.fromSupabaseUser(user);
    } catch (e) {
      throw AuthFailure(message: e.toString());
    }
  }

  @override
  Future<UserModel> login(
      {required String email, required String password}) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw AuthFailure(message: 'Login failed');
      }

      return UserModel.fromSupabaseUser(response.user!);
    } on AuthException catch (e) {
      throw AuthFailure(message: e.message);
    } catch (e) {
      throw AuthFailure(message: e.toString());
    }
  }

  @override
  Future<UserModel> register(
      {required String email,
      required String password,
      required String name}) async {
    try {
      final response = await supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );

      if (response.user == null) {
        throw AuthFailure(message: 'Registration failed');
      }

      return UserModel.fromSupabaseUser(response.user!);
    } on AuthException catch (e) {
      throw AuthFailure(message: e.message);
    } catch (e) {
      throw AuthFailure(message: e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      await supabaseClient.auth.signOut();
    } on AuthException catch (e) {
      throw AuthFailure(message: e.message);
    } catch (e) {
      throw AuthFailure(message: e.toString());
    }
  }
}
