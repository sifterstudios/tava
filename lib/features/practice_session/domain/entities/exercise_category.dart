import 'package:equatable/equatable.dart';

class ExerciseCategory extends Equatable {
  final String id;
  final String name;
  final String? color;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ExerciseCategory({
    required this.id,
    required this.name,
    this.color,
    required this.createdAt,
    required this.updatedAt,
  });

  ExerciseCategory copyWith({
    String? id,
    String? name,
    String? color,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ExerciseCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Creates a new ExerciseCategory with default values for testing or initial state.
  factory ExerciseCategory.empty() => ExerciseCategory(
        id: '',
        name: 'Uncategorized',
        color: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

  @override
  List<Object?> get props => [id, name, color, createdAt, updatedAt];

  @override
  String toString() => 'ExerciseCategory(id: $id, name: $name)';
}