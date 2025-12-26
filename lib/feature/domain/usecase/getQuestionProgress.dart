import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entity/entity.dart';
import '../repository_interface/repository_interface.dart';

class GetQuestionProgressUseCase implements UseCase<QuestionProgress?, String> {
  final MCQRepository repository;

  GetQuestionProgressUseCase(this.repository);

  @override
  Future<Either<Failures, QuestionProgress?>> call(String mcqId) async {
    return repository.getQuestionProgress(mcqId);
  }
}
