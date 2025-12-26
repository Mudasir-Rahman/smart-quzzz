// import 'package:dartz/dartz.dart';
// import '../../../core/error/failures.dart';
// import '../../../core/usecase/usecase.dart';
// import '../entity/entity.dart';
// import '../repository_interface/repository_interface.dart';
//
// class GetOverallProgress extends UseCase<OverallProgress, NoParams> {
//   final MCQRepository repository;
//
//   GetOverallProgress(this.repository);
//
//   @override
//   Future<Either<Failures, OverallProgress>> call(NoParams params) async {
//     try {
//       final progress = await repository.getOverallProgress();
//       return Right(progress);
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

class GetOverallProgressUseCase implements UseCase<OverallProgress, NoParams> {
  final MCQRepository repository;

  GetOverallProgressUseCase(this.repository);

  @override
  Future<Either<Failures, OverallProgress>> call(NoParams params) async {
    return repository.getOverallProgress();
  }
}
