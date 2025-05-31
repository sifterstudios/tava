import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tava/features/progress/domain/entities/practice_stats.dart';

class PracticeHistoryChart extends StatelessWidget {
  final List<DailyPracticeTime> dailyPracticeTimes;

  const PracticeHistoryChart({
    super.key,
    required this.dailyPracticeTimes,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (dailyPracticeTimes.isEmpty) {
      return Center(
        child: Text(
          'No practice data available',
          style: theme.textTheme.bodyLarge,
        ),
      );
    }

    // Sort by date
    final sortedData = List<DailyPracticeTime>.from(dailyPracticeTimes)
      ..sort((a, b) => a.date.compareTo(b.date));

    // Create spots for the chart
    final spots = sortedData
        .asMap()
        .entries
        .map((entry) => FlSpot(
              entry.key.toDouble(),
              entry.value.duration.inMinutes.toDouble(),
            ))
        .toList();

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: _calculateMaxY(sortedData),
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            // tooltipBgColor: theme.colorScheme.surface,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final date = sortedData[groupIndex].date;
              final minutes = sortedData[groupIndex].duration.inMinutes;
              return BarTooltipItem(
                '${date.day}/${date.month}\n$minutes min',
                theme.textTheme.bodySmall!,
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= sortedData.length || value.toInt() < 0) {
                  return const SizedBox();
                }
                final date = sortedData[value.toInt()].date;
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    '${date.day}/${date.month}',
                    style: theme.textTheme.bodySmall,
                  ),
                );
              },
              reservedSize: 30,
            ),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
            ),
          ),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: spots
            .asMap()
            .entries
            .map(
              (entry) => BarChartGroupData(
                x: entry.key,
                barRods: [
                  BarChartRodData(
                    toY: entry.value.y,
                    color: theme.colorScheme.primary,
                    width: 16,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4),
                    ),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }

  double _calculateMaxY(List<DailyPracticeTime> data) {
    if (data.isEmpty) return 60; // Default 1 hour if no data
    
    final maxMinutes = data
        .map((e) => e.duration.inMinutes)
        .reduce((a, b) => a > b ? a : b)
        .toDouble();
    
    // Add 20% padding to the top
    return maxMinutes * 1.2;
  }
}