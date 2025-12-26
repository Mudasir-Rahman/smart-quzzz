// import 'package:dartz/dartz.dart';
// import '../../../core/error/failures.dart';
// import '../../../core/usecase/usecase.dart';
// import '../entity/entity.dart';
// import '../repository_interface/repository_interface.dart';
//
// class AddMCQ extends UseCase<void, MCQ> {
//   final MCQRepository repository;
//
//   AddMCQ(this.repository);
//
//   @override
//   Future<Either<Failures, void>> call(MCQ mcq) async {
//     try {
//       await repository.addMCQ(mcq);
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

class AddMCQUseCase implements UseCase<void, MCQ> {
  final MCQRepository repository;

  AddMCQUseCase(this.repository);

  @override
  Future<Either<Failures, void>> call(MCQ mcq) async {
    return repository.addMCQ(mcq);
  }
}
