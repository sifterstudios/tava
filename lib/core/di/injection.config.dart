// Hand-maintained DI graph.

// ignore_for_file: type=lint
// coverage:ignore-file

import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:logger/logger.dart' as _i974;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as _i454;

import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/domain/usecases/check_auth.dart' as _i1011;
import '../../features/auth/domain/usecases/login_user.dart' as _i778;
import '../../features/auth/domain/usecases/logout_user.dart' as _i419;
import '../../features/auth/domain/usecases/register_user.dart' as _i198;
import '../../features/auth/infrastructure/auth_repository_impl.dart' as _i420;
import '../../features/auth/infrastructure/mock_auth_repository.dart' as _i560;
import '../../features/auth/presentation/bloc/auth_bloc.dart' as _i797;
import '../../features/dashboard/presentation/bloc/dashboard_bloc.dart'
    as _i652;
import '../../features/exercise_library/domain/repositories/exercise_repository.dart'
    as _i901;
import '../../features/exercise_library/infrastructure/exercise_repository_impl.dart'
    as _i902;
import '../../features/exercise_library/infrastructure/mock_exercise_repository.dart'
    as _i903;
import '../../features/exercise_library/presentation/bloc/exercise_library_bloc.dart'
    as _i804;
import '../../features/metronome/presentation/bloc/metronome_bloc.dart'
    as _i544;
import '../../features/practice_session/domain/repositories/practice_session_repository.dart'
    as _i880;
import '../../features/practice_session/domain/usecases/get_active_session.dart'
    as _i879;
import '../../features/practice_session/domain/usecases/get_recent_sessions.dart'
    as _i760;
import '../../features/practice_session/infrastructure/mock_practice_session_repository.dart'
    as _i341;
import '../../features/practice_session/infrastructure/practice_session_repository_impl.dart'
    as _i342;
import '../../features/practice_session/presentation/bloc/practice_session_bloc.dart'
    as _i1021;
import '../../features/progress/domain/usecases/get_practice_stats.dart'
    as _i1058;
import '../../features/progress/infrastructure/mock_progress_repository.dart'
    as _i251;
import '../../features/progress/infrastructure/progress_repository_impl.dart'
    as _i252;
import '../../features/progress/presentation/bloc/progress_bloc.dart' as _i522;
import '../../features/settings/domain/repositories/settings_repository.dart';
import '../../features/settings/domain/usecases/get_settings.dart';
import '../../features/settings/domain/usecases/update_settings.dart';
import '../../features/settings/infrastructure/mock_settings_repository.dart';
import '../../features/settings/infrastructure/settings_repository_impl.dart';
import '../../features/settings/presentation/bloc/settings_bloc.dart';
import '../cache/hive_cache.dart' as _i700;
import '../services/metronome_audio_service.dart' as _i701;
import '../services/weather_service.dart' as _i702;
import 'logger_module.dart' as _i987;

const String _prod = 'prod';
const String _dev = 'dev';

_i174.GetIt init(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  final loggerModule = _$LoggerModule();

  gh.lazySingleton<_i974.Logger>(() => loggerModule.logger);
  gh.lazySingleton<_i700.HiveCache>(() => _i700.HiveCache());
  gh.lazySingleton<_i701.MetronomeAudioService>(
    () => _i701.MetronomeAudioService(),
  );
  gh.lazySingleton<_i702.WeatherService>(() => _i702.WeatherService());

  gh.factory<_i652.DashboardBloc>(() => _i652.DashboardBloc());
  gh.factory<_i544.MetronomeBloc>(
    () => _i544.MetronomeBloc(gh<_i701.MetronomeAudioService>()),
  );

  gh.lazySingleton<_i787.AuthRepository>(
    () => _i420.AuthRepositoryImpl(gh<_i454.SupabaseClient>()),
    registerFor: {_prod},
  );
  gh.lazySingleton<_i787.AuthRepository>(
    () => _i560.MockAuthRepository(),
    registerFor: {_dev},
  );

  gh.lazySingleton<_i880.PracticeSessionRepository>(
    () => _i342.PracticeSessionRepositoryImpl(
      gh<_i454.SupabaseClient>(),
      gh<_i700.HiveCache>(),
    ),
    registerFor: {_prod},
  );
  gh.lazySingleton<_i880.PracticeSessionRepository>(
    () => _i341.MockPracticeSessionRepository(),
    registerFor: {_dev},
  );

  gh.lazySingleton<_i1058.ProgressRepository>(
    () => _i252.ProgressRepositoryImpl(
      gh<_i454.SupabaseClient>(),
      gh<_i700.HiveCache>(),
    ),
    registerFor: {_prod},
  );
  gh.lazySingleton<_i1058.ProgressRepository>(
    () => _i251.MockProgressRepository(),
    registerFor: {_dev},
  );

  gh.lazySingleton<_i901.ExerciseRepository>(
    () => _i902.ExerciseRepositoryImpl(
      gh<_i454.SupabaseClient>(),
      gh<_i700.HiveCache>(),
    ),
    registerFor: {_prod},
  );
  gh.lazySingleton<_i901.ExerciseRepository>(
    () => _i903.MockExerciseRepository(),
    registerFor: {_dev},
  );

  gh.lazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(gh<SharedPreferences>()),
    registerFor: {_prod},
  );
  gh.lazySingleton<SettingsRepository>(
    () => MockSettingsRepository(),
    registerFor: {_dev},
  );

  gh.factory<_i419.LogoutUser>(
    () => _i419.LogoutUser(gh<_i787.AuthRepository>()),
  );
  gh.factory<_i198.RegisterUser>(
    () => _i198.RegisterUser(gh<_i787.AuthRepository>()),
  );
  gh.factory<_i1011.CheckAuth>(
    () => _i1011.CheckAuth(gh<_i787.AuthRepository>()),
  );
  gh.factory<_i778.LoginUser>(
    () => _i778.LoginUser(gh<_i787.AuthRepository>()),
  );
  gh.factory<_i760.GetRecentSessions>(
    () => _i760.GetRecentSessions(gh<_i880.PracticeSessionRepository>()),
  );
  gh.factory<_i879.GetActiveSession>(
    () => _i879.GetActiveSession(gh<_i880.PracticeSessionRepository>()),
  );
  gh.factory<GetSettings>(() => GetSettings(gh<SettingsRepository>()));
  gh.factory<UpdateSettings>(() => UpdateSettings(gh<SettingsRepository>()));
  gh.factory<_i1058.GetPracticeStats>(
    () => _i1058.GetPracticeStats(gh<_i1058.ProgressRepository>()),
  );

  gh.lazySingleton<_i797.AuthBloc>(
    () => _i797.AuthBloc(
      checkAuth: gh<_i1011.CheckAuth>(),
      loginUser: gh<_i778.LoginUser>(),
      logoutUser: gh<_i419.LogoutUser>(),
      registerUser: gh<_i198.RegisterUser>(),
    ),
  );
  gh.lazySingleton<SettingsBloc>(
    () => SettingsBloc(
      getSettings: gh<GetSettings>(),
      updateSettings: gh<UpdateSettings>(),
    ),
  );

  gh.factory<_i804.ExerciseLibraryBloc>(
    () => _i804.ExerciseLibraryBloc(gh<_i901.ExerciseRepository>()),
  );
  gh.factory<_i1021.PracticeSessionBloc>(
    () => _i1021.PracticeSessionBloc(
      gh<_i880.PracticeSessionRepository>(),
      gh<_i702.WeatherService>(),
      gh<SettingsBloc>(),
    ),
  );
  gh.factory<_i522.ProgressBloc>(
    () => _i522.ProgressBloc(
      getPracticeStats: gh<_i1058.GetPracticeStats>(),
    ),
  );

  return getIt;
}

class _$LoggerModule extends _i987.LoggerModule {}
