import 'package:equatable/equatable.dart';

class ExerciseRecord extends Equatable {
  final String id;
  final String exerciseId;
  final String name;
  final int? bpm;
  final Duration duration;
  final int? rating;
  final String? notes;

  const ExerciseRecord({
    required this.id,
    required this.exerciseId,
    required this.name,
    this.bpm,
    required this.duration,
    this.rating,
    this.notes,
  });

  @override
  List<Object?> get props => [
        id,
        exerciseId,
        name,
        bpm,
        duration,
        rating,
        notes,
      ];
}