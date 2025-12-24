import 'package:get_it/get_it.dart';

import 'feature/data/data_source/database_helper.dart';
import 'feature/data/data_source/local_data_source.dart';
import 'feature/data/data_source/local_data_source_impl.dart';
import 'feature/data/repository_impl/repository_impl.dart' hide LocalDataSource;
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
  // ----------------------
  // Database
  // ----------------------
  sl.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper.instance);
  // Ensure DB initialized
  await sl<DatabaseHelper>().database;

  // ----------------------
  // Data sources
  // ----------------------
  sl.registerLazySingleton<LocalDataSource>(
        () => LocalDataSourceImpl(databaseHelper: sl()),
  );

  // ----------------------
  // Repository
  // ----------------------
  sl.registerLazySingleton<MCQRepository>(
        () => MCQRepositoryImpl(localDataSource: sl()),
  );

  // ----------------------
  // Use Cases
  // ----------------------
  sl.registerLazySingleton(() => GetAllMCQs(sl()));
  sl.registerLazySingleton(() => GetMCQById(sl()));
  sl.registerLazySingleton(() => AddMCQ(sl()));
  sl.registerLazySingleton(() => UpdateMCQ(sl()));
  sl.registerLazySingleton(() => DeleteMCQ(sl()));
  sl.registerLazySingleton(() => SubmitAnswer(sl()));
  sl.registerLazySingleton(() => GetQuestionsForReview(sl()));
  sl.registerLazySingleton(() => GetOverallProgress(sl()));
  sl.registerLazySingleton(() => GetUserAnswers(sl()));

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
      deleteMCQUseCase: sl(), getMCQByIdUseCase: sl(),
    ),
  );

  sl.registerFactory(
        () => ProgressBloc(
      getOverallProgress: sl(),
      getUserAnswers: sl(),
    ),
  );
}
