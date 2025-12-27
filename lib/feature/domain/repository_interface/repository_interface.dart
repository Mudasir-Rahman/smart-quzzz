import '../entity/entity.dart';
import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';

/// Repository interface for MCQs, answers, and progress
/// No knowledge of Supabase here; purely domain layer
abstract class MCQRepository {
  /// Fetch all MCQs for the current logged-in user
  Future<Either<Failures, List<MCQ>>> getAllMCQs();

  /// Fetch a single MCQ by its ID
  Future<Either<Failures, MCQ?>> getMCQById(String id);

  /// Add a new MCQ
  Future<Either<Failures, void>> addMCQ(MCQ mcq);

  /// Update an existing MCQ
  Future<Either<Failures, void>> updateMCQ(MCQ mcq);

  /// Delete an MCQ by ID
  Future<Either<Failures, void>> deleteMCQ(String id);

  /// Submit a user's answer
  Future<Either<Failures, void>> submitAnswer(UserAnswer answer);

  /// Fetch recent answers for the current user
  Future<Either<Failures, List<UserAnswer>>> getUserAnswers();

  /// Get progress for a specific question
  Future<Either<Failures, QuestionProgress?>> getQuestionProgress(String mcqId);

  /// Get overall progress for the current user
  Future<Either<Failures, OverallProgress>> getOverallProgress();

  /// Get questions that need review for the current user
  Future<Either<Failures, List<MCQ>>> getQuestionsForReview(String userId);





}
