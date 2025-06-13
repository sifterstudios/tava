import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:tava/core/di/injection.config.dart';

/// The global instance of GetIt for dependency injection.
final GetIt getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
/// Initializes the dependencies for the application.
Future<void> configureDependencies(String env) async =>
    getIt.init(environment: env);
