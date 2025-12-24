

import '../entity/entity.dart';

/// Repository interface - defines contract for data operations
/// This belongs to the domain layer and has no dependencies on implementation details
abstract class MCQRepository {
  Future<List<MCQ>> getAllMCQs();
  Future<MCQ?> getMCQById(String id);
  Future<void> addMCQ(MCQ mcq);
  Future<void> updateMCQ(MCQ mcq);
  Future<void> deleteMCQ(String id);

  Future<void> submitAnswer(UserAnswer answer);
  Future<List<UserAnswer>> getUserAnswers();

  Future<QuestionProgress?> getQuestionProgress(String mcqId);
  Future<OverallProgress> getOverallProgress();
  Future<List<MCQ>> getQuestionsForReview();
}