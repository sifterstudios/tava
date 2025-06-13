import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Module for registering dependencies in the application.
@module
abstract class RegisterModule {
  /// Provides a singleton instance of [SupabaseClient].
  @lazySingleton
  SupabaseClient get supabaseClient => Supabase.instance.client;

  /// Provides a singleton instance of [SharedPreferences].
  @preResolve
  @lazySingleton
  Future<SharedPreferences> get sharedPreferences =>
      SharedPreferences.getInstance();
}
