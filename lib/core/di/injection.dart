import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:tava/core/di/injection.config.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init', 
  preferRelativeImports: true, 
  asExtension: true,
)
Future<void> configureDependencies(String env) async => await getIt.init(environment: env);