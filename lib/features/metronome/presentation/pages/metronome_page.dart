import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tava/core/di/injection.dart';
import 'package:tava/core/widgets/empty_state.dart';
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
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Metronome'),
        actions: [
          IconButton(
            tooltip: 'BPM history',
            icon: const Icon(Icons.history_rounded),
            onPressed: () => _showBpmHistory(context),
          ),
          IconButton(
            tooltip: 'Sound',
            icon: const Icon(Icons.tune_rounded),
            onPressed: () => _showMetronomeSettings(context),
          ),
        ],
      ),
      body: BlocBuilder<MetronomeBloc, MetronomeState>(
        builder: (context, state) {
          if (state.status == MetronomeStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == MetronomeStatus.failure) {
            return EmptyState(
              icon: Icons.speed_rounded,
              title: 'Metronome unavailable',
              message: state.errorMessage ?? 'Could not load presets.',
              actionLabel: 'Retry',
              onAction: () =>
                  context.read<MetronomeBloc>().add(LoadMetronomePresets()),
            );
          }

          return Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 36),
                color: colors.primaryContainer,
                child: Column(
                  children: [
                    Semantics(
                      label: '${state.currentBpm} beats per minute',
                      child: Text(
                        '${state.currentBpm}',
                        style: theme.textTheme.displayLarge?.copyWith(
                          color: colors.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ),
                    Text(
                      'BPM',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colors.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                  children: [
                    BpmSlider(
                      value: state.currentBpm.toDouble(),
                      onChanged: (value) => context
                          .read<MetronomeBloc>()
                          .add(ChangeBpm(value.toInt())),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => context
                                .read<MetronomeBloc>()
                                .add(TapTempo(DateTime.now())),
                            icon: const Icon(Icons.touch_app_rounded),
                            label: const Text('Tap tempo'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        TimeSignatureSelector(
                          beatsPerMeasure: state.beatsPerMeasure,
                          beatUnit: state.beatUnit,
                          onChanged: (beats, unit) => context
                              .read<MetronomeBloc>()
                              .add(ChangeTimeSignature(beats, unit)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const MetronomeControl(),
                    const SizedBox(height: 28),
                    Row(
                      children: [
                        Text('Presets', style: theme.textTheme.titleLarge),
                        const Spacer(),
                        TextButton.icon(
                          onPressed: () => _showSavePresetDialog(context),
                          icon: const Icon(Icons.add_rounded),
                          label: const Text('Save current'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (state.presets.isEmpty)
                      Text(
                        'No saved presets yet.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      )
                    else
                      PresetSelector(
                        presets: state.presets,
                        onSelectPreset: (preset) => context
                            .read<MetronomeBloc>()
                            .add(SelectPreset(preset)),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showBpmHistory(BuildContext context) {
    final bloc = context.read<MetronomeBloc>();
    final formatter = DateFormat.yMMMd().add_jm();

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return BlocProvider.value(
          value: bloc,
          child: SafeArea(
            child: SizedBox(
              height: MediaQuery.sizeOf(sheetContext).height * 0.45,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'BPM history',
                      style: Theme.of(sheetContext).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: BlocBuilder<MetronomeBloc, MetronomeState>(
                        builder: (context, state) {
                          if (state.bpmHistory.isEmpty) {
                            return const Center(
                              child: Text('No recent tempo changes'),
                            );
                          }

                          return ListView.builder(
                            itemCount: state.bpmHistory.length,
                            itemBuilder: (context, index) {
                              final entry = state.bpmHistory[index];
                              return ListTile(
                                title: Text('${entry.bpm} BPM'),
                                subtitle: Text(formatter.format(entry.dateTime)),
                                trailing: IconButton(
                                  tooltip: 'Use this tempo',
                                  icon: const Icon(Icons.play_arrow_rounded),
                                  onPressed: () {
                                    context
                                        .read<MetronomeBloc>()
                                        .add(ChangeBpm(entry.bpm));
                                    Navigator.of(sheetContext).pop();
                                  },
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
            ),
          ),
        );
      },
    );
  }

  void _showMetronomeSettings(BuildContext context) {
    final bloc = context.read<MetronomeBloc>();

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return BlocProvider.value(
          value: bloc,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: BlocBuilder<MetronomeBloc, MetronomeState>(
                builder: (context, state) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Click sound',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      ...['click', 'wood', 'digital'].map(
                        (sound) => RadioListTile<String>(
                          title: Text(sound[0].toUpperCase() + sound.substring(1)),
                          value: sound,
                          groupValue: state.soundType,
                          onChanged: (value) {
                            if (value != null) {
                              context
                                  .read<MetronomeBloc>()
                                  .add(ChangeSoundType(value));
                            }
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void _showSavePresetDialog(BuildContext context) {
    final bloc = context.read<MetronomeBloc>();
    final nameController = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: bloc,
          child: AlertDialog(
            title: const Text('Save preset'),
            content: TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Preset name',
                hintText: 'e.g. Jazz swing, Bach tempo',
              ),
              autofocus: true,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _savePreset(
                dialogContext,
                nameController,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => _savePreset(dialogContext, nameController),
                child: const Text('Save'),
              ),
            ],
          ),
        );
      },
    ).whenComplete(nameController.dispose);
  }

  void _savePreset(
    BuildContext context,
    TextEditingController nameController,
  ) {
    final name = nameController.text.trim();
    if (name.isEmpty) return;
    context.read<MetronomeBloc>().add(SavePreset(name));
    Navigator.of(context).pop();
  }
}
