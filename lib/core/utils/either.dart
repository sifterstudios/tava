import 'package:fpdart/fpdart.dart';
import 'package:tava/core/error/failures.dart';

typedef EitherResult<T> = Either<Failure, T>;
typedef FutureEitherResult<T> = Future<Either<Failure, T>>;
typedef EitherUnit = Either<Failure, Unit>;
typedef FutureEitherUnit = Future<Either<Failure, Unit>>;