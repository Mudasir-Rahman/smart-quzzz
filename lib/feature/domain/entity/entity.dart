
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

  // Add fromJson factory constructor
  factory MCQ.fromJson(Map<String, dynamic> json) {
    return MCQ(
      id: json['id']?.toString() ?? '',
      question: json['question']?.toString() ?? '',
      options: List<String>.from(json['options'] ?? []),
      correctAnswerIndex: json['correct_answer_index'] as int? ?? 0,
      explanation: json['explanation']?.toString(),
      category: json['category']?.toString() ?? '',
      difficultyLevel: json['difficulty_level'] as int? ?? 1,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'].toString())
          : DateTime.now(),
    );
  }

  // Add toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'correct_answer_index': correctAnswerIndex,
      'explanation': explanation,
      'category': category,
      'difficulty_level': difficultyLevel,
      'created_at': createdAt.toIso8601String(),
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

  // Add fromJson factory constructor
  factory UserAnswer.fromJson(Map<String, dynamic> json) {
    return UserAnswer(
      id: json['id']?.toString() ?? '',
      mcqId: json['mcq_id']?.toString() ?? '',
      selectedAnswerIndex: json['selected_answer_index'] as int? ?? 0,
      isCorrect: json['is_correct'] as bool? ?? false,
      answeredAt: json['answered_at'] != null
          ? DateTime.parse(json['answered_at'].toString())
          : DateTime.now(),
      timeSpentSeconds: json['time_spent_seconds'] as int? ?? 0,
    );
  }

  // Add toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mcq_id': mcqId,
      'selected_answer_index': selectedAnswerIndex,
      'is_correct': isCorrect,
      'answered_at': answeredAt.toIso8601String(),
      'time_spent_seconds': timeSpentSeconds,
    };
  }

  @override
  List<Object?> get props => [
    id,
    mcqId,
    selectedAnswerIndex,
    isCorrect,
    answeredAt,
    timeSpentSeconds,
  ];
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

  // Add fromJson factory constructor
  factory QuestionProgress.fromJson(Map<String, dynamic> json) {
    return QuestionProgress(
      mcqId: json['mcq_id']?.toString() ?? '',
      timesAttempted: json['times_attempted'] as int? ?? 0,
      timesCorrect: json['times_correct'] as int? ?? 0,
      timesIncorrect: json['times_incorrect'] as int? ?? 0,
      lastAttempted: json['last_attempted'] != null
          ? DateTime.parse(json['last_attempted'].toString())
          : DateTime.now(),
      nextReviewDate: json['next_review_date'] != null
          ? DateTime.parse(json['next_review_date'].toString())
          : null,
      repetitionLevel: json['repetition_level'] as int? ?? 0,
    );
  }

  // Add toJson method
  Map<String, dynamic> toJson() {
    return {
      'mcq_id': mcqId,
      'times_attempted': timesAttempted,
      'times_correct': timesCorrect,
      'times_incorrect': timesIncorrect,
      'last_attempted': lastAttempted.toIso8601String(),
      'next_review_date': nextReviewDate?.toIso8601String(),
      'repetition_level': repetitionLevel,
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

  // Add fromJson factory constructor (optional - this is usually calculated)
  factory OverallProgress.fromJson(Map<String, dynamic> json) {
    return OverallProgress(
      totalQuestionsAttempted: json['total_questions_attempted'] as int? ?? 0,
      totalCorrectAnswers: json['total_correct_answers'] as int? ?? 0,
      totalIncorrectAnswers: json['total_incorrect_answers'] as int? ?? 0,
      currentStreak: json['current_streak'] as int? ?? 0,
      longestStreak: json['longest_streak'] as int? ?? 0,
      categoryPerformance: Map<String, int>.from(json['category_performance'] ?? {}),
    );
  }

  // Add toJson method
  Map<String, dynamic> toJson() {
    return {
      'total_questions_attempted': totalQuestionsAttempted,
      'total_correct_answers': totalCorrectAnswers,
      'total_incorrect_answers': totalIncorrectAnswers,
      'current_streak': currentStreak,
      'longest_streak': longestStreak,
      'category_performance': categoryPerformance,
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