// import 'package:dartz/dartz.dart';
// import '../../../core/error/failures.dart';
// import '../../../core/usecase/usecase.dart';
// import '../entity/entity.dart';
// import '../repository_interface/repository_interface.dart';
//
// class UpdateMCQ extends UseCase<void, MCQ> {
//   final MCQRepository repository;
//
//   UpdateMCQ(this.repository);
//
//   @override
//   Future<Either<Failures, void>> call(MCQ mcq) async {
//     try {
//       await repository.updateMCQ(mcq);
//       return const Right(null);
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

class UpdateMCQUseCase implements UseCase<void, MCQ> {
  final MCQRepository repository;

  UpdateMCQUseCase(this.repository);

  @override
  Future<Either<Failures, void>> call(MCQ mcq) async {
    return repository.updateMCQ(mcq);
  }
}
