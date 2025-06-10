import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:tava/core/usecase/usecase.dart';
import 'package:tava/core/utils/either.dart';
import 'package:tava/features/settings/domain/entities/app_settings.dart';
import 'package:tava/features/settings/domain/repositories/settings_repository.dart';

class UpdateSettingsParams extends Equatable {

  const UpdateSettingsParams({required this.settings});
  final AppSettings settings;

  @override
  List<Object> get props => [settings];
}

@injectable
class UpdateSettings implements UseCase<void, UpdateSettingsParams> {

  UpdateSettings(this.repository);
  final SettingsRepository repository;

  @override
  FutureEitherUnit call(UpdateSettingsParams params) {
    return repository.updateSettings(params.settings);
  }
}