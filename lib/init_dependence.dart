import 'dart:async';
import 'package:get_it/get_it.dart';
import 'package:quiez_assigenment/feature/auth/domain/usecase/get_current_usecase.dart';
import 'package:quiez_assigenment/feature/auth/domain/usecase/user_login_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'feature/auth/data/datasource/auth_datasorceImp.dart';
import 'feature/auth/data/repository_impl/auth_repositoryImpl.dart';
import 'feature/data/data_source/supabase_helper.dart';
import 'feature/data/repository_impl/repository_impl.dart';
import 'feature/domain/repository_interface/repository_interface.dart';

import 'feature/domain/usecase/addMCQ.dart';
import 'feature/domain/usecase/deleteMCQ.dart';
import 'feature/domain/usecase/getMcqsByid.dart';
import 'feature/domain/usecase/getOverallProgress.dart';
import 'feature/domain/usecase/getQuestionsForReview.dart';
import 'feature/domain/usecase/get_all_mcqs.dart';
import 'feature/domain/usecase/get_user_answer.dart';
import 'feature/domain/usecase/submitAnswer.dart';
import 'feature/domain/usecase/updateMCQ.dart';
import 'feature/presentaion/bloc/mcqs_bloc.dart';

import 'feature/auth/data/datasource/auth_datasorce.dart';
import 'feature/auth/domain/repository_interface/auth_interface.dart';

import 'feature/auth/domain/usecase/isLoginUsecase.dart';
import 'feature/auth/domain/usecase/signout_usecase.dart';

import 'feature/auth/domain/usecase/signup_usecase.dart';
import 'feature/auth/presentaion/bloc/auth_bloc.dart';
import 'feature/presentaion/progress_bloc/progres_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  await Supabase.initialize(
    url: 'https://splrcftcnidwbjneigyl.supabase.co',
    anonKey: 'sb_publishable_HdFQk1WQXvDcqoGYVpPxYg_F6n1q7ra',
  );
  sl.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);


  // Core
  sl.registerLazySingleton<SupabaseHelper>(() => SupabaseHelper.instance);

  // Data sources
  sl.registerLazySingleton<RemoteDataSource>(
        () => RemoteDataSourceImpl(supabaseClient: sl()),
  );

  // Repositories
  sl.registerLazySingleton<MCQRepository>(
        () => MCQRepositoryImpl(supabaseHelper: sl()),
  );
  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAllMCQsUseCase(sl()));
  sl.registerLazySingleton(() => GetMCQByIdUseCase(sl()));
  sl.registerLazySingleton(() => AddMCQUseCase(sl()));
  sl.registerLazySingleton(() => UpdateMCQUseCase(sl()));
  sl.registerLazySingleton(() => DeleteMCQUseCase(sl()));
  sl.registerLazySingleton(() => SubmitAnswerUseCase(sl()));
  sl.registerLazySingleton(() => GetQuestionsForReviewUseCase(sl()));
  sl.registerLazySingleton(() => GetOverallProgressUseCase(sl()));
  sl.registerLazySingleton(() => GetUserAnswersUseCase(sl()));

  sl.registerLazySingleton(() => UserLoginUsecase(sl()));
  sl.registerLazySingleton(() => SignupUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));
  sl.registerLazySingleton(() => SignOutUseCase(sl()));
  sl.registerLazySingleton(() => IsLoggedInUseCase(sl()));

  // Blocs
  sl.registerFactory(
        () => MCQBloc(
      getAllMCQsUseCase: sl(),
      getQuestionsForReviewUseCase: sl(),
      submitAnswerUseCase: sl(),
      addMCQUseCase: sl(),
      updateMCQUseCase: sl(),
      deleteMCQUseCase: sl(),
      getMCQByIdUseCase: sl(),
    ),
  );

  sl.registerFactory(
        () => ProgressBloc(
      getOverallProgressUseCase: sl(),
      getUserAnswersUseCase: sl(),
    ),
  );

  sl.registerFactory(
        () => AuthBloc(
      loginUsecase: sl(),
      signupUsecase: sl(),
      getCurrentUserUsecase: sl(),
      signOutUseCase: sl(),
      isLoggedInUseCase: sl(),
    ),
  );
}
