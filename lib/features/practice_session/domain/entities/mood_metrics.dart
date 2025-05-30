import 'package:equatable/equatable.dart';

class MoodMetrics extends Equatable {
  final int energyLevel; // 1-5
  final int focusLevel; // 1-5
  final int sleepQuality; // 1-5
  final bool hadAlcohol;
  final String? notes;

  const MoodMetrics({
    required this.energyLevel,
    required this.focusLevel,
    required this.sleepQuality,
    required this.hadAlcohol,
    this.notes,
  });

  @override
  List<Object?> get props => [
    energyLevel,
    focusLevel,
    sleepQuality,
    hadAlcohol,
    notes,
  ];
}