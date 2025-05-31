// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i5;
import 'package:supabase_flutter/supabase_flutter.dart' as _i6;

import '../../features/auth/domain/usecases/check_auth.dart' as _i9;
import '../../features/auth/domain/usecases/login_user.dart' as _i11;
import '../../features/auth/domain/usecases/logout_user.dart' as _i12;
import '../../features/auth/domain/usecases/register_user.dart' as _i13;
import '../../features/auth/infrastructure/mock_auth_repository.dart' as _i4;
import '../../features/auth/presentation/bloc/auth_bloc.dart' as _i14;
import '../../features/dashboard/presentation/bloc/dashboard_bloc.dart' as _i10;
import '../../features/exercise_library/presentation/bloc/exercise_library_bloc.dart'
    as _i3;
import '../../features/metronome/presentation/bloc/metronome_bloc.dart' as _i7;
import '../../features/practice_session/infrastructure/mock_practice_session_repository.dart'
    as _i8;
import '../../features/progress/infrastructure/mock_progress_repository.dart'
    as _i16;
import '../../features/settings/domain/usecases/get_settings.dart' as _i18;
import '../../features/settings/domain/usecases/update_settings.dart' as _i19;
import '../../features/settings/infrastructure/mock_settings_repository.dart'
    as _i17;
import '../../features/settings/presentation/bloc/settings_bloc.dart' as _i15;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i3.ExerciseLibraryBloc>(() => _i3.ExerciseLibraryBloc());
    gh.lazySingleton<_i4.MockAuthRepository>(() => _i4.MockAuthRepository());
    gh.factory<_i7.MetronomeBloc>(() => _i7.MetronomeBloc());
    gh.lazySingleton<_i8.MockPracticeSessionRepository>(
        () => _i8.MockPracticeSessionRepository());
    gh.factory<_i9.CheckAuth>(
        () => _i9.CheckAuth(gh<_i4.MockAuthRepository>()));
    gh.factory<_i10.DashboardBloc>(() => _i10.DashboardBloc());
    gh.factory<_i11.LoginUser>(
        () => _i11.LoginUser(gh<_i4.MockAuthRepository>()));
    gh.factory<_i12.LogoutUser>(
        () => _i12.LogoutUser(gh<_i4.MockAuthRepository>()));
    gh.factory<_i13.RegisterUser>(
        () => _i13.RegisterUser(gh<_i4.MockAuthRepository>()));
    gh.factory<_i14.AuthBloc>(() => _i14.AuthBloc(
          checkAuth: gh<_i9.CheckAuth>(),
          loginUser: gh<_i11.LoginUser>(),
          logoutUser: gh<_i12.LogoutUser>(),
          registerUser: gh<_i13.RegisterUser>(),
        ));
    gh.factory<_i15.SettingsBloc>(() => _i15.SettingsBloc(
          getSettings: gh<_i18.GetSettings>(),
          updateSettings: gh<_i19.UpdateSettings>(),
        ));
    gh.lazySingleton<_i16.MockProgressRepository>(
        () => _i16.MockProgressRepository());
    gh.lazySingleton<_i17.MockSettingsRepository>(
        () => _i17.MockSettingsRepository());
    gh.factory<_i18.GetSettings>(
        () => _i18.GetSettings(gh<_i17.MockSettingsRepository>()));
    gh.factory<_i19.UpdateSettings>(
        () => _i19.UpdateSettings(gh<_i17.MockSettingsRepository>()));
    return this;
  }
}