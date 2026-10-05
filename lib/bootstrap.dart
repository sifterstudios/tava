import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tava/core/config/app_config.dart';
import 'package:tava/core/di/injection.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    if (kDebugMode) {
      log('onChange(${bloc.runtimeType}, $change)');
    }
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap(
  FutureOr<Widget> Function() builder, {
  String environment = Environment.prod,
}) async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  if (AppConfig.supabaseAnonKey.startsWith('eyJ')) {
    debugPrint(
      'Warning: SUPABASE_ANON_KEY is a legacy JWT. This project disabled '
      'legacy API keys — use sb_publishable_... in dart_defines.json '
      'and rebuild.',
    );
  } else if (!AppConfig.hasSupabaseConfig) {
    debugPrint(
      'Warning: SUPABASE_ANON_KEY missing or invalid. Pass '
      '--dart-define-from-file=dart_defines.json '
      '(see dart_defines.example.json).',
    );
  }

  try {
    await Supabase.initialize(
      url: AppConfig.supabaseUrl,
      publishableKey: AppConfig.supabaseAnonKey,
    );
  } on Object catch (e, stackTrace) {
    debugPrint('Warning: Failed to initialize Supabase: $e\n$stackTrace');
  }

  await configureDependencies(environment: environment);

  Bloc.observer = const AppBlocObserver();

  runApp(await builder());
}
