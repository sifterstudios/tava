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
    final colors = theme.colorScheme;

    return BlocConsumer<PracticeSessionBloc, PracticeSessionState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == PracticeSessionStatus.saved) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Practice session saved'),
              behavior: SnackBarBehavior.floating,
            ),
          );
          context.go('/dashboard');
        }
      },
      builder: (context, state) {
        if (state.status == PracticeSessionStatus.loading) {
          return Scaffold(
            appBar: AppBar(title: const Text('Practice session')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state.status == PracticeSessionStatus.failure) {
          return Scaffold(
            appBar: AppBar(title: const Text('Practice session')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Could not start session',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => context
                        .read<PracticeSessionBloc>()
                        .add(LoadPracticeSession()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Practice session'),
            actions: [
              TextButton.icon(
                onPressed: state.session == null
                    ? null
                    : () => _showEndSessionDialog(context),
                icon: const Icon(Icons.stop_circle_outlined),
                label: const Text('End'),
              ),
            ],
          ),
          body: Column(
            children: [
              Container(
                width: double.infinity,
                color: colors.primaryContainer,
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 16,
                ),
                child: Column(
                  children: [
                    const SessionTimer(),
                    const SizedBox(height: 16),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 12,
                      runSpacing: 8,
                      children: [
                        if (state.isRunning)
                          FilledButton.tonalIcon(
                            onPressed: () => context
                                .read<PracticeSessionBloc>()
                                .add(PauseSession()),
                            icon: const Icon(Icons.pause_rounded),
                            label: const Text('Pause'),
                          )
                        else
                          FilledButton.icon(
                            onPressed: () => context
                                .read<PracticeSessionBloc>()
                                .add(ResumeSession()),
                            icon: const Icon(Icons.play_arrow_rounded),
                            label: const Text('Resume'),
                          ),
                        OutlinedButton.icon(
                          onPressed: () => _showExerciseSelector(context),
                          icon: const Icon(Icons.add_rounded),
                          label: const Text('Add exercise'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (state.currentExercise != null)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current exercise',
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Completed exercises',
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: state.completedExercises.isEmpty
                            ? Center(
                                child: Text(
                                  'No exercises completed yet',
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: colors.onSurfaceVariant,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                itemCount: state.completedExercises.length,
                                itemBuilder: (context, index) {
                                  final exercise =
                                      state.completedExercises[index];
                                  return ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Text(
                                      exercise.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    subtitle: Text(
                                      'Duration: '
                                      '${_formatDuration(exercise.duration)}'
                                      '${exercise.bpm != null ? ' · ${exercise.bpm} BPM' : ''}',
                                    ),
                                    trailing: exercise.rating != null
                                        ? Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: List.generate(
                                              5,
                                              (i) => Icon(
                                                i < exercise.rating!
                                                    ? Icons.star_rounded
                                                    : Icons.star_border_rounded,
                                                color: colors.primary,
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
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Start exercise'),
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
    final bloc = context.read<PracticeSessionBloc>();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => BlocProvider.value(
        value: bloc,
        child: const ExerciseSelector(),
      ),
    );
  }

  void _showEndSessionDialog(BuildContext context) {
    final bloc = context.read<PracticeSessionBloc>();
    showDialog<void>(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: bloc,
        child: AlertDialog(
          title: const Text('End practice session'),
          content: const Text(
            'Add mood and wellness notes before ending, or finish now.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _showMoodMetricsForm(context);
              },
              child: const Text('Add metrics'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                bloc.add(EndSession());
              },
              child: const Text('End now'),
            ),
          ],
        ),
      ),
    );
  }

  void _showMoodMetricsForm(BuildContext context) {
    final bloc = context.read<PracticeSessionBloc>();
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
          child: const MoodMetricsForm(),
        ),
      ),
    );
  }
}
