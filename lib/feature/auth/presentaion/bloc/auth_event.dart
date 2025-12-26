import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// ---------------- LOGIN ----------------
class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

/// ---------------- SIGNUP ----------------
class SignupEvent extends AuthEvent {
  final String email;
  final String password;
  final String fullName; // corrected from 'name'

  SignupEvent({required this.email, required this.password, required this.fullName});

  @override
  List<Object?> get props => [email, password, fullName];
}

/// ---------------- GET CURRENT USER ----------------
class GetCurrentUserEvent extends AuthEvent {}

/// ---------------- SIGN OUT ----------------
class SignOutEvent extends AuthEvent {}

/// ---------------- CHECK AUTH STATUS ----------------
class CheckAuthStatusEvent extends AuthEvent {}
