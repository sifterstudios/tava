import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tava/core/di/injection.config.dart';

final getIt = GetIt.instance;
final logger = GetIt.instance<Logger>();

// Define environments
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
    logger.e('Supabase client not available: $e');
  }

  // Initialize generated dependencies
  init(getIt, environment: dev.name);
}
