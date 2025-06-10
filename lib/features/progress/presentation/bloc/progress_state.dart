part of 'progress_bloc.dart';

enum ProgressStatus { initial, loading, success, failure }

class ProgressState extends Equatable {

  const ProgressState({
    required this.status,
    this.practiceStats,
    this.errorMessage,
  });

  const ProgressState.initial()
      : status = ProgressStatus.initial,
        practiceStats = null,
        errorMessage = null;
  final ProgressStatus status;
  final PracticeStats? practiceStats;
  final String? errorMessage;

  ProgressState copyWith({
    ProgressStatus? status,
    PracticeStats? practiceStats,
    String? errorMessage,
  }) {
    return ProgressState(
      status: status ?? this.status,
      practiceStats: practiceStats ?? this.practiceStats,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, practiceStats, errorMessage];
}