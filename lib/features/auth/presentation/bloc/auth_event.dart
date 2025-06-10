part of 'auth_bloc.dart';

/// Base class for authentication events in the application.
abstract class AuthEvent extends Equatable {
  /// Constructor for the AuthEvent class.
  const AuthEvent();

  @override
  List<Object> get props => [];
}

/// Event to check the current authentication status of the user.
class CheckAuthStatus extends AuthEvent {}

/// Event to request user login with email and password.
class LoginRequested extends AuthEvent {

  /// Creates an instance of LoginRequested with the
  /// provided email and password.
  const LoginRequested({
    required this.email,
    required this.password,
  });
  /// Email address of the user attempting to log in.
  final String email;
  /// Password of the user attempting to log in.
  final String password;

  @override
  List<Object> get props => [email, password];
}

/// Event to request user logout.
class LogoutRequested extends AuthEvent {}

/// Event to request user registration with email, password, and name.
class RegisterRequested extends AuthEvent {

  /// Creates an instance of RegisterRequested
  /// with the provided email, password, and name.
  const RegisterRequested({
    required this.email,
    required this.password,
    required this.name,
  });
  /// Email address of the user attempting to register.
  final String email;
  /// Password of the user attempting to register.
  final String password;
  /// Name of the user attempting to register.
  final String name;

  @override
  List<Object> get props => [email, password, name];
}
