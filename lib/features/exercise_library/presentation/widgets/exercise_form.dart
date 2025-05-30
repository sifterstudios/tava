import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tava/core/di/injection.dart';
import 'package:tava/features/exercise_library/domain/entities/exercise.dart';
import 'package:tava/features/exercise_library/presentation/bloc/exercise_library_bloc.dart';
import 'package:uuid/uuid.dart';

class ExerciseForm extends StatefulWidget {
  final Exercise? exercise;

  const ExerciseForm({super.key, this.exercise});

  @override
  State<ExerciseForm> createState() => _ExerciseFormState();
}

class _ExerciseFormState extends State<ExerciseForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _bpmController = TextEditingController();
  final _tagsController = TextEditingController();
  
  ExerciseCategory _category = ExerciseCategory.technique;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    
    if (widget.exercise != null) {
      _nameController.text = widget.exercise!.name;
      _descriptionController.text = widget.exercise!.description ?? '';
      _bpmController.text = widget.exercise!.targetBpm?.toString() ?? '';
      _tagsController.text = widget.exercise!.tags.join(', ');
      _category = widget.exercise!.category;
      _isFavorite = widget.exercise!.isFavorite;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _bpmController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditing = widget.exercise != null;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              isEditing ? 'Edit Exercise' : 'Add Exercise',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: 'Enter exercise name',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                hintText: 'Enter exercise description',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<ExerciseCategory>(
              value: _category,
              decoration: const InputDecoration(
                labelText: 'Category',
              ),
              items: ExerciseCategory.values.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(_getCategoryName(category)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _category = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _bpmController,
              decoration: const InputDecoration(
                labelText: 'Target BPM (optional)',
                hintText: 'Enter target BPM',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _tagsController,
              decoration: const InputDecoration(
                labelText: 'Tags (comma separated)',
                hintText: 'e.g., scales, beginner, technique',
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Favorite'),
              value: _isFavorite,
              onChanged: (value) {
                setState(() {
                  _isFavorite = value;
                });
              },
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
                  onPressed: _saveExercise,
                  child: Text(isEditing ? 'Update' : 'Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _saveExercise() {
    if (_formKey.currentState!.validate()) {
      final tags = _tagsController.text
          .split(',')
          .map((tag) => tag.trim())
          .where((tag) => tag.isNotEmpty)
          .toList();

      int? targetBpm;
      if (_bpmController.text.isNotEmpty) {
        targetBpm = int.tryParse(_bpmController.text);
      }

      final exercise = widget.exercise != null
          ? widget.exercise!.copyWith(
              name: _nameController.text,
              description: _descriptionController.text.isEmpty
                  ? null
                  : _descriptionController.text,
              category: _category,
              targetBpm: targetBpm,
              tags: tags,
              isFavorite: _isFavorite,
              updatedAt: DateTime.now(),
            )
          : Exercise(
              id: const Uuid().v4(),
              name: _nameController.text,
              description: _descriptionController.text.isEmpty
                  ? null
                  : _descriptionController.text,
              category: _category,
              targetBpm: targetBpm,
              tags: tags,
              isFavorite: _isFavorite,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              isArchived: false,
            );

      if (widget.exercise != null) {
        context.read<ExerciseLibraryBloc>().add(UpdateExercise(exercise));
      } else {
        context.read<ExerciseLibraryBloc>().add(AddExercise(exercise));
      }

      Navigator.of(context).pop();
    }
  }

  String _getCategoryName(ExerciseCategory category) {
    switch (category) {
      case ExerciseCategory.technique:
        return 'Technique';
      case ExerciseCategory.repertoire:
        return 'Repertoire';
      case ExerciseCategory.scales:
        return 'Scales';
      case ExerciseCategory.etudes:
        return 'Etudes';
      case ExerciseCategory.sightReading:
        return 'Sight Reading';
      case ExerciseCategory.improvisation:
        return 'Improvisation';
      case ExerciseCategory.other:
        return 'Other';
    }
  }
}