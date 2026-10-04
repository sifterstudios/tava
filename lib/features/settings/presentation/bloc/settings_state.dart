part of 'settings_bloc.dart';

enum SettingsStatus { initial, loading, success, failure }

class SettingsState extends Equatable {
  const SettingsState({
    required this.status,
    required this.themeMode,
    required this.metronomeSound,
    required this.trackWeather,
    this.errorMessage,
  });

  const SettingsState.initial()
      : status = SettingsStatus.initial,
        themeMode = ThemeMode.system,
        metronomeSound = 'click',
        trackWeather = true,
        errorMessage = null;

  static const Object _unset = Object();

  final SettingsStatus status;
  final ThemeMode themeMode;
  final String metronomeSound;
  final bool trackWeather;
  final String? errorMessage;

  SettingsState copyWith({
    SettingsStatus? status,
    ThemeMode? themeMode,
    String? metronomeSound,
    bool? trackWeather,
    Object? errorMessage = _unset,
  }) {
    return SettingsState(
      status: status ?? this.status,
      themeMode: themeMode ?? this.themeMode,
      metronomeSound: metronomeSound ?? this.metronomeSound,
      trackWeather: trackWeather ?? this.trackWeather,
      errorMessage: identical(errorMessage, _unset)
          ? this.errorMessage
          : errorMessage as String?,
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
