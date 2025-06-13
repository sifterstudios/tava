import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tava/core/error/failures.dart';
import 'package:tava/core/utils/either.dart';
import 'package:tava/features/settings/domain/entities/app_settings.dart';
import 'package:tava/features/settings/domain/repositories/settings_repository.dart';

@Environment('prod')
@Injectable(as: SettingsRepository)
class SettingsRepositoryImpl implements SettingsRepository {
  final SharedPreferences _sharedPreferences;

  SettingsRepositoryImpl(this._sharedPreferences);

  @override
  FutureEitherResult<AppSettings> getSettings() async {
    try {
      final themeMode = _getThemeMode();
      final metronomeSound = _getMetronomeSound();
      final trackWeather = _getTrackWeather();

      return Right(
        AppSettings(
          themeMode: themeMode,
          metronomeSound: metronomeSound,
          trackWeather: trackWeather,
        ),
      );
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  FutureEitherUnit updateSettings(AppSettings settings) async {
    try {
      await _saveThemeMode(settings.themeMode);
      await _saveMetronomeSound(settings.metronomeSound);
      await _saveTrackWeather(settings.trackWeather);

      return right(unit);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  ThemeMode _getThemeMode() {
    final themeModeIndex = _sharedPreferences.getInt('themeMode') ?? 0;
    return ThemeMode.values[themeModeIndex];
  }

  Future<void> _saveThemeMode(ThemeMode themeMode) async {
    await _sharedPreferences.setInt('themeMode', themeMode.index);
  }

  String _getMetronomeSound() {
    return _sharedPreferences.getString('metronomeSound') ?? 'click';
  }

  Future<void> _saveMetronomeSound(String sound) async {
    await _sharedPreferences.setString('metronomeSound', sound);
  }

  bool _getTrackWeather() {
    return _sharedPreferences.getBool('trackWeather') ?? true;
  }

  Future<void> _saveTrackWeather(bool trackWeather) async {
    await _sharedPreferences.setBool('trackWeather', trackWeather);
  }
}