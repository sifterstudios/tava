import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:tava/core/utils/either.dart';
import 'package:tava/features/settings/domain/entities/app_settings.dart';
import 'package:tava/features/settings/domain/repositories/settings_repository.dart';
import 'package:fpdart/fpdart.dart';

@Environment('dev')
@LazySingleton(as: SettingsRepository)
class MockSettingsRepository implements SettingsRepository {
  // In-memory storage for settings
  ThemeMode _themeMode = ThemeMode.system;
  String _metronomeSound = 'click';
  bool _trackWeather = true;

  @override
  FutureEitherResult<AppSettings> getSettings() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    return Right(
      AppSettings(
        themeMode: _themeMode,
        metronomeSound: _metronomeSound,
        trackWeather: _trackWeather,
      ),
    );
  }

  @override
  FutureEitherUnit updateSettings(AppSettings settings) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    _themeMode = settings.themeMode;
    _metronomeSound = settings.metronomeSound;
    _trackWeather = settings.trackWeather;

    return right(unit);
  }
}
