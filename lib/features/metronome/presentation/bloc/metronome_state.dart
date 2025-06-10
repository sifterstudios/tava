part of 'metronome_bloc.dart';

enum MetronomeStatus { initial, loading, success, failure }

class BpmHistoryEntry extends Equatable {

  const BpmHistoryEntry({
    required this.bpm,
    required this.dateTime,
  });
  final int bpm;
  final DateTime dateTime;

  @override
  List<Object> get props => [bpm, dateTime];
}

class MetronomeState extends Equatable {

  const MetronomeState({
    required this.status,
    required this.currentBpm,
    required this.beatsPerMeasure,
    required this.beatUnit,
    required this.soundType,
    required this.isPlaying,
    required this.presets,
    required this.bpmHistory,
    this.errorMessage,
  });

  const MetronomeState.initial()
      : status = MetronomeStatus.initial,
        currentBpm = 120,
        beatsPerMeasure = 4,
        beatUnit = 4,
        soundType = 'click',
        isPlaying = false,
        presets = const [],
        bpmHistory = const [],
        errorMessage = null;
  final MetronomeStatus status;
  final int currentBpm;
  final int beatsPerMeasure;
  final int beatUnit;
  final String soundType;
  final bool isPlaying;
  final List<MetronomePreset> presets;
  final List<BpmHistoryEntry> bpmHistory;
  final String? errorMessage;

  MetronomeState copyWith({
    MetronomeStatus? status,
    int? currentBpm,
    int? beatsPerMeasure,
    int? beatUnit,
    String? soundType,
    bool? isPlaying,
    List<MetronomePreset>? presets,
    List<BpmHistoryEntry>? bpmHistory,
    String? errorMessage,
  }) {
    return MetronomeState(
      status: status ?? this.status,
      currentBpm: currentBpm ?? this.currentBpm,
      beatsPerMeasure: beatsPerMeasure ?? this.beatsPerMeasure,
      beatUnit: beatUnit ?? this.beatUnit,
      soundType: soundType ?? this.soundType,
      isPlaying: isPlaying ?? this.isPlaying,
      presets: presets ?? this.presets,
      bpmHistory: bpmHistory ?? this.bpmHistory,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        currentBpm,
        beatsPerMeasure,
        beatUnit,
        soundType,
        isPlaying,
        presets,
        bpmHistory,
        errorMessage,
      ];
}