import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tava/core/di/injection.config.dart';
import 'package:tava/features/auth/domain/repositories/auth_repository.dart';
import 'package:tava/features/auth/infrastructure/mock_auth_repository.dart';
import 'package:tava/features/practice_session/domain/usecases/get_active_session.dart';
import 'package:tava/features/practice_session/infrastructure/mock_practice_session_repository.dart';
import 'package:tava/features/progress/domain/usecases/get_practice_stats.dart';
import 'package:tava/features/progress/infrastructure/mock_progress_repository.dart';
import 'package:tava/features/settings/domain/repositories/settings_repository.dart';
import 'package:tava/features/settings/infrastructure/mock_settings_repository.dart';

final getIt = GetIt.instance;

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
  
  // Register repositories
  getIt.registerLazySingleton<AuthRepository>((
    () => MockAuthRepository()
  ));
  
  getIt.registerLazySingleton<PracticeSessionRepository>((
    () => MockPracticeSessionRepository()
  ));
  
  getIt.registerLazySingleton<ProgressRepository>((
    () => MockProgressRepository()
  ));
  
  getIt.registerLazySingleton<SettingsRepository>((
    () => MockSettingsRepository()
  ));
  
  // Initialize generated dependencies
  init(getIt);
}

// Run the following command to generate injection code:
// flutter pub run build_runner build --delete-conflicting-outputs