//
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:uuid/uuid.dart';
// import 'package:quiez_assigenment/feature/domain/entity/entity.dart';
// import '../model/model.dart';
//
// class SupabaseHelper {
//   static final SupabaseHelper instance = SupabaseHelper._init();
//   static SupabaseClient? _client;
//   final Uuid _uuid = const Uuid();
//
//   SupabaseHelper._init();
//
//   Future<SupabaseClient> get database async {
//     if (_client != null) return _client!;
//     _client = Supabase.instance.client;
//     return _client!;
//   }
//
//   String generateId() => _uuid.v4();
//
//   // Get current logged-in userId
//   String get currentUserId {
//     final user = Supabase.instance.client.auth.currentUser;
//     if (user == null) throw Exception('No logged-in user found');
//     return user.id;
//   }
//
//   // ---------------- MCQs ----------------
//   Future<List<MCQ>> getAllMCQs() async {
//     try {
//       final client = await database;
//       final response = await client
//           .from('mcqs')
//           .select()
//           .order('createdAt', ascending: false);
//
//       if (response.isEmpty) return [];
//
//       return (response as List)
//           .map((json) => MCQModel.fromMap(json))
//           .toList();
//     } catch (e) {
//       print('Error fetching MCQs: $e');
//       return [];
//     }
//   }
//
//   Future<MCQ?> getMCQById(String mcqId) async {
//     try {
//       final client = await database;
//       final response = await client
//           .from('mcqs')
//           .select()
//           .eq('id', mcqId)
//           .maybeSingle();
//
//       return response != null ? MCQModel.fromMap(response) : null;
//     } catch (e) {
//       print('Error fetching MCQ by ID: $e');
//       return null;
//     }
//   }
//
//   Future<void> addMCQ(MCQ mcq) async {
//     try {
//       final client = await database;
//       final mcqModel = MCQModel.fromEntity(mcq);
//
//       await client.from('mcqs').upsert(mcqModel.toMap());
//     } catch (e) {
//       print('Error adding MCQ: $e');
//       rethrow;
//     }
//   }
//
//   Future<void> updateMCQ(MCQ mcq) async {
//     try {
//       final client = await database;
//       final mcqModel = MCQModel.fromEntity(mcq);
//
//       await client
//           .from('mcqs')
//           .update(mcqModel.toMap())
//           .eq('id', mcq.id);
//     } catch (e) {
//       print('Error updating MCQ: $e');
//       rethrow;
//     }
//   }
//
//   Future<void> deleteMCQ(String mcqId) async {
//     try {
//       final client = await database;
//
//       await client
//           .from('mcqs')
//           .delete()
//           .eq('id', mcqId);
//     } catch (e) {
//       print('Error deleting MCQ: $e');
//       rethrow;
//     }
//   }
//
//   // ---------------- User Answers ----------------
//   Future<void> submitAnswer(UserAnswer answer) async {
//     try {
//       final client = await database;
//       final userId = currentUserId;
//       final answerModel = UserAnswerModel.fromEntity(answer);
//       final answerJson = answerModel.toMap();
//       answerJson['id'] = answerJson['id'] ?? generateId();
//       answerJson['userId'] = userId;
//
//       await client.from('user_answers').upsert(answerJson);
//     } catch (e) {
//       print('Error submitting answer: $e');
//       rethrow;
//     }
//   }
//
//   Future<List<UserAnswer>> getUserAnswers() async {
//     try {
//       final client = await database;
//       final userId = currentUserId;
//
//       final response = await client
//           .from('user_answers')
//           .select()
//           .eq('userId', userId)
//           .order('answeredAt', ascending: false); // Fixed: camelCase
//
//       return (response as List)
//           .map((json) => UserAnswerModel.fromMap(json))
//           .toList();
//     } catch (e) {
//       print('Error fetching user answers: $e');
//       return [];
//     }
//   }
//
//   // ---------------- Question Progress ----------------
//   Future<QuestionProgress?> getQuestionProgress(String mcqId) async {
//     try {
//       final client = await database;
//       final userId = currentUserId;
//
//       final response = await client
//           .from('question_progress')
//           .select()
//           .eq('mcqId', mcqId)
//           .eq('userId', userId)
//           .maybeSingle();
//
//       return response != null ? QuestionProgressModel.fromMap(response) : null;
//     } catch (e) {
//       print('Error fetching question progress: $e');
//       return null;
//     }
//   }
//
//   Future<void> updateQuestionProgress(QuestionProgress progress) async {
//     try {
//       final client = await database;
//       final userId = currentUserId;
//       final progressModel = QuestionProgressModel.fromEntity(progress);
//       final progressJson = progressModel.toMap();
//       progressJson['userId'] = userId;
//
//       await client
//           .from('question_progress')
//           .upsert(progressJson)
//           .eq('mcqId', progress.mcqId)
//           .eq('userId', userId);
//     } catch (e) {
//       print('Error updating question progress: $e');
//       rethrow;
//     }
//   }
//
//   Future<OverallProgress> getOverallProgress() async {
//     try {
//       final answers = await getUserAnswers();
//       final mcqs = await getAllMCQs();
//
//       int totalCorrect = 0;
//       int totalIncorrect = 0;
//       int currentStreak = 0;
//       int longestStreak = 0;
//       int tempStreak = 0;
//       Map<String, int> categoryPerformance = {};
//
//       final sortedAnswers = List<UserAnswer>.from(answers)
//         ..sort((a, b) => a.answeredAt.compareTo(b.answeredAt));
//
//       for (var answer in sortedAnswers) {
//         if (answer.isCorrect) {
//           totalCorrect++;
//           tempStreak++;
//           if (tempStreak > longestStreak) longestStreak = tempStreak;
//         } else {
//           totalIncorrect++;
//           tempStreak = 0;
//         }
//       }
//
//       for (var i = sortedAnswers.length - 1; i >= 0; i--) {
//         if (sortedAnswers[i].isCorrect) currentStreak++;
//         else break;
//       }
//
//       for (var mcq in mcqs) {
//         final answerCount = answers
//             .where((a) => a.mcqId == mcq.id && a.isCorrect)
//             .length;
//         categoryPerformance[mcq.category] =
//             (categoryPerformance[mcq.category] ?? 0) + answerCount;
//       }
//
//       return OverallProgress(
//         totalQuestionsAttempted: answers.length,
//         totalCorrectAnswers: totalCorrect,
//         totalIncorrectAnswers: totalIncorrect,
//         currentStreak: currentStreak,
//         longestStreak: longestStreak,
//         categoryPerformance: categoryPerformance,
//       );
//     } catch (e) {
//       print('Error calculating overall progress: $e');
//       return OverallProgress(
//         totalQuestionsAttempted: 0,
//         totalCorrectAnswers: 0,
//         totalIncorrectAnswers: 0,
//         currentStreak: 0,
//         longestStreak: 0,
//         categoryPerformance: {},
//       );
//     }
//   }
//
//   // ---------------- Questions for Review ----------------
//   Future<List<MCQ>> getQuestionsForReview() async {
//     try {
//       final client = await database;
//       final userId = currentUserId;
//       final now = DateTime.now().toIso8601String();
//
//       final progressResponse = await client
//           .from('question_progress')
//           .select()
//           .eq('userId', userId)
//           .or('nextReviewDate.is.null,nextReviewDate.lt.$now')
//           .order('lastAttempted', ascending: true);
//
//       if (progressResponse.isEmpty) return [];
//
//       final progressList = (progressResponse as List)
//           .map((json) => QuestionProgressModel.fromMap(json))
//           .toList();
//
//       final mcqIds = progressList.map((p) => p.mcqId).toList();
//       if (mcqIds.isEmpty) return [];
//
//       final mcqsResponse = await client
//           .from('mcqs')
//           .select()
//           .inFilter('id', mcqIds);
//
//       return (mcqsResponse as List)
//           .map((json) => MCQModel.fromMap(json))
//           .toList();
//     } catch (e) {
//       print('Error fetching review questions: $e');
//       return [];
//     }
//   }
// }
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:quiez_assigenment/feature/domain/entity/entity.dart';
import '../model/model.dart';

class SupabaseHelper {
  static final SupabaseHelper instance = SupabaseHelper._init();
  static SupabaseClient? _client;
  final Uuid _uuid = const Uuid();

  SupabaseHelper._init();

  Future<SupabaseClient> get database async {
    if (_client != null) return _client!;
    _client = Supabase.instance.client;
    return _client!;
  }

  String generateId() => _uuid.v4();

  // Get current logged-in userId
  String get currentUserId {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) throw Exception('No logged-in user found');
    return user.id;
  }

  // ---------------- MCQs ----------------
  Future<List<MCQ>> getAllMCQs() async {
    try {
      final client = await database;
      final response = await client
          .from('mcqs')
          .select()
          .order('"createdAt"', ascending: false);

      if (response.isEmpty) return [];

      return (response as List)
          .map((json) => MCQModel.fromMap(json))
          .toList();
    } catch (e) {
      print('Error fetching MCQs: $e');
      return [];
    }
  }

  Future<MCQ?> getMCQById(String mcqId) async {
    try {
      final client = await database;
      final response = await client
          .from('mcqs')
          .select()
          .eq('id', mcqId)
          .maybeSingle();

      return response != null ? MCQModel.fromMap(response) : null;
    } catch (e) {
      print('Error fetching MCQ by ID: $e');
      return null;
    }
  }

  Future<void> addMCQ(MCQ mcq) async {
    try {
      final client = await database;
      final userId = currentUserId;
      final mcqModel = MCQModel.fromEntity(mcq, userId);

      await client.from('mcqs').upsert(mcqModel.toMap());
    } catch (e) {
      print('Error adding MCQ: $e');
      rethrow;
    }
  }

  Future<void> updateMCQU(MCQ mcq) async {
    try {
      final client = await database;
      final userId = currentUserId;
      final mcqModel = MCQModel.fromEntity(mcq, userId);

      await client
          .from('mcqs')
          .update(mcqModel.toMap())
          .eq('id', mcq.id);
    } catch (e) {
      print('Error updating MCQ: $e');
      rethrow;
    }
  }

  Future<void> deleteMCQ(String mcqId) async {
    try {
      final client = await database;

      await client
          .from('mcqs')
          .delete()
          .eq('id', mcqId);
    } catch (e) {
      print('Error deleting MCQ: $e');
      rethrow;
    }
  }

  // ---------------- User Answers ----------------
  Future<void> submitAnswer(UserAnswer answer) async {
    try {
      final client = await database;
      final userId = currentUserId;
      final answerModel = UserAnswerModel.fromEntity(answer, userId);
      final answerJson = answerModel.toMap();
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
      final userId = currentUserId;

      final response = await client
          .from('user_answers')
          .select()
          .eq('"userId"', userId)
          .order('"answeredAt"', ascending: false);

      return (response as List)
          .map((json) => UserAnswerModel.fromMap(json))
          .toList();
    } catch (e) {
      print('Error fetching user answers: $e');
      return [];
    }
  }

  // ---------------- Question Progress ----------------
  Future<QuestionProgress?> getQuestionProgress(String mcqId) async {
    try {
      final client = await database;
      final userId = currentUserId;

      final response = await client
          .from('question_progress')
          .select()
          .eq('"mcqId"', mcqId)
          .eq('"userId"', userId)
          .maybeSingle();

      return response != null ? QuestionProgressModel.fromMap(response) : null;
    } catch (e) {
      print('Error fetching question progress: $e');
      return null;
    }
  }

  Future<void> updateQuestionProgress(QuestionProgress progress) async {
    try {
      final client = await database;
      final userId = currentUserId;
      final progressModel = QuestionProgressModel.fromEntity(progress, userId);
      final progressJson = progressModel.toMap();

      await client
          .from('question_progress')
          .upsert(progressJson)
          .eq('"mcqId"', progress.mcqId)
          .eq('"userId"', userId);
    } catch (e) {
      print('Error updating question progress: $e');
      rethrow;
    }
  }

  // ---------------- Questions for Review ----------------
  Future<List<MCQ>> getQuestionsForReview() async {
    try {
      final client = await database;
      final userId = currentUserId;
      final now = DateTime.now().toIso8601String();

      final progressResponse = await client
          .from('question_progress')
          .select()
          .eq('"userId"', userId)
          .or('"nextReviewDate".is.null,"nextReviewDate".lt.$now')
          .order('"lastAttempted"', ascending: true);

      if (progressResponse.isEmpty) return [];

      final progressList = (progressResponse as List)
          .map((json) => QuestionProgressModel.fromMap(json))
          .toList();

      final mcqIds = progressList.map((p) => p.mcqId).toList();
      if (mcqIds.isEmpty) return [];

      final mcqsResponse = await client
          .from('mcqs')
          .select()
          .inFilter('id', mcqIds);

      return (mcqsResponse as List)
          .map((json) => MCQModel.fromMap(json))
          .toList();
    } catch (e) {
      print('Error fetching review questions: $e');
      return [];
    }
  }

  // ---------------- Overall Progress Calculation ----------------
  Future<OverallProgress> getOverallProgress() async {
    try {
      final answers = await getUserAnswers();
      final mcqs = await getAllMCQs();

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

      currentStreak = 0;
      for (var i = sortedAnswers.length - 1; i >= 0; i--) {
        if (sortedAnswers[i].isCorrect) {
          currentStreak++;
        } else {
          break;
        }
      }

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

  // ---------------- SIMPLE Analytics ----------------
  Future<Map<String, dynamic>> getSimpleAnalytics() async {
    try {
      final answers = await getUserAnswers();

      if (answers.isEmpty) {
        return {
          'totalAnswers': 0,
          'correctAnswers': 0,
          'incorrectAnswers': 0,
          'accuracy': 0.0,
          'recentAnswers': [],
        };
      }

      final total = answers.length;
      final correct = answers.where((a) => a.isCorrect).length;
      final accuracy = total > 0 ? (correct / total * 100.0) : 0.0;

      final recentAnswers = answers
          .take(10)
          .map((a) => {
        'id': a.id,
        'mcqId': a.mcqId,
        'isCorrect': a.isCorrect,
        'answeredAt': a.answeredAt.toIso8601String(),
      })
          .toList();

      return {
        'totalAnswers': total,
        'correctAnswers': correct,
        'incorrectAnswers': total - correct,
        'accuracy': accuracy,
        'recentAnswers': recentAnswers,
      };
    } catch (e) {
      print('Error in getSimpleAnalytics: $e');
      return {
        'totalAnswers': 0,
        'correctAnswers': 0,
        'incorrectAnswers': 0,
        'accuracy': 0.0,
        'recentAnswers': [],
      };
    }
  }

}
