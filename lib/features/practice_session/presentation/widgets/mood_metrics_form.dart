import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tava/features/practice_session/domain/entities/mood_metrics.dart';
import 'package:tava/features/practice_session/presentation/bloc/practice_session_bloc.dart';

class MoodMetricsForm extends StatefulWidget {
  const MoodMetricsForm({super.key});

  @override
  State<MoodMetricsForm> createState() => _MoodMetricsFormState();
}

class _MoodMetricsFormState extends State<MoodMetricsForm> {
  int _energyLevel = 3;
  int _focusLevel = 3;
  int _sleepQuality = 3;
  bool _hadAlcohol = false;
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'How did you feel during practice?',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 24),
          _buildSlider(
            label: 'Energy Level',
            value: _energyLevel,
            onChanged: (value) {
              setState(() {
                _energyLevel = value;
              });
            },
          ),
          const SizedBox(height: 16),
          _buildSlider(
            label: 'Focus Level',
            value: _focusLevel,
            onChanged: (value) {
              setState(() {
                _focusLevel = value;
              });
            },
          ),
          const SizedBox(height: 16),
          _buildSlider(
            label: 'Sleep Quality',
            value: _sleepQuality,
            onChanged: (value) {
              setState(() {
                _sleepQuality = value;
              });
            },
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Had alcohol in the last 24 hours?'),
            value: _hadAlcohol,
            onChanged: (value) {
              setState(() {
                _hadAlcohol = value;
              });
            },
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _notesController,
            decoration: const InputDecoration(
              labelText: 'Notes (optional)',
              hintText: 'Any additional observations',
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 16),
              FilledButton(
                onPressed: _saveMoodMetrics,
                child: const Text('Save & End Session'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSlider({
    required String label,
    required int value,
    required ValueChanged<int> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        Row(
          children: [
            const Text('Low'),
            Expanded(
              child: Slider(
                value: value.toDouble(),
                min: 1,
                max: 5,
                divisions: 4,
                onChanged: (newValue) => onChanged(newValue.toInt()),
              ),
            ),
            const Text('High'),
          ],
        ),
      ],
    );
  }

  void _saveMoodMetrics() {
    final moodMetrics = MoodMetrics(
      energyLevel: _energyLevel,
      focusLevel: _focusLevel,
      sleepQuality: _sleepQuality,
      hadAlcohol: _hadAlcohol,
      notes: _notesController.text.isEmpty ? null : _notesController.text,
    );

    context.read<PracticeSessionBloc>().add(AddMoodMetrics(moodMetrics));
    context.read<PracticeSessionBloc>().add(EndSession());
    Navigator.of(context).pop();
  }
}