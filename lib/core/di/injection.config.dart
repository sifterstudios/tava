// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/domain/usecases/check_auth.dart' as _i1011;
import '../../features/auth/domain/usecases/login_user.dart' as _i778;
import '../../features/auth/domain/usecases/logout_user.dart' as _i419;
import '../../features/auth/domain/usecases/register_user.dart' as _i198;
import '../../features/auth/presentation/bloc/auth_bloc.dart' as _i797;
import '../../features/dashboard/presentiation/bloc/dashboard_bloc.dart'
    as _i835;
import '../../features/settings/domain/repositories/settings_repository.dart'
    as _i674;
import '../../features/settings/domain/usecases/get_settings.dart' as _i558;
import '../../features/settings/domain/usecases/update_settings.dart' as _i986;
import '../../features/settings/presentation/bloc/settings_bloc.dart' as _i585;

// initializes the registration of main-scope dependencies inside of GetIt
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
  gh.factory<_i835.DashboardBloc>(() => _i835.DashboardBloc(
        getActiveSession: gh<InvalidType>(),
        getRecentSessions: gh<InvalidType>(),
        getPracticeStats: gh<InvalidType>(),
      ));
  gh.factory<_i1011.CheckAuth>(
      () => _i1011.CheckAuth(gh<_i787.AuthRepository>()));
  gh.factory<_i778.LoginUser>(
      () => _i778.LoginUser(gh<_i787.AuthRepository>()));
  gh.factory<_i419.LogoutUser>(
      () => _i419.LogoutUser(gh<_i787.AuthRepository>()));
  gh.factory<_i198.RegisterUser>(
      () => _i198.RegisterUser(gh<_i787.AuthRepository>()));
  gh.factory<_i558.GetSettings>(
      () => _i558.GetSettings(gh<_i674.SettingsRepository>()));
  gh.factory<_i986.UpdateSettings>(
      () => _i986.UpdateSettings(gh<_i674.SettingsRepository>()));
  gh.factory<_i585.SettingsBloc>(() => _i585.SettingsBloc(
        getSettings: gh<_i558.GetSettings>(),
        updateSettings: gh<_i986.UpdateSettings>(),
      ));
  gh.factory<_i797.AuthBloc>(() => _i797.AuthBloc(
        checkAuth: gh<_i1011.CheckAuth>(),
        loginUser: gh<_i778.LoginUser>(),
        logoutUser: gh<_i419.LogoutUser>(),
        registerUser: gh<_i198.RegisterUser>(),
      ));
  return getIt;
}
