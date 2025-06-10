import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:tava/core/usecase/usecase.dart';
import 'package:tava/features/progress/domain/entities/practice_stats.dart';
import 'package:tava/features/progress/domain/usecases/get_practice_stats.dart';

part 'progress_event.dart';
part 'progress_state.dart';

@injectable
class ProgressBloc extends Bloc<ProgressEvent, ProgressState> {

  ProgressBloc({
    required GetPracticeStats getPracticeStats,
  })  : _getPracticeStats = getPracticeStats,
        super(const ProgressState.initial()) {
    on<LoadProgressData>(_onLoadProgressData);
  }
  final GetPracticeStats _getPracticeStats;

  Future<void> _onLoadProgressData(
    LoadProgressData event,
    Emitter<ProgressState> emit,
  ) async {
    emit(state.copyWith(status: ProgressStatus.loading));

    final result = await _getPracticeStats(NoParams());

    result.fold(
      (failure) => emit(state.copyWith(
        status: ProgressStatus.failure,
        errorMessage: failure.message,
      ),),
      (stats) => emit(state.copyWith(
        status: ProgressStatus.success,
        practiceStats: stats,
      ),),
    );
  }
}