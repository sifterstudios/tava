part of 'metronome_bloc.dart';

abstract class MetronomeEvent extends Equatable {
  const MetronomeEvent();

  @override
  List<Object> get props => [];
}

class LoadMetronomePresets extends MetronomeEvent {}

class ChangeBpm extends MetronomeEvent {
  final int bpm;

  const ChangeBpm(this.bpm);

  @override
  List<Object> get props => [bpm];
}

class ChangeTimeSignature extends MetronomeEvent {
  final int beatsPerMeasure;
  final int beatUnit;

  const ChangeTimeSignature(this.beatsPerMeasure, this.beatUnit);

  @override
  List<Object> get props => [beatsPerMeasure, beatUnit];
}

class StartMetronome extends MetronomeEvent {}

class StopMetronome extends MetronomeEvent {}

class SavePreset extends MetronomeEvent {
  final String name;

  const SavePreset(this.name);

  @override
  List<Object> get props => [name];
}

class DeletePreset extends MetronomeEvent {
  final String presetId;

  const DeletePreset(this.presetId);

  @override
  List<Object> get props => [presetId];
}

class SelectPreset extends MetronomeEvent {
  final MetronomePreset preset;

  const SelectPreset(this.preset);

  @override
  List<Object> get props => [preset];
}