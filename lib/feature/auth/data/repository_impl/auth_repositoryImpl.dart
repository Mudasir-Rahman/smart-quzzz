import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entity/auth_entity.dart'; // Make sure this is the correct path
import '../../domain/repository_interface/auth_interface.dart';
import '../datasource/auth_datasorce.dart';

class AuthRepositoryImpl implements AuthRepository {
  final RemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  /// ---------------- LOGIN ----------------
  @override
  Future<Either<Failures, UserEntity>> login({
    required String email,
    required String password,
  }) async {
    print('🔵 AuthRepository: login() called for: $email');
    try {
      final userModel = await remoteDataSource.login(email: email, password: password);

      // Convert UserModel to UserEntity with all required fields
      final userEntity = UserEntity(
        id: userModel.id,
        email: userModel.email,
        fullName: userModel.fullName,
        profileImage: userModel.profileImage,
        createdAt: userModel.createdAt,
      );

      print('✅ AuthRepository: Login successful for ${userEntity.email}');
      return Right(userEntity);
    } on AuthException catch (e) {
      print('❌ AuthRepository: Login AuthException - ${e.message}');
      return Left(AuthFailures(e.message));
    } catch (e) {
      print('❌ AuthRepository: Login error - $e');
      return const Left(ServerFailure('Something went wrong'));
    }
  }

  /// ---------------- SIGNUP ----------------
  @override
  Future<Either<Failures, UserEntity>> signup({
    required String email,
    required String password,
    required String fullName,
  }) async {
    print('🔵 AuthRepository: signup() called for: $email');
    try {
      final userModel = await remoteDataSource.signup(
        email: email,
        password: password,
        fullName: fullName,
      );

      // Convert UserModel to UserEntity with all required fields
      final userEntity = UserEntity(
        id: userModel.id,
        email: userModel.email,
        fullName: userModel.fullName,
        profileImage: userModel.profileImage,
        createdAt: userModel.createdAt,
      );

      print('✅ AuthRepository: Signup successful for ${userEntity.email}');
      return Right(userEntity);
    } on AuthException catch (e) {
      print('❌ AuthRepository: Signup AuthException - ${e.message}');
      return Left(AuthFailures(e.message));
    } catch (e) {
      print('❌ AuthRepository: Signup error - $e');
      return const Left(ServerFailure('Something went wrong'));
    }
  }

  /// ---------------- UPDATE PROFILE ----------------
  @override
  Future<Either<Failures, UserEntity>> updateProfile({
    required String fullName,
    required String profileImage,
  }) async {
    print('🔵 AuthRepository: updateProfile() called');
    try {
      final userModel = await remoteDataSource.updateProfile(
        fullName: fullName,
        profileImage: profileImage,
      );

      // Convert UserModel to UserEntity with all required fields
      final userEntity = UserEntity(
        id: userModel.id,
        email: userModel.email,
        fullName: userModel.fullName,
        profileImage: userModel.profileImage,
        createdAt: userModel.createdAt,
      );

      print('✅ AuthRepository: Profile updated successfully');
      return Right(userEntity);
    } on AuthException catch (e) {
      print('❌ AuthRepository: Update profile AuthException - ${e.message}');
      return Left(AuthFailures(e.message));
    } catch (e) {
      print('❌ AuthRepository: Update profile error - $e');
      return const Left(ServerFailure('Something went wrong'));
    }
  }

  /// ---------------- GET CURRENT USER ----------------
  @override
  Future<Either<Failures, UserEntity>> getCurrentUser() async {
    print('🔵 AuthRepository: getCurrentUser() called');
    try {
      final userModel = await remoteDataSource.getCurrentUser();

      // Convert UserModel to UserEntity with all required fields
      final userEntity = UserEntity(
        id: userModel.id,
        email: userModel.email,
        fullName: userModel.fullName,
        profileImage: userModel.profileImage,
        createdAt: userModel.createdAt,
      );

      print('✅ AuthRepository: Current user found - ${userEntity.email}');
      return Right(userEntity);
    } on AuthException catch (e) {
      print('❌ AuthRepository: Get current user AuthException - ${e.message}');
      return Left(AuthFailures(e.message));
    } catch (e) {
      print('❌ AuthRepository: Get current user error - $e');
      return const Left(ServerFailure('Something went wrong'));
    }
  }

  /// ---------------- IS LOGGED IN ----------------
  @override
  Future<Either<Failures, bool>> isLoggedIn() async {
    print('🔵 AuthRepository: isLoggedIn() called');
    try {
      // Directly return the bool from remoteDataSource.isAuthenticated()
      final bool result = await remoteDataSource.isAuthenticated();
      print('📊 AuthRepository: isLoggedIn result: $result');
      return Right(result);
    } on AuthException catch (e) {
      print('📊 AuthRepository: User not authenticated - ${e.message}');
      return const Right(false); // user not logged in ≠ failure
    } catch (e) {
      print('❌ AuthRepository: isLoggedIn error - $e');
      return const Left(ServerFailure('Failed to check authentication status'));
    }
  }

  /// ---------------- LOGOUT ----------------
  @override
  Future<Either<Failures, void>> logout() async {
    print('🔵 AuthRepository: logout() called');
    try {
      await remoteDataSource.logout();
      print('✅ AuthRepository: Logout successful');
      return const Right(null);
    } catch (e) {
      print('❌ AuthRepository: Logout failed - $e');
      return const Left(ServerFailure('Logout failed'));
    }
  }
}