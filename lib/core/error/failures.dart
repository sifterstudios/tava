/// Base class for all failures in the application.
abstract class Failure implements Exception {
  /// Creates a [Failure] with the given [message].
  const Failure({required this.message});

  /// The error message associated with the failure.
  final String message;

  /// Override the equality operator to compare failures by their message.
  List<Object> get props => [message];
}

/// Failure for server-related issues.
class ServerFailure extends Failure {
  /// Creates a [ServerFailure] with the given [message].
  const ServerFailure({required super.message});
}

/// Failure for cache-related issues.
class CacheFailure extends Failure {
  /// Creates a [CacheFailure] with the given [message].
  const CacheFailure({required super.message});
}

/// Failure for network-related issues.
class NetworkFailure extends Failure {
  /// Creates a [NetworkFailure] with the given [message].
  const NetworkFailure({required super.message});
}

/// Failure for authentication-related issues.
class AuthFailure extends Failure {
  /// Creates an [AuthFailure] with the given [message].
  const AuthFailure({required super.message});
}

/// Failure for validation-related issues, containing a map of errors.
class ValidationFailure extends Failure {
  /// Creates a [ValidationFailure] with the given [message] and [errors].
  const ValidationFailure({
    required super.message,
    required this.errors,
  });

  /// A map of validation errors, where the key is the field name and
  /// the value is the error message.
  final Map<String, String> errors;

  @override
  List<Object> get props => [message, errors];
}

/// Failure for unexpected issues that do not fit into other categories.
class UnexpectedFailure extends Failure {
  /// Creates an [UnexpectedFailure] with the given [message].
  const UnexpectedFailure({required super.message});
}
