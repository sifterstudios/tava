import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tava/core/di/injection.config.dart';
import 'package:tava/features/auth/domain/repositories/auth_repository.dart';
import 'package:tava/features/auth/infrastructure/mock_auth_repository.dart';

final getIt = GetIt.instance;

const dev = Environment('dev');
const prod = Environment('prod');

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: false,
)
Future<void> configureDependencies() async {
  // Register external dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);
  
  try {
    final supabaseClient = Supabase.instance.client;
    getIt.registerSingleton<SupabaseClient>(supabaseClient);
  } catch (e) {
    // Fallback if Supabase is not initialized
    print('Warning: Supabase client not available: $e');
  }
  
  // Register the mock auth repository for development
  getIt.registerLazySingleton<AuthRepository>(
    () => MockAuthRepository(),
    registerFor: {dev, Environment.test},
  );
  
  // Initialize generated dependencies
  init(getIt);
}

// Run the following command to generate injection code:
// flutter pub run build_runner build --delete-conflicting-outputs