import 'package:injectable/injectable.dart';
import 'package:tava/features/auth/domain/repositories/auth_repository.dart';
import 'package:tava/features/auth/infrastructure/mock_auth_repository.dart';
import 'package:tava/features/practice_session/domain/usecases/get_active_session.dart';
import 'package:tava/features/practice_session/infrastructure/mock_practice_session_repository.dart';
import 'package:tava/features/progress/domain/usecases/get_practice_stats.dart';
import 'package:tava/features/progress/infrastructure/mock_progress_repository.dart';
import 'package:tava/features/settings/domain/repositories/settings_repository.dart';
import 'package:tava/features/settings/infrastructure/mock_settings_repository.dart';

@module
abstract class RegisterModule {
  @dev
  @LazySingleton(as: AuthRepository)
  MockAuthRepository get mockAuthRepository => MockAuthRepository();
  
  @dev
  @LazySingleton(as: PracticeSessionRepository)
  MockPracticeSessionRepository get mockPracticeSessionRepository => 
      MockPracticeSessionRepository();
  
  @dev
  @LazySingleton(as: ProgressRepository)
  MockProgressRepository get mockProgressRepository => MockProgressRepository();
  
  @dev
  @LazySingleton(as: SettingsRepository)
  MockSettingsRepository get mockSettingsRepository => MockSettingsRepository();
}