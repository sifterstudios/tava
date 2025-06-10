import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:tava/core/error/failures.dart';
import 'package:tava/core/utils/either.dart';
import 'package:tava/features/auth/domain/entities/tava_user.dart';
import 'package:tava/features/auth/domain/repositories/auth_repository.dart';

@dev
@Injectable()
class MockAuthRepository implements AuthRepository {
  TavaUser? _currentUser;

  @override
  FutureEitherResult<TavaUser> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (_currentUser == null) {
      return Left(AuthFailure(message: 'No user logged in'));
    }
    
    return Right(_currentUser!);
  }

  @override
  FutureEitherResult<TavaUser> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Simple validation
    if (email.isEmpty || password.isEmpty) {
      return Left(AuthFailure(message: 'Email and password cannot be empty'));
    }
    
    // For demo purposes, accept any credentials
    _currentUser = TavaUser(
      id: 'user-123',
      email: email,
      name: email.split('@').first,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    return Right(_currentUser!);
  }

  @override
  FutureEitherResult<TavaUser> register({
    required String email,
    required String password,
    required String name,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    
    // Simple validation
    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      return Left(AuthFailure(message: 'All fields are required'));
    }
    
    // For demo purposes, accept any registration
    _currentUser = TavaUser(
      id: 'user-${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      name: name,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    return Right(_currentUser!);
  }

  @override
  FutureEitherUnit logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    _currentUser = null;
    
    return right(unit);
  }
}