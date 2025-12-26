import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/auth_model.dart';
import 'auth_datasorce.dart';

class RemoteDataSourceImpl implements RemoteDataSource {
  final SupabaseClient supabaseClient;

  RemoteDataSourceImpl({required this.supabaseClient});

  /// ---------------- GET CURRENT USER ----------------
  @override
  Future<UserModel> getCurrentUser() async {
    print('🔵 RemoteDataSource: getCurrentUser() called');

    final session = supabaseClient.auth.currentSession;
    final user = supabaseClient.auth.currentUser;

    if (session == null || user == null) {
      print('🔴 No authenticated user found');
      throw AuthException('No authenticated user found');
    }

    print('📊 Fetching user from "users" table for: ${user.email}');

    try {
      // Select from users table with camelCase columns
      final data = await supabaseClient
          .from('users')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (data != null) {
        print('📊 User found in database');

        // Parse the data with camelCase column names
        return UserModel(
          id: data['id'] as String,
          email: data['email'] as String,
          fullName: data['fullName'] as String,
          profileImage: data['profileImage'] as String?,
          createdAt: DateTime.parse(data['createdAt'] as String),
        );
      }

      // If user record missing, create it
      print('📊 Creating new user record');
      final newUser = UserModel(
        id: user.id,
        email: user.email!,
        fullName: user.userMetadata?['full_name'] ?? 'Unknown',
        profileImage: user.userMetadata?['avatar_url'],
        createdAt: DateTime.now(),
      );

      // Insert with camelCase column names
      await supabaseClient.from('users').insert({
        'id': newUser.id,
        'email': newUser.email,
        'fullName': newUser.fullName,  // camelCase
        'profileImage': newUser.profileImage,  // camelCase
        'createdAt': newUser.createdAt.toIso8601String(),  // camelCase
      });

      print('📊 New user record created');
      return newUser;
    } catch (e) {
      print('🔴 getCurrentUser error: $e');

      // Provide a fallback user
      return UserModel(
        id: user.id,
        email: user.email!,
        fullName: user.userMetadata?['full_name'] ?? 'Unknown',
        profileImage: user.userMetadata?['avatar_url'],
        createdAt: DateTime.now(),
      );
    }
  }

  /// ---------------- LOGIN ----------------
  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    print('🔵 RemoteDataSource: login() called for: $email');

    try {
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user == null) {
        print('🔴 Login failed: No user returned');
        throw AuthException('Invalid email or password');
      }

      print('📊 Login successful, fetching user...');

      // Try to get existing user from database
      final data = await supabaseClient
          .from('users')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (data != null) {
        print('📊 Existing user found in database');
        return UserModel(
          id: data['id'] as String,
          email: data['email'] as String,
          fullName: data['fullName'] as String,
          profileImage: data['profileImage'] as String?,
          createdAt: DateTime.parse(data['createdAt'] as String),
        );
      }

      // Create new user record if not found
      print('📊 Creating new user record for login');
      final newUser = UserModel(
        id: user.id,
        email: user.email!,
        fullName: user.userMetadata?['full_name'] ?? 'Unknown',
        profileImage: user.userMetadata?['avatar_url'],
        createdAt: DateTime.now(),
      );

      // Insert with camelCase column names
      await supabaseClient.from('users').insert({
        'id': newUser.id,
        'email': newUser.email,
        'fullName': newUser.fullName,
        'profileImage': newUser.profileImage,
        'createdAt': newUser.createdAt.toIso8601String(),
      });

      print('📊 User record created for login');
      return newUser;
    } on AuthException catch (e) {
      print('🔴 AuthException in login: ${e.message}');
      rethrow;
    } catch (e) {
      print('🔴 Error in login: $e');
      throw AuthException('Login failed: $e');
    }
  }

  /// ---------------- SIGNUP ----------------
  @override
  Future<UserModel> signup({
    required String email,
    required String password,
    required String fullName,
  }) async {
    print('🔵 RemoteDataSource: signup() called for: $email');

    try {
      // 1️⃣ Create user in Supabase Auth
      final signUpResponse = await supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName},
      );

      final newUser = signUpResponse.user;
      if (newUser == null) {
        print('🔴 Signup failed: No user returned');
        throw AuthException('Failed to create user');
      }

      print('✅ User created in Auth, ID: ${newUser.id}');

      // 2️⃣ Create UserModel
      final model = UserModel(
        id: newUser.id,
        email: newUser.email!,
        fullName: fullName,
        profileImage: null,
        createdAt: DateTime.now(),
      );

      // 3️⃣ Insert into users table with camelCase column names
      try {
        await supabaseClient.from('users').insert({
          'id': model.id,
          'email': model.email,
          'fullName': model.fullName,  // camelCase
          'profileImage': model.profileImage,  // camelCase
          'createdAt': model.createdAt.toIso8601String(),  // camelCase
        });
        print('✅ User inserted into "users" table');
      } catch (e) {
        print('⚠️ Could not insert into users table: $e');
        // Continue even if insert fails - auth user is created
      }

      return model;
    } on AuthException catch (e) {
      print('🔴 AuthException in signup: ${e.message}');
      rethrow;
    } catch (e) {
      print('🔴 Error in signup: $e');
      throw AuthException('Signup failed: $e');
    }
  }

  /// ---------------- UPDATE PROFILE ----------------
  @override
  Future<UserModel> updateProfile({
    required String fullName,
    required String profileImage,
  }) async {
    print('🔵 RemoteDataSource: updateProfile() called');

    final user = supabaseClient.auth.currentUser;
    if (user == null) {
      print('🔴 No authenticated user found');
      throw AuthException('No authenticated user found');
    }

    try {
      // Update with camelCase column names
      await supabaseClient.from('users').update({
        'fullName': fullName,  // camelCase
        'profileImage': profileImage,  // camelCase
      }).eq('id', user.id);

      // Get updated user
      final updatedData = await supabaseClient
          .from('users')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (updatedData == null) {
        print('🔴 User update failed - no data returned');
        throw AuthException('User update failed');
      }

      print('📊 User updated successfully');
      return UserModel(
        id: updatedData['id'] as String,
        email: updatedData['email'] as String,
        fullName: updatedData['fullName'] as String,
        profileImage: updatedData['profileImage'] as String?,
        createdAt: DateTime.parse(updatedData['createdAt'] as String),
      );
    } catch (e) {
      print('🔴 Error updating user: $e');
      throw AuthException('User update failed: $e');
    }
  }

  /// ---------------- IS AUTHENTICATED ----------------
  @override
  Future<bool> isAuthenticated() async {
    print('🔵 RemoteDataSource: isAuthenticated() called');
    try {
      final session = supabaseClient.auth.currentSession;
      final user = supabaseClient.auth.currentUser;

      final isAuth = session != null && user != null;
      print('📊 Is authenticated: $isAuth');
      return isAuth;
    } catch (e) {
      print('🔴 isAuthenticated error: $e');
      return false;
    }
  }

  /// ---------------- LOGOUT ----------------
  @override
  Future<void> logout() async {
    print('🔵 RemoteDataSource: logout() called');
    try {
      await supabaseClient.auth.signOut();
      print('📊 User logged out successfully');
    } catch (e) {
      print('🔴 Error logging out: $e');
      throw AuthException('Logout failed: $e');
    }
  }
}