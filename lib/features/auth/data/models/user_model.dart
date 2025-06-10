import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tava/features/auth/domain/entities/tava_user.dart';

class UserModel extends TavaUser {
  const UserModel({
    required super.id,
    required super.email,
    super.name,
    required super.createdAt,
    required super.updatedAt,
  });

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

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

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
