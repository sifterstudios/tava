import 'package:equatable/equatable.dart';
import 'package:tava/core/utils/either.dart';

/// A base class for use cases in the application.
abstract class UseCase<Type, Params> {
  /// Executes the use case with the given parameters.
  FutureEitherResult<Type> call(Params params);
}

/// A use case that does not require any parameters.
class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
