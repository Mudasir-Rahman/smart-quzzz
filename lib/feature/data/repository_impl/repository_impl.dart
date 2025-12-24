
import '../../domain/entity/entity.dart';
import '../../domain/repository_interface/repository_interface.dart';
import '../data_source/local_data_source.dart';
import '../model/model.dart';

class MCQRepositoryImpl implements MCQRepository {
  final LocalDataSource localDataSource;

  MCQRepositoryImpl({required this.localDataSource});

  @override
  Future<List<MCQ>> getAllMCQs() async {
    return await localDataSource.getAllMCQs();
  }

  @override
  Future<MCQ?> getMCQById(String id) async {
    return await localDataSource.getMCQById(id);
  }

  @override
  Future<void> addMCQ(MCQ mcq) async {
    final model = MCQModel.fromEntity(mcq);
    await localDataSource.insertMCQ(model);
  }

  @override
  Future<void> updateMCQ(MCQ mcq) async {
    final model = MCQModel.fromEntity(mcq);
    await localDataSource.updateMCQ(model);
  }

  @override
  Future<void> deleteMCQ(String id) async {
    await localDataSource.deleteMCQ(id);
  }

  @override
  Future<void> submitAnswer(UserAnswer answer) async {
    final answerModel = UserAnswerModel(
      id: answer.id,
      mcqId: answer.mcqId,
      selectedAnswerIndex: answer.selectedAnswerIndex,
      isCorrect: answer.isCorrect,
      answeredAt: answer.answeredAt,
      timeSpentSeconds: answer.timeSpentSeconds,
    );

    await localDataSource.insertUserAnswer(answerModel);

    // Update question progress with spaced repetition
    final progress = await localDataSource.getQuestionProgress(answer.mcqId);

    if (progress != null) {
      final newProgress = _calculateSpacedRepetition(progress, answer.isCorrect);
      await localDataSource.updateQuestionProgress(newProgress);
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
      // Spaced repetition intervals: 1 day, 3 days, 7 days, 14 days, 30 days
      final intervals = [1, 3, 7, 14, 30];
      final intervalIndex = newRepetitionLevel.clamp(0, intervals.length - 1);
      nextReview = DateTime.now().add(Duration(days: intervals[intervalIndex]));
    } else {
      // Reset repetition level if incorrect
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
    );
  }

  @override
  Future<List<UserAnswer>> getUserAnswers() async {
    return await localDataSource.getUserAnswers();
  }

  @override
  Future<QuestionProgress?> getQuestionProgress(String mcqId) async {
    return await localDataSource.getQuestionProgress(mcqId);
  }

  @override
  Future<OverallProgress> getOverallProgress() async {
    final answers = await localDataSource.getUserAnswers();
    final progressList = await localDataSource.getAllQuestionProgress();

    int totalCorrect = 0;
    int totalIncorrect = 0;
    int currentStreak = 0;
    int longestStreak = 0;
    int tempStreak = 0;
    Map<String, int> categoryPerformance = {};

    // Sort answers by date
    final sortedAnswers = List<UserAnswer>.from(answers)
      ..sort((a, b) => a.answeredAt.compareTo(b.answeredAt));

    for (var answer in sortedAnswers) {
      if (answer.isCorrect) {
        totalCorrect++;
        tempStreak++;
        if (tempStreak > longestStreak) {
          longestStreak = tempStreak;
        }
      } else {
        totalIncorrect++;
        tempStreak = 0;
      }
    }

    // Calculate current streak from most recent answers
    for (var i = sortedAnswers.length - 1; i >= 0; i--) {
      if (sortedAnswers[i].isCorrect) {
        currentStreak++;
      } else {
        break;
      }
    }

    // Calculate category performance
    final mcqs = await localDataSource.getAllMCQs();
    for (var mcq in mcqs) {
      final mcqProgress = progressList.firstWhere(
            (p) => p.mcqId == mcq.id,
        orElse: () => QuestionProgressModel(
          mcqId: mcq.id,
          timesAttempted: 0,
          timesCorrect: 0,
          timesIncorrect: 0,
          lastAttempted: DateTime.now(),
          repetitionLevel: 0,
        ),
      );

      categoryPerformance[mcq.category] =
          (categoryPerformance[mcq.category] ?? 0) + mcqProgress.timesCorrect;
    }

    return OverallProgress(
      totalQuestionsAttempted: answers.length,
      totalCorrectAnswers: totalCorrect,
      totalIncorrectAnswers: totalIncorrect,
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      categoryPerformance: categoryPerformance,
    );
  }

  @override
  Future<List<MCQ>> getQuestionsForReview() async {
    final progressList = await localDataSource.getAllQuestionProgress();
    final now = DateTime.now();

    // Get questions that need review based on spaced repetition
    final questionsToReview = progressList.where((progress) {
      if (progress.nextReviewDate == null) return true;
      return progress.nextReviewDate!.isBefore(now);
    }).toList();

    // Sort by priority: incorrect questions first, then by last attempted
    questionsToReview.sort((a, b) {
      if (a.timesIncorrect > b.timesIncorrect) return -1;
      if (a.timesIncorrect < b.timesIncorrect) return 1;
      return a.lastAttempted.compareTo(b.lastAttempted);
    });

    final mcqs = <MCQ>[];
    for (var progress in questionsToReview) {
      final mcq = await localDataSource.getMCQById(progress.mcqId);
      if (mcq != null) mcqs.add(mcq);
    }

    return mcqs;
  }
}