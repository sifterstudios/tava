import 'package:flutter/material.dart';

/// Represents the application settings.
class AppSettings {
  /// Creates an instance of [AppSettings].
  const AppSettings({
    required this.themeMode,
    required this.metronomeSound,
    required this.trackWeather,
  });

  /// The mode of the theme for the application.
  final ThemeMode themeMode;

  /// The sound used for the metronome.
  final String metronomeSound;

  /// Whether to track weather conditions.
  final bool trackWeather;

  /// Creates a copy of this [AppSettings] with the given fields
  /// replaced by the new values.
  AppSettings copyWith({
    ThemeMode? themeMode,
    String? metronomeSound,
    bool? trackWeather,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      metronomeSound: metronomeSound ?? this.metronomeSound,
      trackWeather: trackWeather ?? this.trackWeather,
    );
  }
}
