import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tava/core/di/injection.dart';
import 'package:tava/features/metronome/domain/entities/metronome_preset.dart';
import 'package:tava/features/metronome/presentation/bloc/metronome_bloc.dart';
import 'package:tava/features/metronome/presentation/widgets/bpm_slider.dart';
import 'package:tava/features/metronome/presentation/widgets/metronome_control.dart';
import 'package:tava/features/metronome/presentation/widgets/preset_selector.dart';
import 'package:tava/features/metronome/presentation/widgets/time_signature_selector.dart';

class MetronomePage extends StatelessWidget {
  const MetronomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<MetronomeBloc>()..add(LoadMetronomePresets()),
      child: const MetronomeView(),
    );
  }
}

class MetronomeView extends StatelessWidget {
  const MetronomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Metronome'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => _showBpmHistory(context),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showMetronomeSettings(context),
          ),
        ],
      ),
      body: BlocBuilder<MetronomeBloc, MetronomeState>(
        builder: (context, state) {
          return Column(
            children: [
              // BPM Display
              Container(
                color: theme.colorScheme.primaryContainer,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${state.currentBpm}',
                      style: theme.textTheme.displayLarge?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'BPM',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
              
              // BPM Slider
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 24,
                ),
                child: BpmSlider(
                  value: state.currentBpm.toDouble(),
                  onChanged: (value) => context
                      .read<MetronomeBloc>()
                      .add(ChangeBpm(value.toInt())),
                ),
              ),
              
              // Tap tempo and time signature
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () => _showTapTempoDialog(context),
                      icon: const Icon(Icons.touch_app),
                      label: const Text('Tap Tempo'),
                    ),
                    TimeSignatureSelector(
                      beatsPerMeasure: state.beatsPerMeasure,
                      beatUnit: state.beatUnit,
                      onChanged: (beats, unit) => context
                          .read<MetronomeBloc>()
                          .add(ChangeTimeSignature(beats, unit)),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Metronome control
              const MetronomeControl(),
              
              const SizedBox(height: 24),
              
              // Presets section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Presets',
                      style: theme.textTheme.titleLarge,
                    ),
                    TextButton.icon(
                      onPressed: () => _showSavePresetDialog(context),
                      icon: const Icon(Icons.add),
                      label: const Text('Save Current'),
                    ),
                  ],
                ),
              ),
              
              // Preset list
              Expanded(
                child: PresetSelector(
                  presets: state.presets,
                  onSelectPreset: (preset) => context
                      .read<MetronomeBloc>()
                      .add(SelectPreset(preset)),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showBpmHistory(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'BPM History',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<MetronomeBloc, MetronomeState>(
                builder: (context, state) {
                  if (state.bpmHistory.isEmpty) {
                    return const Center(
                      child: Text('No BPM history available'),
                    );
                  }
                  
                  return ListView.builder(
                    itemCount: state.bpmHistory.length,
                    itemBuilder: (context, index) {
                      final entry = state.bpmHistory[index];
                      return ListTile(
                        title: Text('${entry.bpm} BPM'),
                        subtitle: Text(
                          '${entry.dateTime.day}/${entry.dateTime.month}/${entry.dateTime.year} ${entry.dateTime.hour}:${entry.dateTime.minute}',
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.play_arrow),
                          onPressed: () => context
                              .read<MetronomeBloc>()
                              .add(ChangeBpm(entry.bpm)),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMetronomeSettings(BuildContext context) {
    // Implement metronome settings dialog
  }

  void _showTapTempoDialog(BuildContext context) {
    // Implement tap tempo dialog
  }

  void _showSavePresetDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Save Preset'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Preset Name',
            hintText: 'e.g., Jazz Swing, Bach Tempo',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                context.read<MetronomeBloc>().add(
                      SavePreset(nameController.text.trim()),
                    );
                Navigator.of(context).pop();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}