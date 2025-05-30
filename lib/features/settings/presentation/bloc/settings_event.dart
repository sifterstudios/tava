part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class LoadSettings extends SettingsEvent {}

class UpdateThemeMode extends SettingsEvent {
  final ThemeMode themeMode;

  const UpdateThemeMode(this.themeMode);

  @override
  List<Object> get props => [themeMode];
}

class UpdateMetronomeSound extends SettingsEvent {
  final String sound;

  const UpdateMetronomeSound(this.sound);

  @override
  List<Object> get props => [sound];
}

class UpdateWeatherTracking extends SettingsEvent {
  final bool trackWeather;

  const UpdateWeatherTracking(this.trackWeather);

  @override
  List<Object> get props => [trackWeather];
}