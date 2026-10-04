import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tava/core/di/injection.dart';
import 'package:tava/features/exercise_library/domain/entities/exercise.dart';
import 'package:tava/features/exercise_library/presentation/bloc/exercise_library_bloc.dart';
import 'package:tava/features/exercise_library/presentation/widgets/exercise_form.dart';

class ExerciseLibraryPage extends StatelessWidget {
  const ExerciseLibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ExerciseLibraryBloc>()..add(LoadExercises()),
      child: const ExerciseLibraryView(),
    );
  }
}

class ExerciseLibraryView extends StatelessWidget {
  const ExerciseLibraryView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise library'),
        actions: [
          IconButton(
            tooltip: 'Search',
            icon: const Icon(Icons.search_rounded),
            onPressed: () => _showSearchDialog(context),
          ),
        ],
      ),
      body: BlocBuilder<ExerciseLibraryBloc, ExerciseLibraryState>(
        builder: (context, state) {
          if (state.status == ExerciseLibraryStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == ExerciseLibraryStatus.failure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Failed to load exercises',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<ExerciseLibraryBloc>()
                      ..add(LoadExercises()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state.exercises.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.library_music, size: 64),
                  const SizedBox(height: 16),
                  Text(
                    'No exercises yet',
                    style: theme.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add exercises to build your library',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => _showExerciseForm(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Exercise'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Category tabs
              SizedBox(
                height: 48,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: ExerciseCategory.values.length + 1, // +1 for "All" tab
                  itemBuilder: (context, index) {
                    final isSelected = index == 0
                        ? state.selectedCategory == null
                        : state.selectedCategory ==
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
                child: state.filteredExercises.isEmpty
                    ? Center(
                        child: Text(
                          'No exercises match this filter',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
                        itemCount: state.filteredExercises.length,
                        itemBuilder: (context, index) {
                          final exercise = state.filteredExercises[index];
                          return ExerciseCard(
                            exercise: exercise,
                            onEdit: () => _showExerciseForm(context, exercise),
                            onToggleFavorite: () => context
                                .read<ExerciseLibraryBloc>()
                                .add(ToggleExerciseFavorite(exercise)),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showExerciseForm(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add exercise'),
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

  void _showExerciseForm(BuildContext context, [Exercise? exercise]) {
    final bloc = context.read<ExerciseLibraryBloc>();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => BlocProvider.value(
        value: bloc,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
          ),
          child: ExerciseForm(exercise: exercise),
        ),
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    final bloc = context.read<ExerciseLibraryBloc>();
    final controller = TextEditingController(text: bloc.state.searchQuery);

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Search exercises'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Name, description, or tag',
            prefixIcon: Icon(Icons.search_rounded),
          ),
          textInputAction: TextInputAction.search,
          onSubmitted: (value) {
            bloc.add(SearchExercises(value.trim()));
            Navigator.of(dialogContext).pop();
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              bloc.add(const SearchExercises(''));
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Clear'),
          ),
          FilledButton(
            onPressed: () {
              bloc.add(SearchExercises(controller.text.trim()));
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Search'),
          ),
        ],
      ),
    ).whenComplete(controller.dispose);
  }
}

class ExerciseCard extends StatelessWidget {

  const ExerciseCard({
    required this.exercise, required this.onEdit, required this.onToggleFavorite, super.key,
  });
  final Exercise exercise;
  final VoidCallback onEdit;
  final VoidCallback onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    exercise.name,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    exercise.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: exercise.isFavorite ? Colors.redAccent : null,
                  ),
                  onPressed: onToggleFavorite,
                ),
              ],
            ),
            if (exercise.description != null) ...[
              const SizedBox(height: 8),
              Text(exercise.description!),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Chip(
                  label: Text(_getCategoryName(exercise.category)),
                  backgroundColor: theme.colorScheme.primaryContainer,
                ),
                const Spacer(),
                if (exercise.targetBpm != null)
                  Text('${exercise.targetBpm} BPM'),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: onEdit,
                ),
              ],
            ),
          ],
        ),
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
}