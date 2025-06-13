part of 'dashboard_bloc.dart';

/// Base class for dashboard events in the application.
abstract class DashboardEvent extends Equatable {
  /// Constructor for the DashboardEvent class.
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

/// Event to load the dashboard data.
class LoadDashboardData extends DashboardEvent {}
