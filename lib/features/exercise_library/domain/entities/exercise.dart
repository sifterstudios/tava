import 'package:equatable/equatable.dart';

enum ExerciseCategory {
  technique,
  repertoire,
  scales,
  etudes,
  sightReading,
  improvisation,
  other,
}

class Exercise extends Equatable {

  const Exercise({
    required this.id,
    required this.name,
    required this.category, required this.tags, required this.isFavorite, required this.createdAt, required this.updatedAt, required this.isArchived, this.description,
    this.targetBpm,
    this.targetDuration,
    this.source,
  });
  final String id;
  final String name;
  final String? description;
  final ExerciseCategory category;
  final int? targetBpm;
  final Duration? targetDuration;
  final String? source;
  final List<String> tags;
  final bool isFavorite;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isArchived;

  Exercise copyWith({
    String? id,
    String? name,
    String? description,
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