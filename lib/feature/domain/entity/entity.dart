
import 'dart:convert';
import 'package:equatable/equatable.dart';

class MCQ extends Equatable {
  final String id;
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String? explanation;
  final String category;
  final int difficultyLevel;
  final DateTime createdAt;

  const MCQ({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    this.explanation,
    required this.category,
    this.difficultyLevel = 1,
    required this.createdAt,
  });

  factory MCQ.fromJson(Map<String, dynamic> json) {
    List<String> optionsList = [];
    if (json['options'] != null) {
      if (json['options'] is String) {
        optionsList = List<String>.from(jsonDecode(json['options']));
      } else if (json['options'] is List) {
        optionsList = List<String>.from(json['options']);
      }
    }

    return MCQ(
      id: json['id']?.toString() ?? '',
      question: json['question']?.toString() ?? '',
      options: optionsList,
      correctAnswerIndex: json['correctanswerindex'] as int? ?? 0,
      explanation: json['explanation']?.toString(),
      category: json['category']?.toString() ?? '',
      difficultyLevel: json['difficultylevel'] as int? ?? 1,
      createdAt: json['createdat'] != null
          ? DateTime.parse(json['createdat'].toString())
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'options': jsonEncode(options),
      'correctanswerindex': correctAnswerIndex,
      'explanation': explanation,
      'category': category,
      'difficultylevel': difficultyLevel,
      'createdat': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
    id,
    question,
    options,
    correctAnswerIndex,
    explanation,
    category,
    difficultyLevel,
    createdAt,
  ];
}

class UserAnswer extends Equatable {
  final String id;
  final String mcqId;
  final int selectedAnswerIndex;
  final bool isCorrect;
  final DateTime answeredAt;
  final int timeSpentSeconds;

  const UserAnswer({
    required this.id,
    required this.mcqId,
    required this.selectedAnswerIndex,
    required this.isCorrect,
    required this.answeredAt,
    this.timeSpentSeconds = 0,
  });

  factory UserAnswer.fromJson(Map<String, dynamic> json) {
    return UserAnswer(
      id: json['id']?.toString() ?? '',
      mcqId: json['mcqid']?.toString() ?? '',
      selectedAnswerIndex: json['selectedanswerindex'] as int? ?? 0,
      isCorrect: (json['iscorrect'] ?? 0) == 1,
      answeredAt: json['answeredat'] != null
          ? DateTime.parse(json['answeredat'].toString())
          : DateTime.now(),
      timeSpentSeconds: json['timespentseconds'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mcqid': mcqId,
      'selectedanswerindex': selectedAnswerIndex,
      'iscorrect': isCorrect ? 1 : 0,
      'answeredat': answeredAt.toIso8601String(),
      'timespentseconds': timeSpentSeconds,
    };
  }

  @override
  List<Object?> get props =>
      [id, mcqId, selectedAnswerIndex, isCorrect, answeredAt, timeSpentSeconds];
}

class QuestionProgress extends Equatable {
  final String mcqId;
  final int timesAttempted;
  final int timesCorrect;
  final int timesIncorrect;
  final DateTime lastAttempted;
  final DateTime? nextReviewDate;
  final int repetitionLevel;

  const QuestionProgress({
    required this.mcqId,
    required this.timesAttempted,
    required this.timesCorrect,
    required this.timesIncorrect,
    required this.lastAttempted,
    this.nextReviewDate,
    this.repetitionLevel = 0,
  });

  double get accuracy =>
      timesAttempted > 0 ? (timesCorrect / timesAttempted) * 100 : 0;

  factory QuestionProgress.fromJson(Map<String, dynamic> json) {
    return QuestionProgress(
      mcqId: json['mcqid']?.toString() ?? '',
      timesAttempted: json['timesattempted'] as int? ?? 0,
      timesCorrect: json['timescorrect'] as int? ?? 0,
      timesIncorrect: json['timesincorrect'] as int? ?? 0,
      lastAttempted: json['lastattempted'] != null
          ? DateTime.parse(json['lastattempted'].toString())
          : DateTime.now(),
      nextReviewDate: json['nextreviewdate'] != null
          ? DateTime.parse(json['nextreviewdate'].toString())
          : null,
      repetitionLevel: json['repetitionlevel'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mcqid': mcqId,
      'timesattempted': timesAttempted,
      'timescorrect': timesCorrect,
      'timesincorrect': timesIncorrect,
      'lastattempted': lastAttempted.toIso8601String(),
      'nextreviewdate': nextReviewDate?.toIso8601String(),
      'repetitionlevel': repetitionLevel,
    };
  }

  @override
  List<Object?> get props => [
    mcqId,
    timesAttempted,
    timesCorrect,
    timesIncorrect,
    lastAttempted,
    nextReviewDate,
    repetitionLevel,
  ];
}

class OverallProgress extends Equatable {
  final int totalQuestionsAttempted;
  final int totalCorrectAnswers;
  final int totalIncorrectAnswers;
  final int currentStreak;
  final int longestStreak;
  final Map<String, int> categoryPerformance;

  const OverallProgress({
    required this.totalQuestionsAttempted,
    required this.totalCorrectAnswers,
    required this.totalIncorrectAnswers,
    required this.currentStreak,
    required this.longestStreak,
    required this.categoryPerformance,
  });

  double get overallAccuracy => totalQuestionsAttempted > 0
      ? (totalCorrectAnswers / totalQuestionsAttempted) * 100
      : 0;

  factory OverallProgress.fromJson(Map<String, dynamic> json) {
    return OverallProgress(
      totalQuestionsAttempted: json['totalQuestionsAttempted'] as int? ?? 0,
      totalCorrectAnswers: json['totalCorrectAnswers'] as int? ?? 0,
      totalIncorrectAnswers: json['totalIncorrectAnswers'] as int? ?? 0,
      currentStreak: json['currentStreak'] as int? ?? 0,
      longestStreak: json['longestStreak'] as int? ?? 0,
      categoryPerformance: Map<String, int>.from(json['categoryPerformance'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalQuestionsAttempted': totalQuestionsAttempted,
      'totalCorrectAnswers': totalCorrectAnswers,
      'totalIncorrectAnswers': totalIncorrectAnswers,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'categoryPerformance': categoryPerformance,
    };
  }

  @override
  List<Object?> get props => [
    totalQuestionsAttempted,
    totalCorrectAnswers,
    totalIncorrectAnswers,
    currentStreak,
    longestStreak,
    categoryPerformance,
  ];
}
