import 'package:equatable/equatable.dart';

class MoodMetrics extends Equatable {

  const MoodMetrics({
    required this.energyLevel,
    required this.focusLevel,
    required this.sleepQuality,
    required this.hadAlcohol,
    this.notes,
  });
  final int energyLevel; // 1-5
  final int focusLevel; // 1-5
  final int sleepQuality; // 1-5
  final bool hadAlcohol;
  final String? notes;

  @override
  List<Object?> get props => [
    energyLevel,
    focusLevel,
    sleepQuality,
    hadAlcohol,
    notes,
  ];
}