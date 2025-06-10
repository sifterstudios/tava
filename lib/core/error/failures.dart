import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {

  const Failure({required this.message});
  final String message;

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message});
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

class NetworkFailure extends Failure {
  const NetworkFailure({required super.message});
}

class AuthFailure extends Failure {
  const AuthFailure({required super.message});
}

class ValidationFailure extends Failure {

  const ValidationFailure({
    required super.message,
    required this.errors,
  });
  final Map<String, String> errors;

  @override
  List<Object> get props => [message, errors];
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure({required super.message});
}
