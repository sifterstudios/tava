import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tava/features/metronome/domain/entities/metronome_preset.dart';
import 'package:tava/features/metronome/presentation/bloc/metronome_bloc.dart';

class PresetSelector extends StatelessWidget {
  const PresetSelector({
    required this.presets,
    required this.onSelectPreset,
    super.key,
  });

  final List<MetronomePreset> presets;
  final ValueChanged<MetronomePreset> onSelectPreset;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: presets.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final preset = presets[index];
        return Card(
          child: ListTile(
            title: Text(preset.name),
            subtitle: Text(
              '${preset.bpm} BPM · ${preset.beatsPerMeasure}/${preset.beatUnit}',
            ),
            leading: Icon(
              preset.isFavorite
                  ? Icons.favorite_rounded
                  : Icons.music_note_rounded,
              color: preset.isFavorite
                  ? theme.colorScheme.error
                  : theme.colorScheme.primary,
            ),
            trailing: IconButton(
              tooltip: 'Delete preset',
              icon: const Icon(Icons.delete_outline_rounded),
              onPressed: () {
                context.read<MetronomeBloc>().add(DeletePreset(preset.id));
              },
            ),
            onTap: () => onSelectPreset(preset),
          ),
        );
      },
    );
  }
}
