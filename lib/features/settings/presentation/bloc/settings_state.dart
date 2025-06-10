part of 'settings_bloc.dart';

enum SettingsStatus { initial, loading, success, failure }

class SettingsState extends Equatable {
  final SettingsStatus status;
  final ThemeMode themeMode;
  final String metronomeSound;
  final bool trackWeather;
  final String? errorMessage;

  const SettingsState({
    required this.status,
    required this.themeMode,
    required this.metronomeSound,
    required this.trackWeather,
    this.errorMessage,
  });

  const SettingsState.initial()
      : status = SettingsStatus.initial,
        themeMode = ThemeMode.dark,
        metronomeSound = 'click',
        trackWeather = true,
        errorMessage = null;

  SettingsState copyWith({
    SettingsStatus? status,
    ThemeMode? themeMode,
    String? metronomeSound,
    bool? trackWeather,
    String? errorMessage,
  }) {
    return SettingsState(
      status: status ?? this.status,
      themeMode: themeMode ?? this.themeMode,
      metronomeSound: metronomeSound ?? this.metronomeSound,
      trackWeather: trackWeather ?? this.trackWeather,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        themeMode,
        metronomeSound,
        trackWeather,
        errorMessage,
      ];
}