import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tava/features/metronome/domain/entities/metronome_preset.dart';
import 'package:tava/features/metronome/presentation/bloc/metronome_bloc.dart';

class PresetSelector extends StatelessWidget {
  final List<MetronomePreset> presets;
  final Function(MetronomePreset) onSelectPreset;

  const PresetSelector({
    super.key,
    required this.presets,
    required this.onSelectPreset,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (presets.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.playlist_add, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'No presets saved yet',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Save your current settings as a preset',
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: presets.length,
      itemBuilder: (context, index) {
        final preset = presets[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            title: Text(preset.name),
            subtitle: Text(
              '${preset.bpm} BPM, ${preset.beatsPerMeasure}/${preset.beatUnit}',
            ),
            leading: Icon(
              preset.isFavorite ? Icons.favorite : Icons.music_note,
              color: preset.isFavorite ? Colors.redAccent : null,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.play_arrow),
                  onPressed: () => onSelectPreset(preset),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    context
                        .read<MetronomeBloc>()
                        .add(DeletePreset(preset.id));
                  },
                ),
              ],
            ),
            onTap: () => onSelectPreset(preset),
          ),
        );
      },
    );
  }
}