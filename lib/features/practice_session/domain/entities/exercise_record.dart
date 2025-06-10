import 'package:equatable/equatable.dart';

class ExerciseRecord extends Equatable {

  const ExerciseRecord({
    required this.id,
    required this.exerciseId,
    required this.name,
    required this.duration, this.bpm,
    this.rating,
    this.notes,
  });
  final String id;
  final String exerciseId;
  final String name;
  final int? bpm;
  final Duration duration;
  final int? rating;
  final String? notes;

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