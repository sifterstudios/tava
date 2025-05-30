import 'package:injectable/injectable.dart';
import 'package:tava/core/usecase/usecase.dart';
import 'package:tava/core/utils/either.dart';
import 'package:tava/features/settings/domain/entities/app_settings.dart';
import 'package:tava/features/settings/domain/repositories/settings_repository.dart';

@injectable
class GetSettings implements UseCase<AppSettings, NoParams> {
  final SettingsRepository repository;

  GetSettings(this.repository);

  @override
  FutureEitherResult<AppSettings> call([NoParams? params]) {
    return repository.getSettings();
  }
}