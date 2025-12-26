//
// import '../../domain/entity/entity.dart';
// import '../../domain/repository_interface/repository_interface.dart';
// import '../data_source/supabase_helper.dart';
//
// class MCQRepositoryImpl implements MCQRepository {
//   final SupabaseHelper supabaseHelper;
//
//   MCQRepositoryImpl({required this.supabaseHelper});
//
//   @override
//   Future<List<MCQ>> getAllMCQs() async {
//     return await supabaseHelper.getAllMCQs();
//   }
//
//   @override
//   Future<MCQ?> getMCQById(String id) async {
//     return await supabaseHelper.getMCQById(id);
//   }
//
//   @override
//   Future<void> addMCQ(MCQ mcq) async {
//     await supabaseHelper.addMCQ(mcq);
//   }
//
//   @override
//   Future<void> updateMCQ(MCQ mcq) async {
//     await supabaseHelper.updateMCQ(mcq);
//   }
//
//   @override
//   Future<void> deleteMCQ(String id) async {
//     await supabaseHelper.deleteMCQ(id);
//   }
//
//   @override
//   Future<void> submitAnswer(UserAnswer answer) async {
//     await supabaseHelper.submitAnswer(answer);
//   }
//
//   @override
//   Future<List<UserAnswer>> getUserAnswers() async {
//     return await supabaseHelper.getUserAnswers();
//   }
//
//   @override
//   Future<QuestionProgress?> getQuestionProgress(String mcqId) async {
//     return await supabaseHelper.getQuestionProgress(mcqId);
//   }
//
//   @override
//   Future<OverallProgress> getOverallProgress() async {
//     return await supabaseHelper.getOverallProgress();
//   }
//
//   @override
//   Future<List<MCQ>> getQuestionsForReview() async {
//     return await supabaseHelper.getQuestionsForReview();
//   }
// }
import 'package:dartz/dartz.dart';
import '../../domain/entity/entity.dart';
import '../../domain/repository_interface/repository_interface.dart';
import '../../../core/error/failures.dart';
import '../data_source/supabase_helper.dart';

class MCQRepositoryImpl implements MCQRepository {
  final SupabaseHelper supabaseHelper;

  MCQRepositoryImpl({required this.supabaseHelper});

  @override
  Future<Either<Failures, List<MCQ>>> getAllMCQs() async {
    try {
      final mcqs = await supabaseHelper.getAllMCQs();
      return Right(mcqs);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failures, MCQ?>> getMCQById(String id) async {
    try {
      final mcq = await supabaseHelper.getMCQById(id);
      return Right(mcq);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failures, void>> addMCQ(MCQ mcq) async {
    try {
      await supabaseHelper.addMCQ(mcq);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failures, void>> updateMCQ(MCQ mcq) async {
    try {
      await supabaseHelper.updateMCQU(mcq);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failures, void>> deleteMCQ(String id) async {
    try {
      await supabaseHelper.deleteMCQ(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failures, void>> submitAnswer(UserAnswer answer) async {
    try {
      await supabaseHelper.submitAnswer(answer);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failures, List<UserAnswer>>> getUserAnswers() async {
    try {
      final answers = await supabaseHelper.getUserAnswers();
      return Right(answers);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failures, QuestionProgress?>> getQuestionProgress(String mcqId) async {
    try {
      final progress = await supabaseHelper.getQuestionProgress(mcqId);
      return Right(progress);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failures, OverallProgress>> getOverallProgress() async {
    try {
      final progress = await supabaseHelper.getOverallProgress();
      return Right(progress);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failures, List<MCQ>>> getQuestionsForReview() async {
    try {
      final mcqs = await supabaseHelper.getQuestionsForReview();
      return Right(mcqs);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

}
