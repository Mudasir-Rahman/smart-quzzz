import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';

import '../../domain/entity/auth_entity.dart';
import '../../domain/usecase/get_current_usecase.dart';
import '../../domain/usecase/isLoginUsecase.dart';
import '../../domain/usecase/signout_usecase.dart';
import '../../domain/usecase/signup_usecase.dart';
import '../../domain/usecase/user_login_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthBlocState> {
  final UserLoginUsecase loginUsecase;
  final SignupUseCase signupUsecase;
  final GetCurrentUser getCurrentUserUsecase;
  final SignOutUseCase signOutUseCase;
  final IsLoggedInUseCase isLoggedInUseCase;

  AuthBloc({
    required this.loginUsecase,
    required this.signupUsecase,
    required this.getCurrentUserUsecase,
    required this.signOutUseCase,
    required this.isLoggedInUseCase,
  }) : super(AuthInitial()) {
    // print('🔵 AuthBloc created');

    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<LoginEvent>(_onLogin);
    on<SignupEvent>(_onSignup);
    on<SignOutEvent>(_onSignOut);
  }

  Future<void> _onCheckAuthStatus(
      CheckAuthStatusEvent event,
      Emitter<AuthBlocState> emit,
      ) async {
    try {
      // print('🔵 CheckAuthStatusEvent triggered');
      emit(AuthLoading());

      final Either<Failures, bool> isLoggedInResult = await isLoggedInUseCase(NoParams());

      await isLoggedInResult.fold(
            (failure) async {
          // print('❌ isLoggedInUseCase failed: $failure');
          emit(AuthError(message: failure.message));
        },
            (isLoggedIn) async {
          // print('📊 IsLoggedInUseCase result: $isLoggedIn');

          if (!isLoggedIn) {
            // print('🔒 User is not logged in');
            emit(AuthLoggedOut());
            return;
          }

          await _getCurrentUser(emit);
        },
      );
    } catch (e) {
      // print('❌ Error checking auth status: $e');
      emit(AuthError(message: 'Failed to check authentication status'));
    }
  }

  Future<void> _getCurrentUser(Emitter<AuthBlocState> emit) async {
    try {
      // print('🔵 Getting current user...');
      final Either<Failures, UserEntity> userResult = await getCurrentUserUsecase(NoParams());

      await userResult.fold(
            (failure) async {
          // print('⚠️ Failed to get user details: $failure');
          emit(AuthLoggedOut());
        },
            (user) async {
          // print('🟢 User found: ${user.email}');
          // print('🎯 EMITTING AuthSuccess from _getCurrentUser');
          emit(AuthSuccess(user: user));
        },
      );
    } catch (e) {
      // print('❌ Error getting current user: $e');
      emit(AuthError(message: 'Failed to get user details'));
    }
  }

  Future<void> _onLogin(
      LoginEvent event,
      Emitter<AuthBlocState> emit,
      ) async {
    try {
      // print('🔵 LoginEvent triggered for: ${event.email}');
      emit(AuthLoading());

      final Either<Failures, UserEntity> loginResult =
      await loginUsecase(UserLoginParams(
          email: event.email,
          password: event.password
      ));

      await loginResult.fold(
            (failure) async {
          // print('❌ Login failed: $failure');
          emit(AuthError(message: failure.message));
        },
            (user) async {
          // print('✅ Login successful for: ${user.email}');
          // print('🎯 EMITTING AuthSuccess from _onLogin');
          emit(AuthSuccess(user: user));
        },
      );
    } catch (e) {
      // print('❌ Login error: $e');
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onSignup(
      SignupEvent event,
      Emitter<AuthBlocState> emit,
      ) async {
    try {
      // print('🔵 SignupEvent triggered for: ${event.email}');
      emit(AuthLoading());

      final Either<Failures, UserEntity> signupResult =
      await signupUsecase(SignupParams(
          email: event.email,
          password: event.password,
          fullName: event.fullName
      ));

      await signupResult.fold(
            (failure) async {
          // print('❌ Signup failed: $failure');
          emit(AuthError(message: failure.message));
        },
            (user) async {
          // print('✅ Signup successful for: ${user.email}');
          // print('🎯 EMITTING AuthSuccess from _onSignup');
          emit(AuthSuccess(user: user));
          // print('🎯 AuthSuccess emitted - AuthWrapper should handle navigation');
        },
      );
    } catch (e) {
      // print('❌ Signup error: $e');
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onSignOut(
      SignOutEvent event,
      Emitter<AuthBlocState> emit,
      ) async {
    try {
      // print('🔵 SignOutEvent triggered');
      emit(AuthLoading());

      final Either<Failures, void> logoutResult = await signOutUseCase(NoParams());

      await logoutResult.fold(
            (failure) async {
          // print('❌ SignOut failed: $failure');
          emit(AuthError(message: failure.message));
        },
            (_) async {
          // print('✅ SignOut successful');
          emit(AuthLoggedOut());
        },
      );
    } catch (e) {
      // print('❌ SignOut error: $e');
      emit(AuthError(message: 'Failed to sign out'));
    }
  }
}
