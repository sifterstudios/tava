part of 'dashboard_bloc.dart';

/// Enumeration representing the various states of the dashboard.
enum DashboardStatus {
  /// The initial state of the dashboard before any data is loaded.
  initial,

  /// The state when the dashboard is currently loading data.
  loading,

  /// The state when the dashboard has successfully loaded data.
  success,

  /// The state when there was an error loading the dashboard data.
  failure
}

/// Represents the state of the dashboard in the application.
class DashboardState extends Equatable {
  /// Creates an instance of [DashboardState] with the given parameters.
  const DashboardState({
    required this.status,
    required this.recentSessions,
    required this.suggestedExercises,
    this.activeSession,
    this.practiceStats,
    this.weatherInfo,
    this.errorMessage,
  });

  /// Creates an initial state of [DashboardState] with default values.
  const DashboardState.initial()
      : status = DashboardStatus.initial,
        activeSession = null,
        recentSessions = const [],
        practiceStats = null,
        suggestedExercises = const [],
        weatherInfo = null,
        errorMessage = null;

  /// Creates an instance of [DashboardState] with the given parameters.
  final DashboardStatus status;

  /// The currently active practice session, if any.
  final PracticeSession? activeSession;

  /// A list of recent practice sessions.
  final List<PracticeSession> recentSessions;

  /// Statistics related to practice, if available.
  final PracticeStats? practiceStats;

  /// A list of suggested exercises for the user.
  final List<Exercise> suggestedExercises;

  /// Weather information, if available.
  final WeatherInfo? weatherInfo;

  /// An error message, if any error occurred.
  final String? errorMessage;

  /// Creates a copy of the current [DashboardState] with updated values.
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
