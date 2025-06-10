part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class LoadSettings extends SettingsEvent {}

class UpdateThemeMode extends SettingsEvent {

  const UpdateThemeMode(this.themeMode);
  final ThemeMode themeMode;

  @override
  List<Object> get props => [themeMode];
}

class UpdateMetronomeSound extends SettingsEvent {

  const UpdateMetronomeSound(this.sound);
  final String sound;

  @override
  List<Object> get props => [sound];
}

class UpdateWeatherTracking extends SettingsEvent {

  const UpdateWeatherTracking(this.trackWeather);
  final bool trackWeather;

  @override
  List<Object> get props => [trackWeather];
}