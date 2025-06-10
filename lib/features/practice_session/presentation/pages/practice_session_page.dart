import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tava/core/di/injection.dart';
import 'package:tava/features/practice_session/presentation/bloc/practice_session_bloc.dart';
import 'package:tava/features/practice_session/presentation/widgets/active_exercise_card.dart';
import 'package:tava/features/practice_session/presentation/widgets/exercise_selector.dart';
import 'package:tava/features/practice_session/presentation/widgets/mood_metrics_form.dart';
import 'package:tava/features/practice_session/presentation/widgets/session_timer.dart';

class PracticeSessionPage extends StatelessWidget {
  const PracticeSessionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PracticeSessionBloc>()..add(LoadPracticeSession()),
      child: const PracticeSessionView(),
    );
  }
}

class PracticeSessionView extends StatelessWidget {
  const PracticeSessionView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<PracticeSessionBloc, PracticeSessionState>(
      listenWhen: (previous, current) =>
      previous.status != current.status,
      listener: (context, state) {
        if (state.status == PracticeSessionStatus.saved) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Practice session saved successfully'),
              behavior: SnackBarBehavior.floating,
            ),
          );
          context.go('/dashboard');
        }
      },
      builder: (context, state) {
        if (state.status == PracticeSessionStatus.loading) {
          return Scaffold(
            appBar: AppBar(title: const Text('Practice Session')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state.status == PracticeSessionStatus.failure) {
          return Scaffold(
            appBar: AppBar(title: const Text('Practice Session')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Failed to load session',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<PracticeSessionBloc>()
                      ..add(LoadPracticeSession()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Practice Session'),
            actions: [
              TextButton.icon(
                onPressed: state.session == null
                    ? null
                    : () => _showEndSessionDialog(context),
                icon: const Icon(Icons.save),
                label: const Text('End Session'),
              ),
            ],
          ),
          body: Column(
            children: [
              // Timer section
              Container(
                color: theme.colorScheme.primaryContainer,
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 16,
                ),
                child: Column(
                  children: [
                    const SessionTimer(),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (state.isRunning)
                          ElevatedButton.icon(
                            onPressed: () => context
                                .read<PracticeSessionBloc>()
                                .add(PauseSession()),
                            icon: const Icon(Icons.pause),
                            label: const Text('Pause'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.error,
                              foregroundColor: theme.colorScheme.onError,
                            ),
                          )
                        else
                          ElevatedButton.icon(
                            onPressed: () => context
                                .read<PracticeSessionBloc>()
                                .add(ResumeSession()),
                            icon: const Icon(Icons.play_arrow),
                            label: const Text('Resume'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: theme.colorScheme.onPrimary,
                            ),
                          ),
                        const SizedBox(width: 16),
                        OutlinedButton.icon(
                          onPressed: () => _showExerciseSelector(context),
                          icon: const Icon(Icons.add),
                          label: const Text('Add Exercise'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Active exercise (if any)
              if (state.currentExercise != null) ...[
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Exercise',
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      ActiveExerciseCard(
                        exercise: state.currentExercise!,
                        onComplete: () => context
                            .read<PracticeSessionBloc>()
                            .add(const CompleteExercise()),
                      ),
                    ],
                  ),
                ),
              ],

              // Exercise list
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Completed Exercises',
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: state.completedExercises.isEmpty
                            ? Center(
                          child: Text(
                            'No exercises completed yet',
                            style: theme.textTheme.bodyLarge,
                          ),
                        )
                            : ListView.builder(
                          itemCount: state.completedExercises.length,
                          itemBuilder: (context, index) {
                            final exercise =
                            state.completedExercises[index];
                            return ListTile(
                              title: Text(exercise.name),
                              subtitle: Text(
                                'Duration: ${_formatDuration(exercise.duration)}${exercise.bpm != null
                                        ? ' • ${exercise.bpm} BPM'
                                        : ''}',
                              ),
                              trailing: exercise.rating != null
                                  ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: List.generate(
                                  5,
                                      (i) => Icon(
                                    i < exercise.rating!
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: theme.colorScheme.primary,
                                    size: 18,
                                  ),
                                ),
                              )
                                  : null,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: state.currentExercise == null
              ? FloatingActionButton.extended(
            onPressed: () => _showExerciseSelector(context),
            icon: const Icon(Icons.add),
            label: const Text('Start Exercise'),
          )
              : null,
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  void _showExerciseSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const ExerciseSelector(),
    );
  }

  void _showEndSessionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('End Practice Session'),
        content: const Text(
            'Would you like to add mood and wellness metrics before ending?',),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showMoodMetricsForm(context);
            },
            child: const Text('Add Metrics'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<PracticeSessionBloc>().add(EndSession());
            },
            child: const Text('End Without Metrics'),
          ),
        ],
      ),
    );
  }

  void _showMoodMetricsForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: const MoodMetricsForm(),
      ),
    );
  }
}