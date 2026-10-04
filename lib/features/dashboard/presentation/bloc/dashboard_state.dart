part of 'dashboard_bloc.dart';

enum DashboardStatus { initial, loading, success, failure }

class DashboardState extends Equatable {
  const DashboardState({
    required this.status,
    required this.recentSessions,
    required this.suggestedExercises,
    this.activeSession,
    this.practiceStats,
    this.weatherInfo,
    this.errorMessage,
  });

  const DashboardState.initial()
      : status = DashboardStatus.initial,
        activeSession = null,
        recentSessions = const [],
        practiceStats = null,
        suggestedExercises = const [],
        weatherInfo = null,
        errorMessage = null;

  static const Object _unset = Object();

  final DashboardStatus status;
  final PracticeSession? activeSession;
  final List<PracticeSession> recentSessions;
  final PracticeStats? practiceStats;
  final List<Exercise> suggestedExercises;
  final WeatherInfo? weatherInfo;
  final String? errorMessage;

  DashboardState copyWith({
    DashboardStatus? status,
    Object? activeSession = _unset,
    List<PracticeSession>? recentSessions,
    PracticeStats? practiceStats,
    List<Exercise>? suggestedExercises,
    Object? weatherInfo = _unset,
    Object? errorMessage = _unset,
  }) {
    return DashboardState(
      status: status ?? this.status,
      activeSession: identical(activeSession, _unset)
          ? this.activeSession
          : activeSession as PracticeSession?,
      recentSessions: recentSessions ?? this.recentSessions,
      practiceStats: practiceStats ?? this.practiceStats,
      suggestedExercises: suggestedExercises ?? this.suggestedExercises,
      weatherInfo: identical(weatherInfo, _unset)
          ? this.weatherInfo
          : weatherInfo as WeatherInfo?,
      errorMessage: identical(errorMessage, _unset)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  @override
  List<Object?> get props => [
        status,
        activeSession,
        recentSessions,
        practiceStats,
        suggestedExercises,
        weatherInfo,
        errorMessage,
      ];
}
