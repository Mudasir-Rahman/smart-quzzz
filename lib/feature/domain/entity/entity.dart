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