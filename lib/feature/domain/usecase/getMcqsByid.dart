// import 'package:dartz/dartz.dart';
// import '../../../core/error/failures.dart';
// import '../../../core/usecase/usecase.dart';
// import '../entity/entity.dart';
// import '../repository_interface/repository_interface.dart';
//
// class GetMCQById extends UseCase<MCQ?, String> {
//   final MCQRepository repository;
//
//   GetMCQById(this.repository);
//
//   @override
//   Future<Either<Failures, MCQ?>> call(String id) async {
//     try {
//       final mcq = await repository.getMCQById(id);
//       return Right(mcq);
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

class GetMCQByIdUseCase implements UseCase<MCQ?, String> {
  final MCQRepository repository;

  GetMCQByIdUseCase(this.repository);

  @override
  Future<Either<Failures, MCQ?>> call(String id) async {
    return repository.getMCQById(id);
  }
}
