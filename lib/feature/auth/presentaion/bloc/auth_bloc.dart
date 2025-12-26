import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiez_assigenment/core/usecase/usecase.dart';
import '../../domain/usecase/get_current_usecase.dart';
import '../../domain/usecase/isLoginUsecase.dart';
import '../../domain/usecase/signout_usecase.dart';
import '../../domain/usecase/user_login_usecase.dart';
import '../../domain/usecase/signup_usecase.dart';
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
    print('🔵 AuthBloc created');

    /// ---------------- CHECK AUTH STATUS ----------------
    on<CheckAuthStatusEvent>((event, emit) async {
      print('🔵 CheckAuthStatusEvent triggered');
      emit(AuthLoading());

      try {
        // 1. Check if user is logged in
        final isLoggedInResult = await isLoggedInUseCase(NoParams());

        await isLoggedInResult.fold(
              (failure) async {
            print('🔴 IsLoggedInUseCase failed: ${failure.message}');
            emit(AuthLoggedOut());
          },
              (isLoggedIn) async {
            print('📊 IsLoggedInUseCase result: $isLoggedIn');

            if (isLoggedIn) {
              // 2. Get current user details
              final userResult = await getCurrentUserUsecase(NoParams());

              userResult.fold(
                    (failure) {
                  print('🔴 GetCurrentUserUsecase failed: ${failure.message}');
                  emit(AuthLoggedOut());
                },
                    (user) {
                  if (user == null) {
                    print('🔴 GetCurrentUserUsecase returned null user');
                    emit(AuthLoggedOut());
                  } else {
                    print('🟢 User found: ${user.email} - Emitting AuthSuccess');
                    emit(AuthSuccess(user));
                  }
                },
              );
            } else {
              print('📊 User is not logged in');
              emit(AuthLoggedOut());
            }
          },
        );
      } catch (e) {
        print('🔴 CheckAuthStatus exception: $e');
        emit(AuthLoggedOut());
      }
    });

    /// ---------------- LOGIN ----------------
    on<LoginEvent>((event, emit) async {
      print('🔵 LoginEvent triggered for: ${event.email}');
      emit(AuthLoading());

      try {
        final result = await loginUsecase(
          UserLoginParams(email: event.email, password: event.password),
        );

        await result.fold(
              (failure) async {
            print('🔴 Login failed: ${failure.message}');
            emit(AuthFailure(failure.message));
          },
              (user) async {
            print('🟢 Login successful: ${user.email}');
            emit(AuthSuccess(user));
          },
        );
      } catch (e) {
        print('🔴 Login exception: $e');
        emit(AuthFailure('An unexpected error occurred'));
      }
    });

    /// ---------------- SIGNUP ----------------
    on<SignupEvent>((event, emit) async {
      print('🔵 SignupEvent triggered for: ${event.email}');
      emit(AuthLoading());

      try {
        final result = await signupUsecase(
          SignupParams(
            email: event.email,
            password: event.password,
            fullName: event.fullName,
          ),
        );

        await result.fold(
              (failure) async {
            print('🔴 Signup failed: ${failure.message}');
            emit(AuthFailure(failure.message));
          },
              (user) async {
            print('🟢 Signup successful: ${user.email}');
            emit(AuthSuccess(user));
          },
        );
      } catch (e) {
        print('🔴 Signup exception: $e');
        emit(AuthFailure('An unexpected error occurred'));
      }
    });

    /// ---------------- GET CURRENT USER ----------------
    on<GetCurrentUserEvent>((event, emit) async {
      print('🔵 GetCurrentUserEvent triggered');
      emit(AuthLoading());

      try {
        final result = await getCurrentUserUsecase(NoParams());

        await result.fold(
              (failure) async {
            print('🔴 GetCurrentUser failed: ${failure.message}');
            emit(AuthFailure(failure.message));
          },
              (user) async {
            if (user == null) {
              print('🔴 GetCurrentUser: User is null');
              emit(AuthLoggedOut());
            } else {
              print('🟢 GetCurrentUser: User found ${user.email}');
              emit(AuthSuccess(user));
            }
          },
        );
      } catch (e) {
        print('🔴 GetCurrentUser exception: $e');
        emit(AuthLoggedOut());
      }
    });

    /// ---------------- SIGN OUT ----------------
    on<SignOutEvent>((event, emit) async {
      print('🔵 SignOutEvent triggered');
      emit(AuthLoading());

      try {
        final result = await signOutUseCase(NoParams());

        await result.fold(
              (failure) async {
            print('🔴 SignOut failed: ${failure.message}');
            emit(AuthFailure(failure.message));
          },
              (_) async {
            print('🟢 SignOut successful');
            emit(AuthLoggedOut());
          },
        );
      } catch (e) {
        print('🔴 SignOut exception: $e');
        emit(AuthFailure('Failed to sign out'));
      }
    });
  }
}