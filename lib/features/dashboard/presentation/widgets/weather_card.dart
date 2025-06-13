import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:tava/features/practice_session/domain/entities/weather_info.dart';

/// A widget that displays a weather card with information
/// about the current weather conditions.
class WeatherCard extends StatelessWidget {
  /// Creates a new instance of [WeatherCard].
  const WeatherCard({
    required this.weatherInfo,
    super.key,
  });

  /// The weather information to display in the card.
  final WeatherInfo weatherInfo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: platformThemeData(
          context,
          material: (data) => data.colorScheme.surface,
          cupertino: (data) => CupertinoColors.systemBackground,
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: platformThemeData(
            context,
            material: (data) => data.colorScheme.outline.withValues(alpha: 0.2),
            cupertino: (data) => CupertinoColors.separator,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _getWeatherColor(weatherInfo.condition)
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getWeatherIcon(weatherInfo.condition),
              color: _getWeatherColor(weatherInfo.condition),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PlatformText(
                  'Practice Environment',
                  style: platformThemeData(
                    context,
                    material: (data) => data.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    cupertino: (data) => data.textTheme.textStyle.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                PlatformText(
                  '${weatherInfo.temperature.round()}°C • '
                  '${_getConditionName(weatherInfo.condition)} • '
                  '${weatherInfo.humidity}% humidity',
                  style: platformThemeData(
                    context,
                    material: (data) => data.textTheme.bodySmall?.copyWith(
                      color: data.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    cupertino: (data) => data.textTheme.textStyle.copyWith(
                      color: CupertinoColors.secondaryLabel,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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
        return Icons.grain;
      case WeatherCondition.snowy:
        return Icons.ac_unit;
      case WeatherCondition.stormy:
        return Icons.flash_on;
      case WeatherCondition.foggy:
        return Icons.blur_on;
      case WeatherCondition.unknown:
        return Icons.help_outline;
    }
  }

  Color _getWeatherColor(WeatherCondition condition) {
    switch (condition) {
      case WeatherCondition.clear:
        return const Color(0xFFFFC107);
      case WeatherCondition.cloudy:
        return const Color(0xFF9E9E9E);
      case WeatherCondition.rainy:
        return const Color(0xFF2196F3);
      case WeatherCondition.snowy:
        return const Color(0xFF00BCD4);
      case WeatherCondition.stormy:
        return const Color(0xFF9C27B0);
      case WeatherCondition.foggy:
        return const Color(0xFF607D8B);
      case WeatherCondition.unknown:
        return const Color(0xFF757575);
    }
  }

  String _getConditionName(WeatherCondition condition) {
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
