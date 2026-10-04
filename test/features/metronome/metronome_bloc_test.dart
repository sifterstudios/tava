import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tava/core/services/metronome_audio_service.dart';
import 'package:tava/features/metronome/presentation/bloc/metronome_bloc.dart';

class _MockAudio extends Mock implements MetronomeAudioService {}

void main() {
  late _MockAudio audio;

  setUp(() {
    audio = _MockAudio();
    when(() => audio.initialize()).thenAnswer((_) async {});
    when(() => audio.setSoundType(any())).thenAnswer((_) async {});
    when(
      () => audio.playTick(accent: any(named: 'accent')),
    ).thenAnswer((_) async {});
  });

  MetronomeBloc buildBloc() => MetronomeBloc(audio);

  group('MetronomeBloc', () {
    blocTest<MetronomeBloc, MetronomeState>(
      'clamps BPM into 30-300',
      build: buildBloc,
      act: (bloc) => bloc.add(const ChangeBpm(400)),
      expect: () => [
        isA<MetronomeState>().having((s) => s.currentBpm, 'bpm', 300),
      ],
    );

    blocTest<MetronomeBloc, MetronomeState>(
      'records bpm history when tempo changes',
      build: buildBloc,
      seed: () => const MetronomeState(
        status: MetronomeStatus.success,
        currentBpm: 100,
        beatsPerMeasure: 4,
        beatUnit: 4,
        soundType: 'click',
        isPlaying: false,
        currentBeat: 1,
        presets: [],
        bpmHistory: [],
      ),
      act: (bloc) => bloc.add(const ChangeBpm(110)),
      verify: (bloc) {
        expect(bloc.state.currentBpm, 110);
        expect(bloc.state.bpmHistory.first.bpm, 100);
      },
    );

    blocTest<MetronomeBloc, MetronomeState>(
      'ignores empty preset names',
      build: buildBloc,
      seed: () => const MetronomeState(
        status: MetronomeStatus.success,
        currentBpm: 120,
        beatsPerMeasure: 4,
        beatUnit: 4,
        soundType: 'click',
        isPlaying: false,
        currentBeat: 1,
        presets: [],
        bpmHistory: [],
      ),
      act: (bloc) => bloc.add(const SavePreset('   ')),
      expect: () => <MetronomeState>[],
    );

    blocTest<MetronomeBloc, MetronomeState>(
      'advances beat on tick while playing',
      build: buildBloc,
      seed: () => const MetronomeState(
        status: MetronomeStatus.success,
        currentBpm: 120,
        beatsPerMeasure: 4,
        beatUnit: 4,
        soundType: 'click',
        isPlaying: true,
        currentBeat: 1,
        presets: [],
        bpmHistory: [],
      ),
      act: (bloc) => bloc.add(MetronomeTick()),
      expect: () => [
        isA<MetronomeState>().having((s) => s.currentBeat, 'beat', 2),
      ],
    );
  });
}
