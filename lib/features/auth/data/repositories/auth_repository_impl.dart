import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:tava/core/error/failures.dart';
import 'package:tava/core/utils/either.dart';
import 'package:tava/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:tava/features/auth/domain/entities/tava_user.dart';
import 'package:tava/features/auth/domain/repositories/auth_repository.dart';

/// Implementation of [AuthRepository] that interacts with the
/// remote data source for authentication operations.
@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  /// Constructor for [AuthRepositoryImpl].
  AuthRepositoryImpl({required this.remoteDataSource});

  /// Creates an instance of [AuthRepositoryImpl].
  final AuthRemoteDataSource remoteDataSource;

  @override
  FutureEitherResult<TavaUser> getCurrentUser() async {
    try {
      final user = await remoteDataSource.getCurrentUser();
      return Right(user);
    } on Failure catch (failure) {
      return Left(failure);
    } on Exception catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  FutureEitherResult<TavaUser> login(
      {required String email, required String password}) async {
    try {
      final user =
          await remoteDataSource.login(email: email, password: password);
      return Right(user);
    } on Failure catch (failure) {
      return Left(failure);
    } on Exception catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  FutureEitherResult<TavaUser> register(
      {required String email,
      required String password,
      required String name}) async {
    try {
      final user = await remoteDataSource.register(
          email: email, password: password, name: name);
      return Right(user);
    } on Failure catch (failure) {
      return Left(failure);
    } on Exception catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  FutureEitherUnit logout() async {
    try {
      await remoteDataSource.logout();
      return const Right(unit);
    } on Failure catch (failure) {
      return Left(failure);
    } on Exception catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }
}
