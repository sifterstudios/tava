import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tava/features/metronome/presentation/bloc/metronome_bloc.dart';

class MetronomeControl extends StatelessWidget {
  const MetronomeControl({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<MetronomeBloc, MetronomeState>(
      buildWhen: (previous, current) => previous.isPlaying != current.isPlaying,
      builder: (context, state) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton.icon(
                  onPressed: () {
                    if (state.isPlaying) {
                      context.read<MetronomeBloc>().add(StopMetronome());
                    } else {
                      context.read<MetronomeBloc>().add(StartMetronome());
                    }
                  },
                  icon: Icon(
                    state.isPlaying ? Icons.stop : Icons.play_arrow,
                  ),
                  label: Text(
                    state.isPlaying ? 'Stop' : 'Start',
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: state.isPlaying
                        ? theme.colorScheme.error
                        : theme.colorScheme.primary,
                    foregroundColor: state.isPlaying
                        ? theme.colorScheme.onError
                        : theme.colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (state.isPlaying)
              _MetronomeVisualizer(
                beatsPerMeasure: state.beatsPerMeasure,
                currentBeat: 1, // This would be controlled by the actual metronome
              ),
          ],
        );
      },
    );
  }
}

class _MetronomeVisualizer extends StatelessWidget {
  final int beatsPerMeasure;
  final int currentBeat;

  const _MetronomeVisualizer({
    required this.beatsPerMeasure,
    required this.currentBeat,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        beatsPerMeasure,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: index + 1 == currentBeat
                  ? theme.colorScheme.primary
                  : theme.colorScheme.surfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}