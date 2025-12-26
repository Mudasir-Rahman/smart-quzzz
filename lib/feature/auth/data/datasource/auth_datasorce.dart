//
// import '../model/auth_model.dart';
//
// abstract class RemoteDataSource {
//   Future<UserModel> login({
//     required String email,
//     required String password,
//   });
//   Future<UserModel> getCurrentUser();
//   Future<void> logout();
//   Future<UserModel> updateProfile({
//     required String fullName,
//     required String profileImage,
//   });
//
//   Future<UserModel> signup({
//     required String email,
//     required String password,
//     required String fullName,
//   });
//   Future<UserModel> isAuthenticated();
//
// }
//
import '../model/auth_model.dart';

abstract class RemoteDataSource {
  Future<UserModel> login({required String email, required String password});

  Future<UserModel> signup({
    required String email,
    required String password,
    required String fullName,
  });

  Future<UserModel> getCurrentUser();

  Future<bool> isAuthenticated();  // ✅ This should be bool, not UserModel

  Future<void> logout();

  Future<UserModel> updateProfile({
    required String fullName,
    required String profileImage,
  });
}