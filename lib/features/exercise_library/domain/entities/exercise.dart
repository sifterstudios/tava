import 'package:equatable/equatable.dart';
import 'package:tava/features/practice_session/domain/entities/exercise_category.dart';

/// Represents an exercise in the exercise library.
class Exercise extends Equatable {
  /// Creates an instance of [Exercise].
  const Exercise({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.tags,
    required this.isFavorite,
    required this.createdAt,
    required this.updatedAt,
    required this.isArchived,
    this.description,
    this.category,
    this.targetBpm,
    this.targetDuration,
    this.source,
  });

  /// Unique identifier for the exercise.
  final String id;

  /// Name of the exercise.
  final String name;

  /// Optional description of the exercise.
  final String? description;

  /// Identifier for the category this exercise belongs to.
  final String categoryId;

  /// Optional category object for the exercise.
  final ExerciseCategory? category;

  /// Target beats per minute (BPM) for the exercise.
  final int? targetBpm;

  /// Optional target duration for the exercise.
  final Duration? targetDuration;

  /// Optional source of the exercise, such as a URL or reference.
  final String? source;

  /// List of tags associated with the exercise.
  final List<String> tags;

  /// Indicates whether the exercise is marked as a favorite.
  final bool isFavorite;

  /// Date and time when the exercise was created.
  final DateTime createdAt;

  /// Date and time when the exercise was last updated.
  final DateTime updatedAt;

  /// Indicates whether the exercise is archived.
  final bool isArchived;

  /// Creates a copy of the exercise with updated fields.
  Exercise copyWith({
    String? id,
    String? name,
    String? description,
    String? categoryId,
    ExerciseCategory? category,
    int? targetBpm,
    Duration? targetDuration,
    String? source,
    List<String>? tags,
    bool? isFavorite,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isArchived,
  }) {
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      category: category ?? this.category,
      targetBpm: targetBpm ?? this.targetBpm,
      targetDuration: targetDuration ?? this.targetDuration,
      source: source ?? this.source,
      tags: tags ?? this.tags,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isArchived: isArchived ?? this.isArchived,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        categoryId,
        category,
        targetBpm,
        targetDuration,
        source,
        tags,
        isFavorite,
        createdAt,
        updatedAt,
        isArchived,
      ];
}
