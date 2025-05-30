import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:tava/core/di/injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: false,
)
void configureDependencies() => init(getIt);

// Run the following command to generate injection code:
// flutter pub run build_runner build --delete-conflicting-outputs