import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:tava/features/metronome/domain/entities/metronome_preset.dart';
import 'package:uuid/uuid.dart';

part 'metronome_event.dart';
part 'metronome_state.dart';

@injectable
class MetronomeBloc extends Bloc<MetronomeEvent, MetronomeState> {
  MetronomeBloc() : super(const MetronomeState.initial()) {
    on<LoadMetronomePresets>(_onLoadMetronomePresets);
    on<ChangeBpm>(_onChangeBpm);
    on<ChangeTimeSignature>(_onChangeTimeSignature);
    on<StartMetronome>(_onStartMetronome);
    on<StopMetronome>(_onStopMetronome);
    on<SavePreset>(_onSavePreset);
    on<DeletePreset>(_onDeletePreset);
    on<SelectPreset>(_onSelectPreset);
  }

  Future<void> _onLoadMetronomePresets(
    LoadMetronomePresets event,
    Emitter<MetronomeState> emit,
  ) async {
    emit(state.copyWith(status: MetronomeStatus.loading));

    // This would normally call a repository method, but for now we'll use mock data
    await Future.delayed(const Duration(milliseconds: 500));
    
    final presets = _getMockPresets();
    
    emit(state.copyWith(
      status: MetronomeStatus.success,
      presets: presets,
    ));
  }

  void _onChangeBpm(
    ChangeBpm event,
    Emitter<MetronomeState> emit,
  ) {
    // Ensure BPM is within valid range
    final bpm = event.bpm.clamp(30, 300);
    
    // Add to history if different from current
    final updatedHistory = List<BpmHistoryEntry>.from(state.bpmHistory);
    if (bpm != state.currentBpm) {
      updatedHistory.insert(
        0,
        BpmHistoryEntry(
          bpm: state.currentBpm,
          dateTime: DateTime.now(),
        ),
      );
      
      // Keep only the last 10 entries
      if (updatedHistory.length > 10) {
        updatedHistory.removeLast();
      }
    }
    
    emit(state.copyWith(
      currentBpm: bpm,
      bpmHistory: updatedHistory,
    ));
  }

  void _onChangeTimeSignature(
    ChangeTimeSignature event,
    Emitter<MetronomeState> emit,
  ) {
    emit(state.copyWith(
      beatsPerMeasure: event.beatsPerMeasure,
      beatUnit: event.beatUnit,
    ));
  }

  void _onStartMetronome(
    StartMetronome event,
    Emitter<MetronomeState> emit,
  ) {
    emit(state.copyWith(isPlaying: true));
  }

  void _onStopMetronome(
    StopMetronome event,
    Emitter<MetronomeState> emit,
  ) {
    emit(state.copyWith(isPlaying: false));
  }

  void _onSavePreset(
    SavePreset event,
    Emitter<MetronomeState> emit,
  ) {
    final newPreset = MetronomePreset(
      id: const Uuid().v4(),
      name: event.name,
      bpm: state.currentBpm,
      beatsPerMeasure: state.beatsPerMeasure,
      beatUnit: state.beatUnit,
      accentPattern: List.generate(state.beatsPerMeasure, (index) => index == 0 ? 2 : 1),
      soundType: state.soundType,
      isFavorite: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    final updatedPresets = List<MetronomePreset>.from(state.presets)
      ..add(newPreset);
    
    emit(state.copyWith(presets: updatedPresets));
  }

  void _onDeletePreset(
    DeletePreset event,
    Emitter<MetronomeState> emit,
  ) {
    final updatedPresets = List<MetronomePreset>.from(state.presets)
      ..removeWhere((preset) => preset.id == event.presetId);
    
    emit(state.copyWith(presets: updatedPresets));
  }

  void _onSelectPreset(
    SelectPreset event,
    Emitter<MetronomeState> emit,
  ) {
    emit(state.copyWith(
      currentBpm: event.preset.bpm,
      beatsPerMeasure: event.preset.beatsPerMeasure,
      beatUnit: event.preset.beatUnit,
      soundType: event.preset.soundType,
    ));
  }

  List<MetronomePreset> _getMockPresets() {
    return [
      MetronomePreset(
        id: '1',
        name: 'Practice Tempo',
        bpm: 80,
        beatsPerMeasure: 4,
        beatUnit: 4,
        accentPattern: [2, 1, 1, 1],
        soundType: 'click',
        isFavorite: true,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      MetronomePreset(
        id: '2',
        name: 'Performance Tempo',
        bpm: 120,
        beatsPerMeasure: 4,
        beatUnit: 4,
        accentPattern: [2, 1, 1, 1],
        soundType: 'click',
        isFavorite: false,
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      MetronomePreset(
        id: '3',
        name: 'Waltz',
        bpm: 90,
        beatsPerMeasure: 3,
        beatUnit: 4,
        accentPattern: [2, 1, 1],
        soundType: 'wood',
        isFavorite: true,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        updatedAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ];
  }
}