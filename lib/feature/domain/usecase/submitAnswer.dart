import '../../../core/usecase/usecase.dart';
import '../entity/entity.dart';
import '../repository_interface/repository_interface.dart';

class SubmitAnswer extends UseCase<void, SubmitAnswerParams> {
  final MCQRepository repository;

  SubmitAnswer(this.repository);

  @override
  Future<void> call(SubmitAnswerParams params) {
    final userAnswer = UserAnswer(
      id: params.id,
      mcqId: params.mcqId,
      selectedAnswerIndex: params.selectedOption,
      isCorrect: params.isCorrect,
      answeredAt: params.submittedAt,
      timeSpentSeconds: params.timeSpentSeconds,
    );
    return repository.submitAnswer(userAnswer);
  }
}

class SubmitAnswerParams {
  final String id;
  final String mcqId;
  final int selectedOption;
  final bool isCorrect;
  final DateTime submittedAt;
  final int timeSpentSeconds;

  const SubmitAnswerParams({
    required this.id,
    required this.mcqId,
    required this.selectedOption,
    required this.isCorrect,
    required this.submittedAt,
    this.timeSpentSeconds = 0,
  });
}
