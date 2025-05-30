import 'package:equatable/equatable.dart';

class MetronomePreset extends Equatable {
  final String id;
  final String name;
  final int bpm;
  final int beatsPerMeasure;
  final int beatUnit;
  final List<int> accentPattern;
  final String soundType;
  final bool isFavorite;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MetronomePreset({
    required this.id,
    required this.name,
    required this.bpm,
    required this.beatsPerMeasure,
    required this.beatUnit,
    required this.accentPattern,
    required this.soundType,
    required this.isFavorite,
    required this.createdAt,
    required this.updatedAt,
  });

  MetronomePreset copyWith({
    String? id,
    String? name,
    int? bpm,
    int? beatsPerMeasure,
    int? beatUnit,
    List<int>? accentPattern,
    String? soundType,
    bool? isFavorite,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MetronomePreset(
      id: id ?? this.id,
      name: name ?? this.name,
      bpm: bpm ?? this.bpm,
      beatsPerMeasure: beatsPerMeasure ?? this.beatsPerMeasure,
      beatUnit: beatUnit ?? this.beatUnit,
      accentPattern: accentPattern ?? this.accentPattern,
      soundType: soundType ?? this.soundType,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    bpm,
    beatsPerMeasure,
    beatUnit,
    accentPattern,
    soundType,
    isFavorite,
    createdAt,
    updatedAt,
  ];
}