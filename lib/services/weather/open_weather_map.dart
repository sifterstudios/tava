import 'dart:convert';
import 'dart:ffi';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  final String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  double _latitude = 0.0;
  double _longitude = 0.0;
  final query = {
    'appid': '8e2c4632c3593162ea0ccadb42f462e5',
    'lat': 'metric',
    'lon': 'en',
    'units': 'metric',
  };

  Future<Map<String, Object>> getWeatherData() async {
    final permission = await _handlePermission();
    final position = await _getCurrentPosition();
    final weather = await getWeather(_latitude, _longitude);
    final json = jsonDecode(weather);
    final test = WeatherResponse.fromJson(json);
    final dataList = {
      'name': test.name,
      'icon': test.icon,
      'temp': test.temperature
    };
    return dataList;
  }

  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.

      return false;
    }

    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.

        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.

      return false;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return true;
  }

  Future<String> getWeather(double latitude, double longitude) async {
    final uri = Uri.https(_baseUrl, '', query);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handlePermission();

    if (!hasPermission) {
      return;
    }

    final position = await _geolocatorPlatform.getCurrentPosition();
    _latitude = position.latitude;
    _longitude = position.longitude;
  }
}

class WeatherResponse {
  final String name;
  final String icon;
  final double temperature;

  WeatherResponse({
    required this.name,
    required this.icon,
    required this.temperature,
  });

  factory WeatherResponse.fromJson(Map<String, dynamic> json) {
    return WeatherResponse(
      name: json['name'],
      icon: json['weather'][0]['icon'],
      temperature: json['main']['temp'],
    );
  }
}
