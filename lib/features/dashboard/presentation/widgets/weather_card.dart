import 'package:flutter/material.dart';
import 'package:tava/features/practice_session/domain/entities/weather_info.dart';

class WeatherCard extends StatelessWidget {

  const WeatherCard({required this.weatherInfo, super.key});
  final WeatherInfo weatherInfo;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              _getWeatherIcon(weatherInfo.condition),
              size: 48,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Weather during last practice',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${weatherInfo.temperature.toStringAsFixed(1)}°C, ${_getWeatherConditionName(weatherInfo.condition)}',
                    style: theme.textTheme.bodyMedium,
                  ),
                  Text(
                    'Humidity: ${weatherInfo.humidity}%, Pressure: ${weatherInfo.pressure.toStringAsFixed(0)} hPa',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getWeatherIcon(WeatherCondition condition) {
    switch (condition) {
      case WeatherCondition.clear:
        return Icons.wb_sunny;
      case WeatherCondition.cloudy:
        return Icons.cloud;
      case WeatherCondition.rainy:
        return Icons.water_drop;
      case WeatherCondition.snowy:
        return Icons.ac_unit;
      case WeatherCondition.stormy:
        return Icons.thunderstorm;
      case WeatherCondition.foggy:
        return Icons.cloud_queue;
      case WeatherCondition.unknown:
        return Icons.question_mark;
    }
  }

  String _getWeatherConditionName(WeatherCondition condition) {
    switch (condition) {
      case WeatherCondition.clear:
        return 'Clear';
      case WeatherCondition.cloudy:
        return 'Cloudy';
      case WeatherCondition.rainy:
        return 'Rainy';
      case WeatherCondition.snowy:
        return 'Snowy';
      case WeatherCondition.stormy:
        return 'Stormy';
      case WeatherCondition.foggy:
        return 'Foggy';
      case WeatherCondition.unknown:
        return 'Unknown';
    }
  }
}