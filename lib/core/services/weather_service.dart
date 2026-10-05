import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:tava/features/practice_session/domain/entities/weather_info.dart';

@lazySingleton
class WeatherService {
  WeatherService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<WeatherInfo?> currentWeather({bool enabled = true}) async {
    if (!enabled) return null;

    final permission = await _ensurePermission();
    if (!permission) return null;

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.low,
        timeLimit: Duration(seconds: 8),
      ),
    );

    final uri = Uri.https('api.open-meteo.com', '/v1/forecast', {
      'latitude': '${position.latitude}',
      'longitude': '${position.longitude}',
      'current':
          'temperature_2m,relative_humidity_2m,surface_pressure,weather_code',
      'timezone': 'auto',
    });

    final response = await _client.get(uri).timeout(const Duration(seconds: 8));
    if (response.statusCode != 200) return null;

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final current = json['current'] as Map<String, dynamic>?;
    if (current == null) return null;

    return WeatherInfo(
      condition: _mapWeatherCode((current['weather_code'] as num?)?.toInt()),
      temperature: (current['temperature_2m'] as num?)?.toDouble() ?? 0,
      humidity: (current['relative_humidity_2m'] as num?)?.toInt() ?? 0,
      pressure: (current['surface_pressure'] as num?)?.toDouble() ?? 0,
      recordedAt: DateTime.now(),
    );
  }

  Future<bool> _ensurePermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return false;
    }
    return true;
  }

  WeatherCondition _mapWeatherCode(int? code) {
    if (code == null) return WeatherCondition.unknown;
    if (code == 0) return WeatherCondition.clear;
    if (code <= 3) return WeatherCondition.cloudy;
    if (code <= 48) return WeatherCondition.foggy;
    if (code <= 67 || (code >= 80 && code <= 82)) {
      return WeatherCondition.rainy;
    }
    if (code <= 77 || (code >= 85 && code <= 86)) {
      return WeatherCondition.snowy;
    }
    if (code >= 95) return WeatherCondition.stormy;
    return WeatherCondition.unknown;
  }
}
