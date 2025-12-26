// lib/features/auth/domain/entities/user_entity.dart

import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String fullName;
  final String? profileImage;
  final DateTime createdAt;

  const UserEntity({
    required this.id,
    required this.email,
    required this.fullName,
    this.profileImage,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, email, fullName, profileImage, createdAt];
}