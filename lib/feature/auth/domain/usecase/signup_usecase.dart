// import 'package:dartz/dartz.dart';
// import 'package:quiez_assigenment/core/error/failures.dart';
// import 'package:quiez_assigenment/core/usecase/usecase.dart';
// import '../entity/auth_entity.dart';
// import '../repository_interface/auth_interface.dart';
//
// class SignupUseCase implements UseCase<UserEntity, SignupParams> {
//   final AuthRepository repository;
//   SignupUseCase(this.repository);
//
//   @override
//   Future<Either<Failures, UserEntity>> call(SignupParams params) async {
//     return await repository.signup(
//       email: params.email,
//       password: params.password,
//       fullName: params.fullName,
//     );
//   }
// }
//
// class SignupParams {
//   final String email;
//   final String password;
//   final String fullName;
//
//   SignupParams({
//     required this.email,
//     required this.password,
//     required this.fullName,
//   });
// }
import 'package:dartz/dartz.dart';
import 'package:quiez_assigenment/core/error/failures.dart';
import 'package:quiez_assigenment/core/usecase/usecase.dart';

import '../entity/auth_entity.dart';
import '../repository_interface/auth_interface.dart';

class SignupUseCase implements UseCase<UserEntity, SignupParams> {
  final AuthRepository repository;
  SignupUseCase(this.repository);

  @override
  Future<Either<Failures, UserEntity>> call(SignupParams params) async {
    return await repository.signup(params.email, params.password, params.fullName);
  }
}

class SignupParams {
  final String email;
  final String password;
  final String fullName;

  SignupParams({
    required this.email,
    required this.password,
    required this.fullName,
  });
}