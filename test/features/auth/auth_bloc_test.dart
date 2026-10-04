import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tava/core/error/failures.dart';
import 'package:tava/features/auth/domain/entities/user.dart';
import 'package:tava/features/auth/domain/usecases/check_auth.dart';
import 'package:tava/features/auth/domain/usecases/login_user.dart';
import 'package:tava/features/auth/domain/usecases/logout_user.dart';
import 'package:tava/features/auth/domain/usecases/register_user.dart';
import 'package:tava/features/auth/presentation/bloc/auth_bloc.dart';

class _MockCheckAuth extends Mock implements CheckAuth {}

class _MockLoginUser extends Mock implements LoginUser {}

class _MockLogoutUser extends Mock implements LogoutUser {}

class _MockRegisterUser extends Mock implements RegisterUser {}

void main() {
  late _MockCheckAuth checkAuth;
  late _MockLoginUser loginUser;
  late _MockLogoutUser logoutUser;
  late _MockRegisterUser registerUser;

  final user = User(
    id: '1',
    email: 'a@b.com',
    name: 'Ada',
    createdAt: DateTime(2026),
    updatedAt: DateTime(2026),
  );

  setUpAll(() {
    registerFallbackValue(
      const LoginParams(email: 'fallback@tava.app', password: 'password'),
    );
  });

  setUp(() {
    checkAuth = _MockCheckAuth();
    loginUser = _MockLoginUser();
    logoutUser = _MockLogoutUser();
    registerUser = _MockRegisterUser();
  });

  AuthBloc buildBloc() => AuthBloc(
        checkAuth: checkAuth,
        loginUser: loginUser,
        logoutUser: logoutUser,
        registerUser: registerUser,
      );

  group('AuthBloc', () {
    blocTest<AuthBloc, AuthState>(
      'emits authenticated when check succeeds',
      build: buildBloc,
      setUp: () {
        when(() => checkAuth()).thenAnswer((_) async => Right(user));
      },
      act: (bloc) => bloc.add(CheckAuthStatus()),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthAuthenticated>().having((s) => s.user.email, 'email', 'a@b.com'),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits unauthenticated when check fails',
      build: buildBloc,
      setUp: () {
        when(() => checkAuth()).thenAnswer(
          (_) async => const Left(AuthFailure(message: 'none')),
        );
      },
      act: (bloc) => bloc.add(CheckAuthStatus()),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthUnauthenticated>(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits error on failed login',
      build: buildBloc,
      setUp: () {
        when(
          () => loginUser(any()),
        ).thenAnswer(
          (_) async => const Left(AuthFailure(message: 'bad creds')),
        );
      },
      act: (bloc) => bloc.add(
        const LoginRequested(email: 'a@b.com', password: 'secret'),
      ),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthError>().having((s) => s.message, 'message', 'bad creds'),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits unauthenticated after logout',
      build: buildBloc,
      setUp: () {
        when(() => logoutUser()).thenAnswer((_) async => const Right(unit));
      },
      act: (bloc) => bloc.add(LogoutRequested()),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthUnauthenticated>(),
      ],
    );
  });
}
