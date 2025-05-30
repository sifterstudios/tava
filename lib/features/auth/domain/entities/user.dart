import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String? name;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
    this.name,
  });

  @override
  List<Object?> get props => [id, email, name, createdAt, updatedAt];
}
