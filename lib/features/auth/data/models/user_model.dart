import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tava/features/auth/domain/entities/tava_user.dart';

/// Represents a user in the Tava application.
class UserModel extends TavaUser {
  /// Creates a new instance of [UserModel].
  const UserModel({
    required super.id,
    required super.email,
    required super.createdAt,
    required super.updatedAt,
    super.name,
  });

  /// Creates a new instance of [UserModel] from a Supabase user.
  factory UserModel.fromSupabaseUser(User supabaseUser) {
    return UserModel(
      id: supabaseUser.id,
      email: supabaseUser.email ?? '',
      name: supabaseUser.userMetadata?['name'] as String?,
      createdAt: DateTime.parse(supabaseUser.createdAt),
      updatedAt:
          DateTime.parse(supabaseUser.updatedAt ?? supabaseUser.createdAt),
    );
  }

  /// Creates a new instance of [UserModel] from a JSON map.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Converts the [UserModel] instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
