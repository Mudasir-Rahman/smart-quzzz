// import 'package:dartz/dartz.dart';
// import '../../../core/error/failures.dart';
// import '../../../core/usecase/usecase.dart';
// import '../entity/entity.dart';
// import '../repository_interface/repository_interface.dart';
//
// class GetQuestionsForReview extends UseCase<List<MCQ>, NoParams> {
//   final MCQRepository repository;
//
//   GetQuestionsForReview(this.repository);
//
//   @override
//   Future<Either<Failures, List<MCQ>>> call(NoParams params) async {
//     try {
//       final mcqs = await repository.getQuestionsForReview();
//       return Right(mcqs);
//     } catch (e) {
//       return Left(ServerFailure(e.toString()));
//     }
//   }
// }
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entity/entity.dart';
import '../repository_interface/repository_interface.dart';

class GetQuestionsForReviewUseCase implements UseCase<List<MCQ>, NoParams> {
  final MCQRepository repository;

  GetQuestionsForReviewUseCase(this.repository);

  @override
  Future<Either<Failures, List<MCQ>>> call(NoParams params) async {
    return repository.getQuestionsForReview();
  }
}
