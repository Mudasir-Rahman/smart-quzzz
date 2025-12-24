
import '../../domain/entity/entity.dart';
import '../../domain/repository_interface/repository_interface.dart';
import '../data_source/supabase_helper.dart';

class MCQRepositoryImpl implements MCQRepository {
  final SupabaseHelper supabaseHelper;

  MCQRepositoryImpl({required this.supabaseHelper});

  @override
  Future<List<MCQ>> getAllMCQs() async {
    return await supabaseHelper.getAllMCQs();
  }

  @override
  Future<MCQ?> getMCQById(String id) async {
    return await supabaseHelper.getMCQById(id);
  }

  @override
  Future<void> addMCQ(MCQ mcq) async {
    await supabaseHelper.addMCQ(mcq);
  }

  @override
  Future<void> updateMCQ(MCQ mcq) async {
    await supabaseHelper.updateMCQ(mcq);
  }

  @override
  Future<void> deleteMCQ(String id) async {
    await supabaseHelper.deleteMCQ(id);
  }

  @override
  Future<void> submitAnswer(UserAnswer answer) async {
    await supabaseHelper.submitAnswer(answer);
  }

  @override
  Future<List<UserAnswer>> getUserAnswers() async {
    return await supabaseHelper.getUserAnswers();
  }

  @override
  Future<QuestionProgress?> getQuestionProgress(String mcqId) async {
    return await supabaseHelper.getQuestionProgress(mcqId);
  }

  @override
  Future<OverallProgress> getOverallProgress() async {
    return await supabaseHelper.getOverallProgress();
  }

  @override
  Future<List<MCQ>> getQuestionsForReview() async {
    return await supabaseHelper.getQuestionsForReview();
  }
}