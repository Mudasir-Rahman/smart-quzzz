
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
import 'feature/presentaion/progress_bloc/progres_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  print('🚀 Starting dependency injection...');

  try {
    // ----------------------
    // Initialize Supabase
    // ----------------------
    print('Initializing Supabase...');
    await Supabase.initialize(
      url: 'https://splrcftcnidwbjneigyl.supabase.co',
      anonKey: 'sb_publishable_HdFQk1WQXvDcqoGYVpPxYg_F6n1q7ra',
    );
    print(' Supabase initialized');

    // ----------------------
    // Supabase Helper
    // ----------------------
    sl.registerLazySingleton<SupabaseHelper>(() => SupabaseHelper.instance);
    print(' SupabaseHelper registered');

    // ----------------------
    // SINGLE Repository (MCQRepository handles everything)
    // ----------------------
    sl.registerLazySingleton<MCQRepository>(
          () => MCQRepositoryImpl(supabaseHelper: sl()),
    );
    print(' MCQRepository registered (includes all progress methods)');

    // ----------------------
    // Use Cases
    // ----------------------
    // All use cases get the SAME repository
    sl.registerLazySingleton(() => GetAllMCQs(sl<MCQRepository>()));
    sl.registerLazySingleton(() => GetMCQById(sl<MCQRepository>()));
    sl.registerLazySingleton(() => AddMCQ(sl<MCQRepository>()));
    sl.registerLazySingleton(() => UpdateMCQ(sl<MCQRepository>()));
    sl.registerLazySingleton(() => DeleteMCQ(sl<MCQRepository>()));
    sl.registerLazySingleton(() => SubmitAnswer(sl<MCQRepository>()));
    sl.registerLazySingleton(() => GetQuestionsForReview(sl<MCQRepository>()));
    sl.registerLazySingleton(() => GetOverallProgress(sl<MCQRepository>()));
    sl.registerLazySingleton(() => GetUserAnswers(sl<MCQRepository>()));
    print('All UseCases registered');

    // ----------------------
    // BLoC
    // ----------------------
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
    print(' MCQBloc registered');

    sl.registerFactory(
          () => ProgressBloc(
        getOverallProgress: sl<GetOverallProgress>(),  // Pass the use case, not repository
        getUserAnswers: sl<GetUserAnswers>(),         // Pass the use case, not repository
      ),
    );
    print(' ProgressBloc registered');

    // ----------------------
    // Test DI setup
    // ----------------------
    print('\n Testing dependency injection...');

    final testRepo = sl<MCQRepository>();
    print(' MCQRepository test: PASSED');

    final testGetOverallProgress = sl<GetOverallProgress>();
    print(' GetOverallProgress UseCase test: PASSED');

    final testMCQBloc = sl<MCQBloc>();
    print(' MCQBloc test: PASSED');

    final testProgressBloc = sl<ProgressBloc>();
    print(' ProgressBloc test: PASSED');

    print('\n All dependencies registered successfully!');

  } catch (e, stackTrace) {
    print('\n Error during dependency injection setup:');
    print('Error: $e');
    print('Stack trace: $stackTrace');
    rethrow;
  }
}