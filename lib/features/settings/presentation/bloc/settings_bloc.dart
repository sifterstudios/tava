import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:tava/features/settings/domain/entities/app_settings.dart';
import 'package:tava/features/settings/domain/usecases/get_settings.dart';
import 'package:tava/features/settings/domain/usecases/update_settings.dart';

part 'settings_event.dart';
part 'settings_state.dart';

@injectable
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final GetSettings _getSettings;
  final UpdateSettings _updateSettings;

  SettingsBloc({
    required GetSettings getSettings,
    required UpdateSettings updateSettings,
  })  : _getSettings = getSettings,
        _updateSettings = updateSettings,
        super(const SettingsState.initial()) {
    on<LoadSettings>(_onLoadSettings);
    on<UpdateThemeMode>(_onUpdateThemeMode);
    on<UpdateMetronomeSound>(_onUpdateMetronomeSound);
    on<UpdateWeatherTracking>(_onUpdateWeatherTracking);
  }

  Future<void> _onLoadSettings(
      LoadSettings event,
      Emitter<SettingsState> emit,
      ) async {
    emit(state.copyWith(status: SettingsStatus.loading));

    final result = await _getSettings();

    result.fold(
          (failure) => emit(state.copyWith(
        status: SettingsStatus.failure,
        errorMessage: failure.message,
      )),
          (settings) => emit(state.copyWith(
        status: SettingsStatus.success,
        themeMode: settings.themeMode,
        metronomeSound: settings.metronomeSound,
        trackWeather: settings.trackWeather,
      )),
    );
  }

  Future<void> _onUpdateThemeMode(
      UpdateThemeMode event,
      Emitter<SettingsState> emit,
      ) async {
    final updatedSettings = AppSettings(
      themeMode: event.themeMode,
      metronomeSound: state.metronomeSound,
      trackWeather: state.trackWeather,
    );

    final result = await _updateSettings(
      UpdateSettingsParams(settings: updatedSettings),
    );

    result.fold(
          (failure) => emit(state.copyWith(
        status: SettingsStatus.failure,
        errorMessage: failure.message,
      )),
          (_) => emit(state.copyWith(
        status: SettingsStatus.success,
        themeMode: event.themeMode,
      )),
    );
  }

  Future<void> _onUpdateMetronomeSound(
      UpdateMetronomeSound event,
      Emitter<SettingsState> emit,
      ) async {
    final updatedSettings = AppSettings(
      themeMode: state.themeMode,
      metronomeSound: event.sound,
      trackWeather: state.trackWeather,
    );

    final result = await _updateSettings(
      UpdateSettingsParams(settings: updatedSettings),
    );

    result.fold(
          (failure) => emit(state.copyWith(
        status: SettingsStatus.failure,
        errorMessage: failure.message,
      )),
          (_) => emit(state.copyWith(
        status: SettingsStatus.success,
        metronomeSound: event.sound,
      )),
    );
  }

  Future<void> _onUpdateWeatherTracking(
      UpdateWeatherTracking event,
      Emitter<SettingsState> emit,
      ) async {
    final updatedSettings = AppSettings(
      themeMode: state.themeMode,
      metronomeSound: state.metronomeSound,
      trackWeather: event.trackWeather,
    );

    final result = await _updateSettings(
      UpdateSettingsParams(settings: updatedSettings),
    );

    result.fold(
          (failure) => emit(state.copyWith(
        status: SettingsStatus.failure,
        errorMessage: failure.message,
      )),
          (_) => emit(state.copyWith(
        status: SettingsStatus.success,
        trackWeather: event.trackWeather,
      )),
    );
  }
}