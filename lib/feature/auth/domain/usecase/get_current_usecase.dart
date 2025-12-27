// // import 'package:dartz/dartz.dart';
// // import 'package:quiez_assigenment/core/error/failures.dart';
// // import 'package:quiez_assigenment/core/usecase/usecase.dart';
// // import '../entity/auth_entity.dart';
// // import '../repository_interface/auth_interface.dart';
// //
// // class GetCurrentUser implements UseCase<UserEntity?, NoParams> {
// //   final AuthRepository authRepository;
// //   GetCurrentUser(this.authRepository);
// //
// //   @override
// //   Future<Either<Failures, UserEntity?>> call(NoParams params) async {
// //     return await authRepository.getCurrentUser();
// //   }
// // }
// import 'package:dartz/dartz.dart';
//
// import '../../../../core/error/failures.dart';
// import '../../data/model/auth_model.dart';
// import '../repository_interface/auth_interface.dart';
//
//
// class GetCurrentUser {
//   final AuthRepository authRepository;
//
//   GetCurrentUser({required this.authRepository});
//
//   Future<Either<Failures, UserModel>> call() async {
//     return await authRepository.getCurrentUser();
//   }
// }
import 'package:dartz/dartz.dart';
import 'package:quiez_assigenment/core/error/failures.dart';
import 'package:quiez_assigenment/core/usecase/usecase.dart';

import '../entity/auth_entity.dart';
import '../repository_interface/auth_interface.dart';

class GetCurrentUser implements UseCase<UserEntity, NoParams> {
  final AuthRepository authRepository;
  GetCurrentUser(this.authRepository);

  @override
  Future<Either<Failures, UserEntity>> call(NoParams params) async {
    return await authRepository.getCurrentUser();
  }
}