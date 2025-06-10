part of 'metronome_bloc.dart';

abstract class MetronomeEvent extends Equatable {
  const MetronomeEvent();

  @override
  List<Object> get props => [];
}

class LoadMetronomePresets extends MetronomeEvent {}

class ChangeBpm extends MetronomeEvent {

  const ChangeBpm(this.bpm);
  final int bpm;

  @override
  List<Object> get props => [bpm];
}

class ChangeTimeSignature extends MetronomeEvent {

  const ChangeTimeSignature(this.beatsPerMeasure, this.beatUnit);
  final int beatsPerMeasure;
  final int beatUnit;

  @override
  List<Object> get props => [beatsPerMeasure, beatUnit];
}

class StartMetronome extends MetronomeEvent {}

class StopMetronome extends MetronomeEvent {}

class SavePreset extends MetronomeEvent {

  const SavePreset(this.name);
  final String name;

  @override
  List<Object> get props => [name];
}

class DeletePreset extends MetronomeEvent {

  const DeletePreset(this.presetId);
  final String presetId;

  @override
  List<Object> get props => [presetId];
}

class SelectPreset extends MetronomeEvent {

  const SelectPreset(this.preset);
  final MetronomePreset preset;

  @override
  List<Object> get props => [preset];
}