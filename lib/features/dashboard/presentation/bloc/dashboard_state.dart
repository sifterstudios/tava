part of 'dashboard_bloc.dart';

enum DashboardStatus { initial, loading, success, failure }

class DashboardState extends Equatable {
  final DashboardStatus status;
  final PracticeSession? activeSession;
  final List<PracticeSession> recentSessions;
  final PracticeStats? practiceStats;
  final List<Exercise> suggestedExercises;
  final WeatherInfo? weatherInfo;
  final String? errorMessage;

  const DashboardState({
    required this.status,
    this.activeSession,
    required this.recentSessions,
    this.practiceStats,
    required this.suggestedExercises,
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

  DashboardState copyWith({
    DashboardStatus? status,
    PracticeSession? activeSession,
    List<PracticeSession>? recentSessions,
    PracticeStats? practiceStats,
    List<Exercise>? suggestedExercises,
    WeatherInfo? weatherInfo,
    String? errorMessage,
  }) {
    return DashboardState(
      status: status ?? this.status,
      activeSession: activeSession,
      recentSessions: recentSessions ?? this.recentSessions,
      practiceStats: practiceStats ?? this.practiceStats,
      suggestedExercises: suggestedExercises ?? this.suggestedExercises,
      weatherInfo: weatherInfo ?? this.weatherInfo,
      errorMessage: errorMessage ?? this.errorMessage,
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