

import '../model/model.dart';

abstract class LocalDataSource {
  Future<List<MCQModel>> getAllMCQs();
  Future<MCQModel?> getMCQById(String id);
  Future<void> insertMCQ(MCQModel mcq);
  Future<void> updateMCQ(MCQModel mcq);
  Future<void> deleteMCQ(String id);

  Future<void> insertUserAnswer(UserAnswerModel answer);
  Future<List<UserAnswerModel>> getUserAnswers();
  Future<List<UserAnswerModel>> getUserAnswersByMCQId(String mcqId);

  Future<QuestionProgressModel?> getQuestionProgress(String mcqId);
  Future<void> updateQuestionProgress(QuestionProgressModel progress);
  Future<List<QuestionProgressModel>> getAllQuestionProgress();

  // Optional: Add these for better performance
  Future<void> submitAnswerWithProgress({
    required UserAnswerModel answer,
    required bool isCorrect,
  });

  Future<List<MCQModel>> getQuestionsForReview();
}