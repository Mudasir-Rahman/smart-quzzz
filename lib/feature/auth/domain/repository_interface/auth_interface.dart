// // // import 'package:dartz/dartz.dart';
// // //
// // //
// // // import '../../../../core/error/failures.dart';
// // // import '../entity/auth_entity.dart';
// // //
// // // abstract class AuthRepository{
// // //
// // //   // Login
// // //   Future<Either<Failures,UserEntity>> login({
// // //     required String email,
// // //     required String password,
// // //   }
// // //       );
// // // // Logout
// // //   Future<Either<Failures,void>> logout();
// // // // Get Current User
// // //   Future<Either<Failures,UserEntity>> getCurrentUser();
// // // // Check if user is logged in
// // //   Future<bool> isLoggedIn();
// // // // Check if user Authenticated
// // //   Future<Either<Failures,bool>>isAuthenticated();
// // // // Update user profile
// // //   Future<Either<Failures,UserEntity>>updateProfile({
// // //     required String fullName,
// // //     required String profileImage,
// // //   });
// // //
// // // // signup use case
// // //   Future<Either<Failures,UserEntity>> signup({
// // //     required String email,
// // //     required String password,
// // //     required String fullName,
// // //   });
// // // }
// // import 'package:dartz/dartz.dart';
// //
// // import '../../../../core/error/failures.dart';
// // import '../entity/auth_entity.dart';
// //
// // abstract class AuthRepository {
// //   Future<Either<Failures, UserEntity>> login({
// //     required String email,
// //     required String password,
// //   });
// //
// //   Future<Either<Failures, UserEntity>> signup({
// //     required String email,
// //     required String password,
// //     required String fullName,
// //   });
// //
// //   Future<Either<Failures, bool>> isLoggedIn();  // Changed from isAuthenticated
// //
// //   Future<Either<Failures, UserEntity>> getCurrentUser();
// //
// //   Future<Either<Failures, void>> logout();
// //
// //   Future<Either<Failures, UserEntity>> updateProfile({
// //     required String fullName,
// //     required String profileImage,
// //   });
// // }
// import 'package:dartz/dartz.dart';
//
// import '../../../../core/error/failures.dart';
// import '../../data/model/auth_model.dart';
//
//
// abstract class AuthRepository {
//   Future<Either<Failures, UserModel>> login(String email, String password);
//
//   Future<Either<Failures, UserModel>> signup(String email, String password, String fullName);
//
//   Future<Either<Failures, UserModel>> getCurrentUser();
//
//   Future<Either<Failures, bool>> isLoggedIn();  // ✅ Returns Either<Failures, bool>
//
//   Future<Either<Failures, void>> logout();
//
//   Future<Either<Failures, UserModel>> updateProfile(String fullName, String profileImage);
// }
// lib/feature/auth/domain/repository_interface/auth_interface.dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

import '../entity/auth_entity.dart'; // ✅ Import UserEntity

abstract class AuthRepository {
  // ✅ ALL methods return UserEntity
  Future<Either<Failures, UserEntity>> login(String email, String password);

  Future<Either<Failures, UserEntity>> signup(String email, String password, String fullName);

  Future<Either<Failures, UserEntity>> getCurrentUser();

  Future<Either<Failures, bool>> isLoggedIn();

  Future<Either<Failures, void>> logout();

  Future<Either<Failures, UserEntity>> updateProfile(String fullName, String profileImage);
}