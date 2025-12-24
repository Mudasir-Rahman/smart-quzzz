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

  factory MCQModel.fromEntity(MCQ mcq) {
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
  const UserAnswerModel({
    required super.id,
    required super.mcqId,
    required super.selectedAnswerIndex,
    required super.isCorrect,
    required super.answeredAt,
    super.timeSpentSeconds,
  });

  factory UserAnswerModel.fromMap(Map<String, dynamic> map) {
    return UserAnswerModel(
      id: map['id'] as String,
      mcqId: map['mcqId'] as String,
      selectedAnswerIndex: map['selectedAnswerIndex'] as int,
      isCorrect: (map['isCorrect'] as int) == 1,
      answeredAt: DateTime.parse(map['answeredAt'] as String),
      timeSpentSeconds: map['timeSpentSeconds'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'mcqId': mcqId,
      'selectedAnswerIndex': selectedAnswerIndex,
      'isCorrect': isCorrect ? 1 : 0,
      'answeredAt': answeredAt.toIso8601String(),
      'timeSpentSeconds': timeSpentSeconds,
    };
  }
}

class QuestionProgressModel extends QuestionProgress {
  const QuestionProgressModel({
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
      'mcqId': mcqId,
      'timesAttempted': timesAttempted,
      'timesCorrect': timesCorrect,
      'timesIncorrect': timesIncorrect,
      'lastAttempted': lastAttempted.toIso8601String(),
      'nextReviewDate': nextReviewDate?.toIso8601String(),
      'repetitionLevel': repetitionLevel,
    };
  }
}