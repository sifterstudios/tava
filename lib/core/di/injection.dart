import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tava/core/di/injection.config.dart';

final GetIt getIt = GetIt.instance;

const dev = Environment('dev');
const prod = Environment('prod');

@InjectableInit(
  asExtension: false,
)
Future<void> configureDependencies({
  String environment = Environment.prod,
}) async {
  if (!getIt.isRegistered<SharedPreferences>()) {
    final sharedPreferences = await SharedPreferences.getInstance();
    getIt.registerSingleton<SharedPreferences>(sharedPreferences);
  }

  try {
    if (!getIt.isRegistered<SupabaseClient>()) {
      getIt.registerSingleton<SupabaseClient>(Supabase.instance.client);
    }
  } on Object catch (e) {
    debugPrint('Supabase client not available: $e');
  }

  init(getIt, environment: environment);
}
