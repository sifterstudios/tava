part of 'auth_bloc.dart';

/// Base class for authentication states in the application.
abstract class AuthState extends Equatable {
  /// Constructor for the AuthState class.
  const AuthState();

  @override
  List<Object> get props => [];
}

/// Initial state of the authentication process.
class AuthInitial extends AuthState {}

/// Represents the loading state during authentication operations.
class AuthLoading extends AuthState {}

/// Represents the authenticated state with user information.
class AuthAuthenticated extends AuthState {
  /// Creates an instance of AuthAuthenticated with the provided user.
  const AuthAuthenticated({required this.user});

  /// The user object containing user details.
  final TavaUser user;

  @override
  List<Object> get props => [user];
}

/// Represents the unauthenticated state when the user is not logged in.
class AuthUnauthenticated extends AuthState {}

/// Represents an error state during authentication operations.
class AuthError extends AuthState {
  /// Creates an instance of AuthError with the provided error message.
  const AuthError({required this.message});

  /// The error message associated with the authentication error.
  final String message;

  @override
  List<Object> get props => [message];
}
