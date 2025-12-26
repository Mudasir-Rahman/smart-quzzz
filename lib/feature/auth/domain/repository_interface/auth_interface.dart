// import 'package:dartz/dartz.dart';
//
//
// import '../../../../core/error/failures.dart';
// import '../entity/auth_entity.dart';
//
// abstract class AuthRepository{
//
//   // Login
//   Future<Either<Failures,UserEntity>> login({
//     required String email,
//     required String password,
//   }
//       );
// // Logout
//   Future<Either<Failures,void>> logout();
// // Get Current User
//   Future<Either<Failures,UserEntity>> getCurrentUser();
// // Check if user is logged in
//   Future<bool> isLoggedIn();
// // Check if user Authenticated
//   Future<Either<Failures,bool>>isAuthenticated();
// // Update user profile
//   Future<Either<Failures,UserEntity>>updateProfile({
//     required String fullName,
//     required String profileImage,
//   });
//
// // signup use case
//   Future<Either<Failures,UserEntity>> signup({
//     required String email,
//     required String password,
//     required String fullName,
//   });
// }
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entity/auth_entity.dart';

abstract class AuthRepository {
  Future<Either<Failures, UserEntity>> login({
    required String email,
    required String password,
  });

  Future<Either<Failures, UserEntity>> signup({
    required String email,
    required String password,
    required String fullName,
  });

  Future<Either<Failures, bool>> isLoggedIn();  // Changed from isAuthenticated

  Future<Either<Failures, UserEntity>> getCurrentUser();

  Future<Either<Failures, void>> logout();

  Future<Either<Failures, UserEntity>> updateProfile({
    required String fullName,
    required String profileImage,
  });
}