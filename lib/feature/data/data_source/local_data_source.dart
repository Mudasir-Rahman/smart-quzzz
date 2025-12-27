import 'package:quiez_assigenment/feature/data/data_source/supabase_helper.dart';

import 'package:uuid/uuid.dart';

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
  Future<void> submitAnswerWithProgress({
    required UserAnswerModel answer,
    required bool isCorrect,
  });
  Future<List<MCQModel>> getQuestionsForReview();
}

class LocalDataSourceImpl implements LocalDataSource {
  final SupabaseHelper databaseHelper;
  final Uuid _uuid = Uuid();

  LocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<List<MCQModel>> getAllMCQs() async {
    try {
      final client = await databaseHelper.database;
      final response = await client
          .from('mcqs')
          .select()
          .order('createdAt', ascending: false);

      if (response.isEmpty) return [];

      return (response as List)
          .map((map) => MCQModel.fromMap(map))
          .toList();
    } catch (e) {
      print('Error fetching MCQs: $e');
      return [];
    }
  }

  @override
  Future<MCQModel?> getMCQById(String id) async {
    try {
      final client = await databaseHelper.database;
      final response = await client
          .from('mcqs')
          .select()
          .eq('id', id)
          .single()
          .catchError((_) => null);

      if (response == null) return null;
      return MCQModel.fromMap(response);
    } catch (e) {
      print('Error fetching MCQ by ID: $e');
      return null;
    }
  }

  @override
  Future<void> insertMCQ(MCQModel mcq) async {
    try {
      final client = await databaseHelper.database;
      final mcqMap = mcq.toMap();
      final newId = mcqMap['id'] ?? _uuid.v4();
      mcqMap['id'] = newId;

      await client.from('mcqs').upsert(mcqMap);

      final progress = QuestionProgressModel(
        mcqId: newId,
        timesAttempted: 0,
        timesCorrect: 0,
        timesIncorrect: 0,
        lastAttempted: DateTime.now(),
        repetitionLevel: 0,
        userId: databaseHelper.currentUserId,
      );

      await client.from('question_progress').upsert(progress.toMap());
    } catch (e) {
      print('Error inserting MCQ: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateMCQ(MCQModel mcq) async {
    try {
      final client = await databaseHelper.database;
      await client
          .from('mcqs')
          .update(mcq.toMap())
          .eq('id', mcq.id);
    } catch (e) {
      print('Error updating MCQ: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteMCQ(String id) async {
    try {
      final client = await databaseHelper.database;
      await client.from('mcqs').delete().eq('id', id);
    } catch (e) {
      print('Error deleting MCQ: $e');
      rethrow;
    }
  }

  @override
  Future<void> insertUserAnswer(UserAnswerModel answer) async {
    try {
      final client = await databaseHelper.database;
      final answerMap = answer.toMap();
      answerMap['id'] = answerMap['id'] ?? _uuid.v4();

      await client.from('user_answers').insert(answerMap);
    } catch (e) {
      print('Error inserting user answer: $e');
      rethrow;
    }
  }

  @override
  Future<List<UserAnswerModel>> getUserAnswers() async {
    try {
      final client = await databaseHelper.database;
      final response = await client
          .from('user_answers')
          .select()
          .order('answeredAt', ascending: false);

      if (response.isEmpty) return [];

      return (response as List)
          .map((map) => UserAnswerModel.fromMap(map))
          .toList();
    } catch (e) {
      print('Error fetching user answers: $e');
      return [];
    }
  }

  @override
  Future<List<UserAnswerModel>> getUserAnswersByMCQId(String mcqId) async {
    try {
      final client = await databaseHelper.database;
      final response = await client
          .from('user_answers')
          .select()
          .eq('mcqId', mcqId)
          .order('answeredAt', ascending: false);

      if (response.isEmpty) return [];

      return (response as List)
          .map((map) => UserAnswerModel.fromMap(map))
          .toList();
    } catch (e) {
      print('Error fetching user answers by MCQ ID: $e');
      return [];
    }
  }

  @override
  Future<QuestionProgressModel?> getQuestionProgress(String mcqId) async {
    try {
      final client = await databaseHelper.database;
      final response = await client
          .from('question_progress')
          .select()
          .eq('mcqId', mcqId)
          .single()
          .catchError((_) => null);

      if (response == null) return null;
      return QuestionProgressModel.fromMap(response);
    } catch (e) {
      print('Error fetching question progress: $e');
      return null;
    }
  }

  @override
  Future<void> updateQuestionProgress(QuestionProgressModel progress) async {
    try {
      final client = await databaseHelper.database;
      await client
          .from('question_progress')
          .upsert(progress.toMap())
          .eq('mcqId', progress.mcqId);
    } catch (e) {
      print('Error updating question progress: $e');
      rethrow;
    }
  }

  @override
  Future<List<QuestionProgressModel>> getAllQuestionProgress() async {
    try {
      final client = await databaseHelper.database;
      final response = await client
          .from('question_progress')
          .select();

      if (response.isEmpty) return [];

      return (response as List)
          .map((map) => QuestionProgressModel.fromMap(map))
          .toList();
    } catch (e) {
      print('Error fetching all question progress: $e');
      return [];
    }
  }

  @override
  Future<void> submitAnswerWithProgress({
    required UserAnswerModel answer,
    required bool isCorrect,
  }) async {
    try {
      final client = await databaseHelper.database;

      final answerMap = answer.toMap();
      answerMap['id'] = answerMap['id'] ?? _uuid.v4();
      await client.from('user_answers').insert(answerMap);

      final progressResponse = await client
          .from('question_progress')
          .select()
          .eq('mcqId', answer.mcqId)
          .single()
          .catchError((_) => null);

      if (progressResponse != null) {
        final progress = QuestionProgressModel.fromMap(progressResponse);
        final newProgress = _calculateSpacedRepetition(progress, isCorrect);
        await updateQuestionProgress(newProgress);
      }
    } catch (e) {
      print('Error in submitAnswerWithProgress: $e');
      rethrow;
    }
  }

  @override
  Future<List<MCQModel>> getQuestionsForReview() async {
    try {
      final client = await databaseHelper.database;
      final now = DateTime.now().toIso8601String();

      final progressResponse = await client
          .from('question_progress')
          .select()
          .or('nextReviewDate.is.null,nextReviewDate.lt.$now')
          .order('lastAttempted', ascending: true);

      if (progressResponse.isEmpty) return [];

      final progressList = (progressResponse as List)
          .map((map) => QuestionProgressModel.fromMap(map))
          .toList();

      final mcqIds = progressList.map((p) => p.mcqId).toList();
      if (mcqIds.isEmpty) return [];

      final mcqsResponse = await client
          .from('mcqs')
          .select()
          .inFilter('id', mcqIds);

      if (mcqsResponse.isEmpty) return [];

      return (mcqsResponse as List)
          .map((map) => MCQModel.fromMap(map))
          .toList();
    } catch (e) {
      print('Error fetching review questions: $e');
      return [];
    }
  }

  QuestionProgressModel _calculateSpacedRepetition(
      QuestionProgressModel progress,
      bool isCorrect,
      ) {
    int newRepetitionLevel = progress.repetitionLevel;
    DateTime? nextReview;

    if (isCorrect) {
      newRepetitionLevel = progress.repetitionLevel + 1;
      final intervals = [1, 3, 7, 14, 30];
      final intervalIndex = newRepetitionLevel.clamp(0, intervals.length - 1);
      nextReview = DateTime.now().add(Duration(days: intervals[intervalIndex]));
    } else {
      newRepetitionLevel = 0;
      nextReview = DateTime.now().add(const Duration(hours: 1));
    }

    return QuestionProgressModel(
      mcqId: progress.mcqId,
      timesAttempted: progress.timesAttempted + 1,
      timesCorrect: progress.timesCorrect + (isCorrect ? 1 : 0),
      timesIncorrect: progress.timesIncorrect + (isCorrect ? 0 : 1),
      lastAttempted: DateTime.now(),
      nextReviewDate: nextReview,
      repetitionLevel: newRepetitionLevel,
      userId: progress.userId,
    );
  }
}
