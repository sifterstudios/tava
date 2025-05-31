// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../../features/auth/domain/repositories/auth_repository.dart' as _i3;
import '../../features/auth/domain/usecases/check_auth.dart' as _i4;
import '../../features/auth/domain/usecases/login_user.dart' as _i5;
import '../../features/auth/domain/usecases/logout_user.dart' as _i6;
import '../../features/auth/domain/usecases/register_user.dart' as _i7;
import '../../features/auth/presentation/bloc/auth_bloc.dart' as _i8;
import '../../features/dashboard/presentiation/bloc/dashboard_bloc.dart' as _i9;
import '../../features/settings/domain/repositories/settings_repository.dart' as _i10;
import '../../features/settings/domain/usecases/get_settings.dart' as _i11;
import '../../features/settings/domain/usecases/update_settings.dart' as _i12;
import '../../features/settings/presentation/bloc/settings_bloc.dart' as _i13;

// initializes the registration of main-scope dependencies inside of GetIt
_i1.GetIt init(
  _i1.GetIt getIt, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i2.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  gh.factory<_i9.DashboardBloc>(() => _i9.DashboardBloc());
  gh.factory<_i4.CheckAuth>(
      () => _i4.CheckAuth(gh<_i3.AuthRepository>()));
  gh.factory<_i5.LoginUser>(
      () => _i5.LoginUser(gh<_i3.AuthRepository>()));
  gh.factory<_i6.LogoutUser>(
      () => _i6.LogoutUser(gh<_i3.AuthRepository>()));
  gh.factory<_i7.RegisterUser>(
      () => _i7.RegisterUser(gh<_i3.AuthRepository>()));
  gh.factory<_i11.GetSettings>(
      () => _i11.GetSettings(gh<_i10.SettingsRepository>()));
  gh.factory<_i12.UpdateSettings>(
      () => _i12.UpdateSettings(gh<_i10.SettingsRepository>()));
  gh.factory<_i13.SettingsBloc>(() => _i13.SettingsBloc(
        getSettings: gh<_i11.GetSettings>(),
        updateSettings: gh<_i12.UpdateSettings>(),
      ));
  gh.factory<_i8.AuthBloc>(() => _i8.AuthBloc(
        checkAuth: gh<_i4.CheckAuth>(),
        loginUser: gh<_i5.LoginUser>(),
        logoutUser: gh<_i6.LogoutUser>(),
        registerUser: gh<_i7.RegisterUser>(),
      ));
  return getIt;
}