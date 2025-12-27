// // import 'package:dartz/dartz.dart';
// // import 'package:quiez_assigenment/core/error/failures.dart';
// // import 'package:quiez_assigenment/core/usecase/usecase.dart';
// // import '../entity/auth_entity.dart';
// // import '../repository_interface/auth_interface.dart';
// //
// // class UserLoginUsecase implements UseCase<UserEntity, UserLoginParams> {
// //   final AuthRepository repository;
// //   UserLoginUsecase(this.repository);
// //
// //   @override
// //   Future<Either<Failures, UserEntity>> call(UserLoginParams params) async {
// //     return await repository.login(
// //       email: params.email,
// //       password: params.password,
// //     );
// //   }
// // }
// //
// // class UserLoginParams {
// //   final String email;
// //   final String password;
// //
// //   UserLoginParams({required this.email, required this.password});
// // }
// import 'package:dartz/dartz.dart';
// import 'package:quiez_assigenment/core/error/failures.dart';
// import 'package:quiez_assigenment/core/usecase/usecase.dart';
// import '../../data/model/auth_model.dart'; // Change to UserModel
// import '../repository_interface/auth_interface.dart';
//
// class UserLoginUsecase implements UseCase<UserModel, UserLoginParams> { // Change to UserModel
//   final AuthRepository repository;
//   UserLoginUsecase(this.repository);
//
//   @override
//   Future<Either<Failures, UserModel>> call(UserLoginParams params) async { // Change to UserModel
//     return await repository.login(
//       params.email, // Remove named parameters
//       params.password,
//     );
//   }
// }
//
// class UserLoginParams {
//   final String email;
//   final String password;
//
//   UserLoginParams({required this.email, required this.password});
// }
import 'package:dartz/dartz.dart';
import 'package:quiez_assigenment/core/error/failures.dart';
import 'package:quiez_assigenment/core/usecase/usecase.dart';

import '../entity/auth_entity.dart';
import '../repository_interface/auth_interface.dart';

class UserLoginUsecase implements UseCase<UserEntity, UserLoginParams> {
  final AuthRepository repository;
  UserLoginUsecase(this.repository);

  @override
  Future<Either<Failures, UserEntity>> call(UserLoginParams params) async {
    return await repository.login(params.email, params.password);
  }
}

class UserLoginParams {
  final String email;
  final String password;

  UserLoginParams({required this.email, required this.password});
}