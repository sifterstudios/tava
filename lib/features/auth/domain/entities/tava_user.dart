import 'package:equatable/equatable.dart';

/// User entity representing a Tava user.
class TavaUser extends Equatable {

  /// Creates a new instance of [TavaUser].
  const TavaUser({
    required this.id,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
    this.name,
  });
  /// Unique identifier for the user
  final String id;

  /// Email address of the user
  final String email;

  /// Optional name of the user
  final String? name;

  /// Date and time when the user was created
  final DateTime createdAt;

  /// Date and time when the user was last updated
  final DateTime updatedAt;

  @override
  List<Object?> get props => [id, email, name, createdAt, updatedAt];
}
