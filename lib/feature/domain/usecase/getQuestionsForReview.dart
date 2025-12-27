import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entity/entity.dart';
import '../repository_interface/repository_interface.dart';

class GetQuestionsForReviewUseCase implements UseCase<List<MCQ>, String> {
  final MCQRepository repository;

  GetQuestionsForReviewUseCase(this.repository);

  @override
  Future<Either<Failures, List<MCQ>>> call(String params) async {
    return repository.getQuestionsForReview(params);
  }
}
