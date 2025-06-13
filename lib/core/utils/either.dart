import 'package:fpdart/fpdart.dart';
import 'package:tava/core/error/failures.dart';

/// A type alias for a function that returns a [Future] of [Either] containing
/// a [Failure] or a value of type [T].
typedef EitherResult<T> = Either<Failure, T>;

/// A type alias for a function that returns a [Future] of [Either] containing
/// a [Failure] or a value of type [T].
typedef FutureEitherResult<T> = Future<Either<Failure, T>>;

/// A type alias for a function that returns a [Future] of [Either] containing
/// a [Failure] or a [Unit].
typedef EitherUnit = Either<Failure, Unit>;

/// A type alias for a function that returns a [Future] of [Either] containing
/// a [Failure] or a [Unit].
typedef FutureEitherUnit = Future<Either<Failure, Unit>>;
