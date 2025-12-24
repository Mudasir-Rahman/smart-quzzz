

import '../model/model.dart';

/// Abstract class defining the contract for local data operations
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
}