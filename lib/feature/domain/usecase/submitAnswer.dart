// import 'package:dartz/dartz.dart';
// import '../../../core/error/failures.dart';
// import '../../../core/usecase/usecase.dart';
// import '../entity/entity.dart';
// import '../repository_interface/repository_interface.dart';
//
// class SubmitAnswer extends UseCase<void, SubmitAnswerParams> {
//   final MCQRepository repository;
//
//   SubmitAnswer(this.repository);
//
//   @override
//   Future<Either<Failures, void>> call(SubmitAnswerParams params) async {
//     try {
//       final userAnswer = UserAnswer(
//         id: params.id,
//         mcqId: params.mcqId,
//         selectedAnswerIndex: params.selectedOption,
//         isCorrect: params.isCorrect,
//         answeredAt: params.submittedAt,
//         timeSpentSeconds: params.timeSpentSeconds,
//       );
//       await repository.submitAnswer(userAnswer);
//       return const Right(null);
//     } catch (e) {
//       return Left(ServerFailure(e.toString()));
//     }
//   }
// }
//
// class SubmitAnswerParams {
//   final String id;
//   final String mcqId;
//   final int selectedOption;
//   final bool isCorrect;
//   final DateTime submittedAt;
//   final int timeSpentSeconds;
//
//   const SubmitAnswerParams({
//     required this.id,
//     required this.mcqId,
//     required this.selectedOption,
//     required this.isCorrect,
//     required this.submittedAt,
//     this.timeSpentSeconds = 0,
//   });
// }
import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecase/usecase.dart';
import '../entity/entity.dart';
import '../repository_interface/repository_interface.dart';

class SubmitAnswerParams {
  final String id;
  final String mcqId;
  final int selectedOption;
  final bool isCorrect;
  final DateTime submittedAt;
  final int timeSpentSeconds;

  SubmitAnswerParams({
    required this.id,
    required this.mcqId,
    required this.selectedOption,
    required this.isCorrect,
    required this.submittedAt,
    required this.timeSpentSeconds,
  });

  UserAnswer toUserAnswer() {
    return UserAnswer(
      id: id,
      mcqId: mcqId,
      selectedAnswerIndex: selectedOption,
      isCorrect: isCorrect,
      answeredAt: submittedAt,
      timeSpentSeconds: timeSpentSeconds,
    );
  }
}

class SubmitAnswerUseCase {
  final MCQRepository repository;
  SubmitAnswerUseCase(this.repository);

  Future<Either<Failures, void>> call(SubmitAnswerParams params) {
    return repository.submitAnswer(params.toUserAnswer());
  }
}
