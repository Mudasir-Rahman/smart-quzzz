
import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:quiez_assigenment/feature/domain/entity/entity.dart';

class SupabaseHelper {
  static final SupabaseHelper instance = SupabaseHelper._init();
  static SupabaseClient? _client;
  final Uuid _uuid = Uuid();

  SupabaseHelper._init();

  Future<SupabaseClient> get database async {
    if (_client != null) return _client!;
    await Supabase.initialize(
      url: 'https://splrcftcnidwbjneigyl.supabase.co',
      anonKey: 'sb_publishable_HdFQk1WQXvDcqoGYVpPxYg_F6n1q7ra',
    );
    _client = Supabase.instance.client;
    return _client!;
  }

  String generateId() => _uuid.v4();

  // ----------------------
  // MCQ Methods
  // ----------------------
  Future<List<MCQ>> getAllMCQs() async {
    try {
      final client = await database;
      final response = await client
          .from('mcqs')
          .select()
          .order('createdat', ascending: false);

      return (response as List)
          .map((json) => MCQ.fromJson(json))
          .toList();
    } catch (e) {
      print('Error fetching MCQs: $e');
      return [];
    }
  }

  Future<MCQ?> getMCQById(String id) async {
    try {
      final client = await database;
      final response = await client
          .from('mcqs')
          .select()
          .eq('id', id)
          .maybeSingle();

      return response != null ? MCQ.fromJson(response) : null;
    } catch (e) {
      print('Error fetching MCQ by ID: $e');
      return null;
    }
  }

  Future<void> addMCQ(MCQ mcq) async {
    try {
      final client = await database;
      await client.from('mcqs').upsert(mcq.toJson());
    } catch (e) {
      print('Error adding MCQ: $e');
      rethrow;
    }
  }

  Future<void> updateMCQ(MCQ mcq) async {
    try {
      final client = await database;
      await client.from('mcqs').update(mcq.toJson()).eq('id', mcq.id);
    } catch (e) {
      print('Error updating MCQ: $e');
      rethrow;
    }
  }

  Future<void> deleteMCQ(String id) async {
    try {
      final client = await database;
      await client.from('mcqs').delete().eq('id', id);
    } catch (e) {
      print('Error deleting MCQ: $e');
      rethrow;
    }
  }

  // ----------------------
  // User Answers Methods
  // ----------------------
  Future<void> submitAnswer(UserAnswer answer) async {
    try {
      final client = await database;
      final answerJson = answer.toJson();
      answerJson['id'] = answerJson['id'] ?? generateId();
      await client.from('user_answers').upsert(answerJson);
    } catch (e) {
      print('Error submitting answer: $e');
      rethrow;
    }
  }

  Future<List<UserAnswer>> getUserAnswers() async {
    try {
      final client = await database;
      final response = await client
          .from('user_answers')
          .select()
          .order('answeredat', ascending: false);

      return (response as List)
          .map((json) => UserAnswer.fromJson(json))
          .toList();
    } catch (e) {
      print('Error fetching user answers: $e');
      return [];
    }
  }

  // ----------------------
  // Progress Methods
  // ----------------------
  Future<QuestionProgress?> getQuestionProgress(String mcqId) async {
    try {
      final client = await database;
      final response = await client
          .from('question_progress')
          .select()
          .eq('mcqid', mcqId)
          .maybeSingle();

      return response != null ? QuestionProgress.fromJson(response) : null;
    } catch (e) {
      print('Error fetching question progress: $e');
      return null;
    }
  }

  Future<void> updateQuestionProgress(QuestionProgress progress) async {
    try {
      final client = await database;
      await client
          .from('question_progress')
          .upsert(progress.toJson())
          .eq('mcqid', progress.mcqId);
    } catch (e) {
      print('Error updating question progress: $e');
      rethrow;
    }
  }

  Future<List<QuestionProgress>> getAllQuestionProgress() async {
    try {
      final client = await database;
      final response = await client
          .from('question_progress')
          .select()
          .order('lastattempted', ascending: false);

      return (response as List)
          .map((json) => QuestionProgress.fromJson(json))
          .toList();
    } catch (e) {
      print('Error fetching all question progress: $e');
      return [];
    }
  }

  Future<List<MCQ>> getQuestionsForReview() async {
    try {
      final client = await database;
      final now = DateTime.now().toIso8601String();

      final progressResponse = await client
          .from('question_progress')
          .select()
          .or('nextreviewdate.is.null,nextreviewdate.lt.$now')
          .order('lastattempted', ascending: true);

      if (progressResponse.isEmpty) return [];

      final progressList = (progressResponse as List)
          .map((json) => QuestionProgress.fromJson(json))
          .toList();

      final mcqIds = progressList.map((p) => p.mcqId).toList();
      if (mcqIds.isEmpty) return [];

      final mcqsResponse =
      await client.from('mcqs').select().inFilter('id', mcqIds);

      if (mcqsResponse.isEmpty) return [];

      return (mcqsResponse as List).map((json) => MCQ.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching review questions: $e');
      return [];
    }
  }

  Future<OverallProgress> getOverallProgress() async {
    try {
      final answers = await getUserAnswers();

      int totalCorrect = 0;
      int totalIncorrect = 0;
      int currentStreak = 0;
      int longestStreak = 0;
      int tempStreak = 0;
      Map<String, int> categoryPerformance = {};

      final sortedAnswers = List<UserAnswer>.from(answers)
        ..sort((a, b) => a.answeredAt.compareTo(b.answeredAt));

      for (var answer in sortedAnswers) {
        if (answer.isCorrect) {
          totalCorrect++;
          tempStreak++;
          if (tempStreak > longestStreak) longestStreak = tempStreak;
        } else {
          totalIncorrect++;
          tempStreak = 0;
        }
      }

      for (var i = sortedAnswers.length - 1; i >= 0; i--) {
        if (sortedAnswers[i].isCorrect) currentStreak++;
        else break;
      }

      final mcqs = await getAllMCQs();
      for (var mcq in mcqs) {
        final answerCount = answers
            .where((a) => a.mcqId == mcq.id && a.isCorrect)
            .length;
        categoryPerformance[mcq.category] =
            (categoryPerformance[mcq.category] ?? 0) + answerCount;
      }

      return OverallProgress(
        totalQuestionsAttempted: answers.length,
        totalCorrectAnswers: totalCorrect,
        totalIncorrectAnswers: totalIncorrect,
        currentStreak: currentStreak,
        longestStreak: longestStreak,
        categoryPerformance: categoryPerformance,
      );
    } catch (e) {
      print('Error calculating overall progress: $e');
      return OverallProgress(
        totalQuestionsAttempted: 0,
        totalCorrectAnswers: 0,
        totalIncorrectAnswers: 0,
        currentStreak: 0,
        longestStreak: 0,
        categoryPerformance: {},
      );
    }
  }
}
