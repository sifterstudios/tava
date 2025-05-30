import 'package:equatable/equatable.dart';
import 'package:tava/core/utils/either.dart';

abstract class UseCase<Type, Params> {
  FutureEitherResult<Type> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}