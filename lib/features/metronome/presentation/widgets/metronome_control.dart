import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tava/features/metronome/presentation/bloc/metronome_bloc.dart';

class MetronomeControl extends StatelessWidget {
  const MetronomeControl({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<MetronomeBloc, MetronomeState>(
      buildWhen: (previous, current) =>
          previous.isPlaying != current.isPlaying ||
          previous.currentBeat != current.currentBeat ||
          previous.beatsPerMeasure != current.beatsPerMeasure,
      builder: (context, state) {
        return Column(
          children: [
            Semantics(
              button: true,
              label: state.isPlaying ? 'Stop metronome' : 'Start metronome',
              child: FilledButton.icon(
                onPressed: () {
                  if (state.isPlaying) {
                    context.read<MetronomeBloc>().add(StopMetronome());
                  } else {
                    context.read<MetronomeBloc>().add(StartMetronome());
                  }
                },
                icon: Icon(
                  state.isPlaying
                      ? Icons.stop_rounded
                      : Icons.play_arrow_rounded,
                ),
                label: Text(state.isPlaying ? 'Stop' : 'Start'),
                style: FilledButton.styleFrom(
                  backgroundColor: state.isPlaying
                      ? theme.colorScheme.error
                      : theme.colorScheme.primary,
                  foregroundColor: state.isPlaying
                      ? theme.colorScheme.onError
                      : theme.colorScheme.onPrimary,
                  minimumSize: const Size(160, 48),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (state.isPlaying)
              _MetronomeVisualizer(
                beatsPerMeasure: state.beatsPerMeasure,
                currentBeat: state.currentBeat,
              ),
          ],
        );
      },
    );
  }
}

class _MetronomeVisualizer extends StatelessWidget {
  const _MetronomeVisualizer({
    required this.beatsPerMeasure,
    required this.currentBeat,
  });

  final int beatsPerMeasure;
  final int currentBeat;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      liveRegion: true,
      label: 'Beat $currentBeat of $beatsPerMeasure',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          beatsPerMeasure,
          (index) {
            final isActive = index + 1 == currentBeat;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 90),
                width: isActive ? 20 : 14,
                height: isActive ? 20 : 14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive
                      ? theme.colorScheme.primary
                      : theme.colorScheme.surfaceContainerHighest,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
