import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:tava/core/services/metronome_audio_service.dart';
import 'package:tava/features/metronome/domain/entities/metronome_preset.dart';
import 'package:uuid/uuid.dart';

part 'metronome_event.dart';
part 'metronome_state.dart';

@injectable
class MetronomeBloc extends Bloc<MetronomeEvent, MetronomeState> {
  MetronomeBloc(this._audio) : super(const MetronomeState.initial()) {
    on<LoadMetronomePresets>(_onLoadMetronomePresets);
    on<ChangeBpm>(_onChangeBpm);
    on<ChangeTimeSignature>(_onChangeTimeSignature);
    on<StartMetronome>(_onStartMetronome);
    on<StopMetronome>(_onStopMetronome);
    on<MetronomeTick>(_onMetronomeTick);
    on<TapTempo>(_onTapTempo);
    on<SavePreset>(_onSavePreset);
    on<DeletePreset>(_onDeletePreset);
    on<SelectPreset>(_onSelectPreset);
    on<ChangeSoundType>(_onChangeSoundType);
  }

  final MetronomeAudioService _audio;
  Timer? _tickTimer;
  final List<DateTime> _tapTimes = [];

  @override
  Future<void> close() {
    _tickTimer?.cancel();
    return super.close();
  }

  Future<void> _onLoadMetronomePresets(
    LoadMetronomePresets event,
    Emitter<MetronomeState> emit,
  ) async {
    emit(state.copyWith(status: MetronomeStatus.loading));

    try {
      await _audio.initialize();
      await _audio.setSoundType(state.soundType);
      await Future<void>.delayed(const Duration(milliseconds: 200));
      emit(
        state.copyWith(
          status: MetronomeStatus.success,
          presets: _getMockPresets(),
        ),
      );
    } on Object catch (e) {
      emit(
        state.copyWith(
          status: MetronomeStatus.failure,
          errorMessage: 'Could not load presets: $e',
        ),
      );
    }
  }

  void _onChangeBpm(
    ChangeBpm event,
    Emitter<MetronomeState> emit,
  ) {
    final bpm = event.bpm.clamp(30, 300);
    final updatedHistory = List<BpmHistoryEntry>.from(state.bpmHistory);

    if (bpm != state.currentBpm) {
      updatedHistory.insert(
        0,
        BpmHistoryEntry(
          bpm: state.currentBpm,
          dateTime: DateTime.now(),
        ),
      );
      if (updatedHistory.length > 10) {
        updatedHistory.removeLast();
      }
    }

    emit(
      state.copyWith(
        currentBpm: bpm,
        bpmHistory: updatedHistory,
      ),
    );

    if (state.isPlaying) {
      _restartTicker();
    }
  }

  void _onChangeTimeSignature(
    ChangeTimeSignature event,
    Emitter<MetronomeState> emit,
  ) {
    final beats = event.beatsPerMeasure.clamp(1, 12);
    final unit = event.beatUnit;
    if (![2, 4, 8].contains(unit)) return;

    emit(
      state.copyWith(
        beatsPerMeasure: beats,
        beatUnit: unit,
        currentBeat: 1,
      ),
    );
  }

  void _onStartMetronome(
    StartMetronome event,
    Emitter<MetronomeState> emit,
  ) {
    emit(state.copyWith(isPlaying: true, currentBeat: 1));
    _restartTicker();
  }

  void _onStopMetronome(
    StopMetronome event,
    Emitter<MetronomeState> emit,
  ) {
    _tickTimer?.cancel();
    _tickTimer = null;
    emit(state.copyWith(isPlaying: false, currentBeat: 1));
  }

  Future<void> _onMetronomeTick(
    MetronomeTick event,
    Emitter<MetronomeState> emit,
  ) async {
    if (!state.isPlaying) return;
    final nextBeat = (state.currentBeat % state.beatsPerMeasure) + 1;
    emit(state.copyWith(currentBeat: nextBeat));
    await _audio.playTick(accent: nextBeat == 1);
  }

  void _onTapTempo(
    TapTempo event,
    Emitter<MetronomeState> emit,
  ) {
    final now = event.timestamp;
    _tapTimes.removeWhere(
      (tap) => now.difference(tap) > const Duration(seconds: 3),
    );
    _tapTimes.add(now);

    if (_tapTimes.length < 2) return;

    var totalMs = 0;
    for (var i = 1; i < _tapTimes.length; i++) {
      totalMs += _tapTimes[i].difference(_tapTimes[i - 1]).inMilliseconds;
    }
    final averageMs = totalMs / (_tapTimes.length - 1);
    if (averageMs <= 0) return;

    final bpm = (60000 / averageMs).round().clamp(30, 300);
    add(ChangeBpm(bpm));
  }

  void _onSavePreset(
    SavePreset event,
    Emitter<MetronomeState> emit,
  ) {
    final name = event.name.trim();
    if (name.isEmpty) return;

    final newPreset = MetronomePreset(
      id: const Uuid().v4(),
      name: name,
      bpm: state.currentBpm,
      beatsPerMeasure: state.beatsPerMeasure,
      beatUnit: state.beatUnit,
      accentPattern: List.generate(
        state.beatsPerMeasure,
        (index) => index == 0 ? 2 : 1,
      ),
      soundType: state.soundType,
      isFavorite: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    emit(
      state.copyWith(
        presets: [...state.presets, newPreset],
      ),
    );
  }

  void _onDeletePreset(
    DeletePreset event,
    Emitter<MetronomeState> emit,
  ) {
    emit(
      state.copyWith(
        presets: state.presets
            .where((preset) => preset.id != event.presetId)
            .toList(),
      ),
    );
  }

  void _onSelectPreset(
    SelectPreset event,
    Emitter<MetronomeState> emit,
  ) {
    emit(
      state.copyWith(
        currentBpm: event.preset.bpm.clamp(30, 300),
        beatsPerMeasure: event.preset.beatsPerMeasure,
        beatUnit: event.preset.beatUnit,
        soundType: event.preset.soundType,
        currentBeat: 1,
      ),
    );
    if (state.isPlaying) {
      _restartTicker();
    }
  }

  Future<void> _onChangeSoundType(
    ChangeSoundType event,
    Emitter<MetronomeState> emit,
  ) async {
    const allowed = {'click', 'wood', 'digital'};
    if (!allowed.contains(event.soundType)) return;
    emit(state.copyWith(soundType: event.soundType));
    await _audio.setSoundType(event.soundType);
  }

  void _restartTicker() {
    _tickTimer?.cancel();
    final intervalMs = (60000 / state.currentBpm).round().clamp(200, 2000);
    _tickTimer = Timer.periodic(
      Duration(milliseconds: intervalMs),
      (_) => add(MetronomeTick()),
    );
  }

  List<MetronomePreset> _getMockPresets() {
    final now = DateTime.now();
    return [
      MetronomePreset(
        id: '1',
        name: 'Practice Tempo',
        bpm: 80,
        beatsPerMeasure: 4,
        beatUnit: 4,
        accentPattern: const [2, 1, 1, 1],
        soundType: 'click',
        isFavorite: true,
        createdAt: now.subtract(const Duration(days: 30)),
        updatedAt: now.subtract(const Duration(days: 2)),
      ),
      MetronomePreset(
        id: '2',
        name: 'Performance Tempo',
        bpm: 120,
        beatsPerMeasure: 4,
        beatUnit: 4,
        accentPattern: const [2, 1, 1, 1],
        soundType: 'click',
        isFavorite: false,
        createdAt: now.subtract(const Duration(days: 20)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
      MetronomePreset(
        id: '3',
        name: 'Waltz',
        bpm: 90,
        beatsPerMeasure: 3,
        beatUnit: 4,
        accentPattern: const [2, 1, 1],
        soundType: 'wood',
        isFavorite: true,
        createdAt: now.subtract(const Duration(days: 15)),
        updatedAt: now.subtract(const Duration(days: 5)),
      ),
    ];
  }
}
