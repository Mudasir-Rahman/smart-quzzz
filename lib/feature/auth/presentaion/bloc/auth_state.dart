// // import 'package:equatable/equatable.dart';
// //
// // import '../../domain/entity/auth_entity.dart';
// //
// //
// // abstract class AuthBlocState extends Equatable {
// //   @override
// //   List<Object?> get props => [];
// // }
// //
// // class AuthInitial extends AuthBlocState {}
// // class AuthLoading extends AuthBlocState {}
// // class AuthSuccess extends AuthBlocState {
// //   final UserEntity user;
// //   AuthSuccess(this.user);
// //   @override
// //   List<Object?> get props => [user];
// // }
// // class AuthFailure extends AuthBlocState {
// //   final String message;
// //   AuthFailure(this.message);
// //   @override
// //   List<Object?> get props => [message];
// // }
// // class AuthLoggedOut extends AuthBlocState {}
// import 'package:equatable/equatable.dart';
//
// import '../../domain/entity/auth_entity.dart';
//
// abstract class AuthBlocState extends Equatable {
//   @override
//   List<Object?> get props => [];
// }
//
// class AuthInitial extends AuthBlocState {}
//
// class AuthLoading extends AuthBlocState {}
//
// class AuthSuccess extends AuthBlocState {
//   final UserEntity user;
//
//   AuthSuccess({required this.user});
//
//   @override
//   List<Object?> get props => [user];
// }
//
// class AuthLoggedOut extends AuthBlocState {}
//
// class AuthError extends AuthBlocState {
//   final String message;
//
//   AuthError({required this.message});
//
//   @override
//   List<Object?> get props => [message];
// }
// lib/feature/auth/presentation/bloc/auth_state.dart
import 'package:equatable/equatable.dart';

import '../../domain/entity/auth_entity.dart';


abstract class AuthBlocState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthBlocState {}

class AuthLoading extends AuthBlocState {}

class AuthSuccess extends AuthBlocState {
  final UserEntity user; // ✅ UserEntity

  AuthSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

class AuthLoggedOut extends AuthBlocState {}

class AuthError extends AuthBlocState {
  final String message;

  AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}