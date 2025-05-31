import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:tava/core/utils/either.dart';
import 'package:tava/features/practice_session/domain/entities/practice_session.dart';
import 'package:tava/features/practice_session/domain/entities/weather_info.dart';
import 'package:tava/features/practice_session/domain/usecases/get_active_session.dart';

@LazySingleton(as: PracticeSessionRepository)
class MockPracticeSessionRepository implements PracticeSessionRepository {
  @override
  FutureEitherResult<PracticeSession?> getActiveSession() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // For demo purposes, return null (no active session)
    return const Right(null);
  }
}