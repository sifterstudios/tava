import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tava/core/di/injection.dart';
import 'package:tava/features/exercise_library/domain/entities/exercise.dart';
import 'package:tava/features/exercise_library/presentation/bloc/exercise_library_bloc.dart';
import 'package:tava/features/exercise_library/presentation/widgets/exercise_form.dart';
import 'package:tava/features/practice_session/domain/entities/exercise_category.dart';

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
        title: const Text('Exercise Library'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implement search
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'categories') {
                _showCategoriesDialog(context);
              } else if (value == 'tags') {
                _showTagsDialog(context);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'categories',
                child: Text('Filter by Category'),
              ),
              const PopupMenuItem(
                value: 'tags',
                child: Text('Filter by Tags'),
              ),
            ],
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

          // Get unique categories from exercises, filter out nulls to avoid null issues
          final categories = state.exercises
              .map((e) => e.category)
              .where((category) => category != null)
              .cast<ExerciseCategory>() // Cast to non-nullable type after filtering
              .toSet()
              .toList();

          return Column(
            children: [
              // Category tabs
              SizedBox(
                height: 48,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: categories.length + 1, // +1 for "All" tab
                  itemBuilder: (context, index) {
                    final isSelected = index == 0
                        ? state.selectedCategory == null
                        : state.selectedCategory?.id == categories[index - 1].id;

                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(
                          index == 0 ? 'All' : categories[index - 1].name,
                        ),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            context.read<ExerciseLibraryBloc>().add(
                                  FilterByCategory(
                                    index == 0 ? null : categories[index - 1],
                                  ),
                                );
                          }
                        },
                      ),
                    );
                  },
                ),
              ),

              // Exercise list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showExerciseForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showExerciseForm(BuildContext context, [Exercise? exercise]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: ExerciseForm(exercise: exercise),
      ),
    );
  }

  void _showCategoriesDialog(BuildContext context) {
    final bloc = context.read<ExerciseLibraryBloc>();
    // Get unique categories from all exercises, filter out nulls
    final List<ExerciseCategory> categories = bloc.state.exercises
        .map((e) => e.category)
        .whereType<ExerciseCategory>() // Use whereType instead of where + cast
        .toSet()
        .toList();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter by Category'),
        content: categories.isEmpty
            ? const Text('No categories available')
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: categories
                    .map(
                      (category) => ListTile(
                        title: Text(category.name),
                        onTap: () {
                          bloc.add(FilterByCategory(category));
                          Navigator.of(context).pop();
                        },
                      ),
                    )
                    .toList(),
              ),
        actions: [
          TextButton(
            onPressed: () {
              // Remove const to fix lint warning with null parameter
              bloc.add(FilterByCategory(null));
              Navigator.of(context).pop();
            },
            child: const Text('Show All'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showTagsDialog(BuildContext context) {
    // Implement tags dialog
  }
}

class ExerciseCard extends StatelessWidget {
  final Exercise exercise;
  final VoidCallback onEdit;
  final VoidCallback onToggleFavorite;

  const ExerciseCard({
    super.key,
    required this.exercise,
    required this.onEdit,
    required this.onToggleFavorite,
  });

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
                if (exercise.category != null)
                  Chip(
                    label: Text(exercise.category!.name),
                    backgroundColor: _getCategoryColor(exercise.category, theme),
                  )
                else
                  Chip(
                    label: const Text('Uncategorized'),
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

  Color _getCategoryColor(ExerciseCategory? category, ThemeData theme) {
    // Simplify the null checking and color parsing
    if (category != null && category.color != null) {
      try {
        // Use a safe parse approach
        final colorString = category.color!.replaceFirst('#', '');
        final colorValue = int.tryParse('0xFF$colorString');
        if (colorValue != null) {
          return Color(colorValue);
        }
      } catch (_) {
        // Silently handle parsing errors and return default color
      }
    }
    return theme.colorScheme.primaryContainer;
  }
}