import 'package:flutter/material.dart';

class AppSettings {
  final ThemeMode themeMode;
  final String metronomeSound;
  final bool trackWeather;

  const AppSettings({
    required this.themeMode,
    required this.metronomeSound,
    required this.trackWeather,
  });

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