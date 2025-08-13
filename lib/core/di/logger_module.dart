import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

@module
abstract class LoggerModule {
  @lazySingleton
  Logger get logger => Logger(
    printer: PrettyPrinter(
      errorMethodCount: 5, // Show 5 error methods
      lineLength: 80, // Line length for pretty printing
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );
}