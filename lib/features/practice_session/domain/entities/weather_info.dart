import 'package:equatable/equatable.dart';

enum WeatherCondition {
  clear,
  cloudy,
  rainy,
  snowy,
  stormy,
  foggy,
  unknown,
}

class WeatherInfo extends Equatable {

  const WeatherInfo({
    required this.condition,
    required this.temperature,
    required this.humidity,
    required this.pressure,
    required this.recordedAt,
  });
  final WeatherCondition condition;
  final double temperature;
  final int humidity;
  final double pressure;
  final DateTime recordedAt;

  @override
  List<Object> get props => [
    condition,
    temperature,
    humidity,
    pressure,
    recordedAt,
  ];
}