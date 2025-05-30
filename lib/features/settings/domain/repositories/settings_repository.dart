import 'package:tava/core/utils/either.dart';
import 'package:tava/features/settings/domain/entities/app_settings.dart';

abstract class SettingsRepository {
  FutureEitherResult<AppSettings> getSettings();
  FutureEitherUnit updateSettings(AppSettings settings);
}