import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tava/features/exercise_library/domain/entities/exercise.dart';

class CategoryBreakdownChart extends StatelessWidget {
  final Map<ExerciseCategory, Duration> categoryData;

  const CategoryBreakdownChart({
    super.key,
    required this.categoryData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (categoryData.isEmpty) {
      return Center(
        child: Text(
          'No category data available',
          style: theme.textTheme.bodyLarge,
        ),
      );
    }

    // Calculate total duration
    final totalMinutes = categoryData.values
        .fold<int>(0, (sum, duration) => sum + duration.inMinutes);

    // Create sections for the pie chart
    final sections = <PieChartSectionData>[];
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.amber,
    ];

    int colorIndex = 0;
    categoryData.forEach((category, duration) {
      final percentage = totalMinutes > 0
          ? (duration.inMinutes / totalMinutes * 100)
          : 0.0;
      
      sections.add(
        PieChartSectionData(
          color: colors[colorIndex % colors.length],
          value: percentage,
          title: '${percentage.toStringAsFixed(1)}%',
          radius: 80,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
      colorIndex++;
    });

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: PieChart(
            PieChartData(
              sections: sections,
              centerSpaceRadius: 0,
              sectionsSpace: 2,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...categoryData.entries.map((entry) {
                final index = categoryData.keys.toList().indexOf(entry.key);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        color: colors[index % colors.length],
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _getCategoryName(entry.key),
                          style: theme.textTheme.bodySmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ],
    );
  }

  String _getCategoryName(ExerciseCategory category) {
    switch (category) {
      case ExerciseCategory.technique:
        return 'Technique';
      case ExerciseCategory.repertoire:
        return 'Repertoire';
      case ExerciseCategory.scales:
        return 'Scales';
      case ExerciseCategory.etudes:
        return 'Etudes';
      case ExerciseCategory.sightReading:
        return 'Sight Reading';
      case ExerciseCategory.improvisation:
        return 'Improvisation';
      case ExerciseCategory.other:
        return 'Other';
    }
  }
}