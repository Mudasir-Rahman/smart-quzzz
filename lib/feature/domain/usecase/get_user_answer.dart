// import 'package:dartz/dartz.dart';
// import '../../../core/error/failures.dart';
// import '../../../core/usecase/usecase.dart';
// import '../entity/entity.dart';
// import '../repository_interface/repository_interface.dart';
//
// class GetUserAnswers extends UseCase<List<UserAnswer>, NoParams> {
//   final MCQRepository repository;
//
//   GetUserAnswers(this.repository);
//
//   @override
//   Future<Either<Failures, List<UserAnswer>>> call(NoParams params) async {
//     try {
//       final answers = await repository.getUserAnswers();
//       return Right(answers);
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

class GetUserAnswersUseCase implements UseCase<List<UserAnswer>, NoParams> {
  final MCQRepository repository;

  GetUserAnswersUseCase(this.repository);

  @override
  Future<Either<Failures, List<UserAnswer>>> call(NoParams params) async {
    return repository.getUserAnswers();
  }
}
