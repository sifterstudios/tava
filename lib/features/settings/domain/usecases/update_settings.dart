import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:tava/core/usecase/usecase.dart';
import 'package:tava/core/utils/either.dart';
import 'package:tava/features/settings/domain/entities/app_settings.dart';
import 'package:tava/features/settings/domain/repositories/settings_repository.dart';

class UpdateSettingsParams extends Equatable {
  final AppSettings settings;

  const UpdateSettingsParams({required this.settings});

  @override
  List<Object> get props => [settings];
}

@injectable
class UpdateSettings implements UseCase<void, UpdateSettingsParams> {
  final SettingsRepository repository;

  UpdateSettings(this.repository);

  @override
  FutureEitherUnit call(UpdateSettingsParams params) {
    return repository.updateSettings(params.settings);
  }
}