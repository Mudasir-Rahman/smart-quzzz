// //
// // import 'dart:convert';
// // import '../../domain/entity/entity.dart';
// //
// // class MCQModel extends MCQ {
// //   const MCQModel({
// //     required super.id,
// //     required super.question,
// //     required super.options,
// //     required super.correctAnswerIndex,
// //     super.explanation,
// //     required super.category,
// //     super.difficultyLevel,
// //     required super.createdAt,
// //   });
// //
// //   factory MCQModel.fromMap(Map<String, dynamic> map) {
// //     return MCQModel(
// //       id: map['id'] as String,
// //       question: map['question'] as String,
// //       options: (jsonDecode(map['options']) as List).cast<String>(),
// //       // FOR SUPABASE: Use snake_case keys
// //       correctAnswerIndex: map['correct_answer_index'] as int,
// //       explanation: map['explanation'] as String?,
// //       category: map['category'] as String,
// //       difficultyLevel: map['difficulty_level'] as int? ?? 1,
// //       createdAt: DateTime.parse(map['created_at'] as String),
// //     );
// //   }
// //
// //   Map<String, dynamic> toMap() {
// //     return {
// //       'id': id,
// //       'question': question,
// //       'options': jsonEncode(options),
// //       // FOR SUPABASE: Use snake_case keys
// //       'correct_answer_index': correctAnswerIndex,
// //       'explanation': explanation,
// //       'category': category,
// //       'difficulty_level': difficultyLevel,
// //       'created_at': createdAt.toIso8601String(),
// //     };
// //   }
// //
// //   factory MCQModel.fromEntity(MCQ mcq) {
// //     return MCQModel(
// //       id: mcq.id,
// //       question: mcq.question,
// //       options: mcq.options,
// //       correctAnswerIndex: mcq.correctAnswerIndex,
// //       explanation: mcq.explanation,
// //       category: mcq.category,
// //       difficultyLevel: mcq.difficultyLevel,
// //       createdAt: mcq.createdAt,
// //     );
// //   }
// // }
// //
// // class UserAnswerModel extends UserAnswer {
// //   const UserAnswerModel({
// //     required super.id,
// //     required super.mcqId,
// //     required super.selectedAnswerIndex,
// //     required super.isCorrect,
// //     required super.answeredAt,
// //     super.timeSpentSeconds,
// //   });
// //
// //   factory UserAnswerModel.fromMap(Map<String, dynamic> map) {
// //     return UserAnswerModel(
// //       id: map['id'] as String,
// //       // FOR SUPABASE: Use snake_case keys
// //       mcqId: map['mcq_id'] as String,
// //       selectedAnswerIndex: map['selected_answer_index'] as int,
// //       isCorrect: map['is_correct'] as bool,
// //       answeredAt: DateTime.parse(map['answered_at'] as String),
// //       timeSpentSeconds: map['time_spent_seconds'] as int? ?? 0,
// //     );
// //   }
// //
// //   Map<String, dynamic> toMap() {
// //     return {
// //       'id': id,
// //       // FOR SUPABASE: Use snake_case keys
// //       'mcq_id': mcqId,
// //       'selected_answer_index': selectedAnswerIndex,
// //       'is_correct': isCorrect,
// //       'answered_at': answeredAt.toIso8601String(),
// //       'time_spent_seconds': timeSpentSeconds,
// //     };
// //   }
// // }
// //
// // class QuestionProgressModel extends QuestionProgress {
// //   const QuestionProgressModel({
// //     required super.mcqId,
// //     required super.timesAttempted,
// //     required super.timesCorrect,
// //     required super.timesIncorrect,
// //     required super.lastAttempted,
// //     super.nextReviewDate,
// //     super.repetitionLevel,
// //   });
// //
// //   factory QuestionProgressModel.fromMap(Map<String, dynamic> map) {
// //     return QuestionProgressModel(
// //       // FOR SUPABASE: Use snake_case keys
// //       mcqId: map['mcq_id'] as String,
// //       timesAttempted: map['times_attempted'] as int,
// //       timesCorrect: map['times_correct'] as int,
// //       timesIncorrect: map['times_incorrect'] as int,
// //       lastAttempted: DateTime.parse(map['last_attempted'] as String),
// //       nextReviewDate: map['next_review_date'] != null
// //           ? DateTime.parse(map['next_review_date'] as String)
// //           : null,
// //       repetitionLevel: map['repetition_level'] as int? ?? 0,
// //     );
// //   }
// //
// //   Map<String, dynamic> toMap() {
// //     return {
// //       // FOR SUPABASE: Use snake_case keys
// //       'mcq_id': mcqId,
// //       'times_attempted': timesAttempted,
// //       'times_correct': timesCorrect,
// //       'times_incorrect': timesIncorrect,
// //       'last_attempted': lastAttempted.toIso8601String(),
// //       'next_review_date': nextReviewDate?.toIso8601String(),
// //       'repetition_level': repetitionLevel,
// //     };
// //   }
// // }
// // lib/features/mcq/data/model/model.dart
// import 'dart:convert';
// import '../../domain/entity/entity.dart';
//
// class MCQModel extends MCQ {
//   const MCQModel({
//     required super.id,
//     required super.question,
//     required super.options,
//     required super.correctAnswerIndex,
//     super.explanation,
//     required super.category,
//     super.difficultyLevel,
//     required super.createdAt,
//   });
//
//   factory MCQModel.fromMap(Map<String, dynamic> map) {
//     return MCQModel(
//       id: map['id'] as String,
//       question: map['question'] as String,
//       options: (jsonDecode(map['options']) as List).cast<String>(),
//       correctAnswerIndex: map['correctAnswerIndex'] as int, // camelCase
//       explanation: map['explanation'] as String?,
//       category: map['category'] as String,
//       difficultyLevel: map['difficultyLevel'] as int? ?? 1, // camelCase
//       createdAt: DateTime.parse(map['createdAt'] as String), // camelCase
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'question': question,
//       'options': jsonEncode(options),
//       'correctAnswerIndex': correctAnswerIndex, // camelCase
//       'explanation': explanation,
//       'category': category,
//       'difficultyLevel': difficultyLevel, // camelCase
//       'createdAt': createdAt.toIso8601String(), // camelCase
//     };
//   }
//
//   factory MCQModel.fromEntity(MCQ mcq) {
//     return MCQModel(
//       id: mcq.id,
//       question: mcq.question,
//       options: mcq.options,
//       correctAnswerIndex: mcq.correctAnswerIndex,
//       explanation: mcq.explanation,
//       category: mcq.category,
//       difficultyLevel: mcq.difficultyLevel,
//       createdAt: mcq.createdAt,
//     );
//   }
// }
// //
// class UserAnswerModel extends UserAnswer {
//   const UserAnswerModel({
//     required super.id,
//     required super.mcqId,
//     required super.selectedAnswerIndex,
//     required super.isCorrect,
//     required super.answeredAt,
//     super.timeSpentSeconds,
//   });
//
//   factory UserAnswerModel.fromMap(Map<String, dynamic> map) {
//     return UserAnswerModel(
//       id: map['id'] as String,
//       mcqId: map['mcqId'] as String, // camelCase
//       selectedAnswerIndex: map['selectedAnswerIndex'] as int, // camelCase
//       isCorrect: (map['isCorrect'] as int) == 1, // Your DB stores as int
//       answeredAt: DateTime.parse(map['answeredAt'] as String), // camelCase
//       timeSpentSeconds: map['timeSpentSeconds'] as int? ?? 0, // camelCase
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'mcqId': mcqId, // camelCase
//       'selectedAnswerIndex': selectedAnswerIndex, // camelCase
//       'isCorrect': isCorrect ? 1 : 0, // Store as int
//       'answeredAt': answeredAt.toIso8601String(), // camelCase
//       'timeSpentSeconds': timeSpentSeconds, // camelCase
//     };
//   }
// }
//
// class QuestionProgressModel extends QuestionProgress {
//   const QuestionProgressModel({
//     required super.mcqId,
//     required super.timesAttempted,
//     required super.timesCorrect,
//     required super.timesIncorrect,
//     required super.lastAttempted,
//     super.nextReviewDate,
//     super.repetitionLevel,
//   });
//
//   factory QuestionProgressModel.fromMap(Map<String, dynamic> map) {
//     return QuestionProgressModel(
//       mcqId: map['mcqId'] as String, // camelCase
//       timesAttempted: map['timesAttempted'] as int, // camelCase
//       timesCorrect: map['timesCorrect'] as int, // camelCase
//       timesIncorrect: map['timesIncorrect'] as int, // camelCase
//       lastAttempted: DateTime.parse(map['lastAttempted'] as String), // camelCase
//       nextReviewDate: map['nextReviewDate'] != null
//           ? DateTime.parse(map['nextReviewDate'] as String) // camelCase
//           : null,
//       repetitionLevel: map['repetitionLevel'] as int? ?? 0, // camelCase
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'mcqId': mcqId, // camelCase
//       'timesAttempted': timesAttempted, // camelCase
//       'timesCorrect': timesCorrect, // camelCase
//       'timesIncorrect': timesIncorrect, // camelCase
//       'lastAttempted': lastAttempted.toIso8601String(), // camelCase
//       'nextReviewDate': nextReviewDate?.toIso8601String(), // camelCase
//       'repetitionLevel': repetitionLevel, // camelCase
//     };
//   }
//
//   factory QuestionProgressModel.fromEntity(QuestionProgress progress) {
//     return QuestionProgressModel(
//       mcqId: progress.mcqId,
//       timesAttempted: progress.timesAttempted,
//       timesCorrect: progress.timesCorrect,
//       timesIncorrect: progress.timesIncorrect,
//       lastAttempted: progress.lastAttempted,
//       nextReviewDate: progress.nextReviewDate,
//       repetitionLevel: progress.repetitionLevel,
//     );
//   }
// }
import 'dart:convert';
import '../../domain/entity/entity.dart';

class MCQModel extends MCQ {
  const MCQModel({
    required super.id,
    required super.question,
    required super.options,
    required super.correctAnswerIndex,
    super.explanation,
    required super.category,
    super.difficultyLevel,
    required super.createdAt,
  });

  factory MCQModel.fromMap(Map<String, dynamic> map) {
    return MCQModel(
      id: map['id'] as String,
      question: map['question'] as String,
      options: (jsonDecode(map['options']) as List).cast<String>(),
      correctAnswerIndex: map['correctAnswerIndex'] as int,
      explanation: map['explanation'] as String?,
      category: map['category'] as String,
      difficultyLevel: map['difficultyLevel'] as int? ?? 1,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'options': jsonEncode(options),
      'correctAnswerIndex': correctAnswerIndex,
      'explanation': explanation,
      'category': category,
      'difficultyLevel': difficultyLevel,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory MCQModel.fromEntity(MCQ mcq, String userId) {
    return MCQModel(
      id: mcq.id,
      question: mcq.question,
      options: mcq.options,
      correctAnswerIndex: mcq.correctAnswerIndex,
      explanation: mcq.explanation,
      category: mcq.category,
      difficultyLevel: mcq.difficultyLevel,
      createdAt: mcq.createdAt,
    );
  }
}

class UserAnswerModel extends UserAnswer {
  final String userId; // NEW: matches your Supabase schema

  const UserAnswerModel({
    required super.id,
    required this.userId, // NEW
    required super.mcqId,
    required super.selectedAnswerIndex,
    required super.isCorrect,
    required super.answeredAt,
    super.timeSpentSeconds,
  });

  factory UserAnswerModel.fromMap(Map<String, dynamic> map) {
    return UserAnswerModel(
      id: map['id'] as String,
      userId: map['userId'] as String, // camelCase from DB
      mcqId: map['mcqId'] as String,
      selectedAnswerIndex: map['selectedAnswerIndex'] as int,
      isCorrect: map['isCorrect'] is int
          ? (map['isCorrect'] as int) == 1
          : (map['isCorrect'] as bool),
      answeredAt: DateTime.parse(map['answeredAt'] as String),
      timeSpentSeconds: map['timeSpentSeconds'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId, // NEW
      'mcqId': mcqId,
      'selectedAnswerIndex': selectedAnswerIndex,
      'isCorrect': isCorrect ? 1 : 0,
      'answeredAt': answeredAt.toIso8601String(),
      'timeSpentSeconds': timeSpentSeconds,
    };
  }

  factory UserAnswerModel.fromEntity(UserAnswer answer, String userId) {
    return UserAnswerModel(
      id: answer.id,
      userId: userId, // pass current userId
      mcqId: answer.mcqId,
      selectedAnswerIndex: answer.selectedAnswerIndex,
      isCorrect: answer.isCorrect,
      answeredAt: answer.answeredAt,
      timeSpentSeconds: answer.timeSpentSeconds,
    );
  }
}

class QuestionProgressModel extends QuestionProgress {
  final String userId; // NEW: matches your Supabase schema

  const QuestionProgressModel({
    required this.userId, // NEW
    required super.mcqId,
    required super.timesAttempted,
    required super.timesCorrect,
    required super.timesIncorrect,
    required super.lastAttempted,
    super.nextReviewDate,
    super.repetitionLevel,
  });

  factory QuestionProgressModel.fromMap(Map<String, dynamic> map) {
    return QuestionProgressModel(
      userId: map['userId'] as String, // camelCase from DB
      mcqId: map['mcqId'] as String,
      timesAttempted: map['timesAttempted'] as int,
      timesCorrect: map['timesCorrect'] as int,
      timesIncorrect: map['timesIncorrect'] as int,
      lastAttempted: DateTime.parse(map['lastAttempted'] as String),
      nextReviewDate: map['nextReviewDate'] != null
          ? DateTime.parse(map['nextReviewDate'] as String)
          : null,
      repetitionLevel: map['repetitionLevel'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId, // NEW
      'mcqId': mcqId,
      'timesAttempted': timesAttempted,
      'timesCorrect': timesCorrect,
      'timesIncorrect': timesIncorrect,
      'lastAttempted': lastAttempted.toIso8601String(),
      'nextReviewDate': nextReviewDate?.toIso8601String(),
      'repetitionLevel': repetitionLevel,
    };
  }

  factory QuestionProgressModel.fromEntity(
      QuestionProgress progress, String userId) {
    return QuestionProgressModel(
      userId: userId, // pass current userId
      mcqId: progress.mcqId,
      timesAttempted: progress.timesAttempted,
      timesCorrect: progress.timesCorrect,
      timesIncorrect: progress.timesIncorrect,
      lastAttempted: progress.lastAttempted,
      nextReviewDate: progress.nextReviewDate,
      repetitionLevel: progress.repetitionLevel,
    );
  }
}
