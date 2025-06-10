import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tava/core/di/injection.dart';
import 'package:tava/features/exercise_library/domain/entities/exercise.dart';
import 'package:tava/features/exercise_library/presentation/bloc/exercise_library_bloc.dart';
import 'package:tava/features/practice_session/presentation/bloc/practice_session_bloc.dart';

class ExerciseSelector extends StatefulWidget {
  const ExerciseSelector({super.key});

  @override
  State<ExerciseSelector> createState() => _ExerciseSelectorState();
}

class _ExerciseSelectorState extends State<ExerciseSelector> {
  String? _searchQuery;
  ExerciseCategory? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (_) => getIt<ExerciseLibraryBloc>()..add(LoadExercises()),
      child: DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Text(
                        'Select Exercise',
                        style: theme.textTheme.titleLarge,
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search exercises',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value.isEmpty ? null : value;
                      });
                      context
                          .read<ExerciseLibraryBloc>()
                          .add(SearchExercises(value));
                    },
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 48,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: ExerciseCategory.values.length + 1, // +1 for "All" tab
                    itemBuilder: (context, index) {
                      final isSelected = index == 0
                          ? _selectedCategory == null
                          : _selectedCategory ==
                              ExerciseCategory.values[index - 1];

                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(
                            index == 0
                                ? 'All'
                                : _getCategoryName(
                                    ExerciseCategory.values[index - 1],),
                          ),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedCategory = index == 0
                                    ? null
                                    : ExerciseCategory.values[index - 1];
                              });
                              context.read<ExerciseLibraryBloc>().add(
                                    FilterByCategory(
                                      index == 0
                                          ? null
                                          : ExerciseCategory.values[index - 1],
                                    ),
                                  );
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: BlocBuilder<ExerciseLibraryBloc, ExerciseLibraryState>(
                    builder: (context, state) {
                      if (state.status == ExerciseLibraryStatus.loading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state.filteredExercises.isEmpty) {
                        return Center(
                          child: Text(
                            'No exercises found',
                            style: theme.textTheme.titleMedium,
                          ),
                        );
                      }

                      return ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: state.filteredExercises.length,
                        itemBuilder: (context, index) {
                          final exercise = state.filteredExercises[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              title: Text(exercise.name),
                              subtitle: Text(
                                exercise.description ??
                                    _getCategoryName(exercise.category),
                              ),
                              leading: Icon(
                                _getCategoryIcon(exercise.category),
                                color: theme.colorScheme.primary,
                              ),
                              trailing: exercise.targetBpm != null
                                  ? Text('${exercise.targetBpm} BPM')
                                  : null,
                              onTap: () {
                                context
                                    .read<PracticeSessionBloc>()
                                    .add(StartExercise(exercise));
                                Navigator.of(context).pop();
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
          );
        },
      ),
    );
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

  IconData _getCategoryIcon(ExerciseCategory category) {
    switch (category) {
      case ExerciseCategory.technique:
        return Icons.fitness_center;
      case ExerciseCategory.repertoire:
        return Icons.music_note;
      case ExerciseCategory.scales:
        return Icons.piano;
      case ExerciseCategory.etudes:
        return Icons.school;
      case ExerciseCategory.sightReading:
        return Icons.visibility;
      case ExerciseCategory.improvisation:
        return Icons.psychology;
      case ExerciseCategory.other:
        return Icons.category;
    }
  }
}