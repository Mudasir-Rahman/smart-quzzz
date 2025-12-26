// import 'package:dartz/dartz.dart';
// import '../../../core/error/failures.dart';
// import '../../../core/usecase/usecase.dart';
// import '../entity/entity.dart';
// import '../repository_interface/repository_interface.dart';
//
// class GetAllMCQs extends UseCase<List<MCQ>, NoParams> {
//   final MCQRepository repository;
//
//   GetAllMCQs(this.repository);
//
//   @override
//   Future<Either<Failures, List<MCQ>>> call(NoParams params) async {
//     try {
//       final mcqs = await repository.getAllMCQs();
//       return Right(mcqs);
//     } catch (e) {
//       return Left(ServerFailure(e.toString()));
//     }
//   }
// }
// import 'package:dartz/dartz.dart';
// import 'package:quiez_assigenment/core/error/failures.dart';
//
// import '../../../core/usecase/usecase.dart';
// import '../entity/entity.dart';
// import '../repository_interface/repository_interface.dart';
//
// class GetAllMCQs implements UseCase<List<MCQ>, String> {
//   final MCQRepository repository;
//
//   GetAllMCQs(this.repository);
//
//   @override
//   Future<Either<Failures, List<MCQ>>> call(String userId) {
//     return repository.getAllMCQs(userId);
//   }
// }
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entity/entity.dart';
import '../repository_interface/repository_interface.dart';

class GetAllMCQsUseCase implements UseCase<List<MCQ>, NoParams> {
  final MCQRepository repository;

  GetAllMCQsUseCase(this.repository);

  @override
  Future<Either<Failures, List<MCQ>>> call(NoParams params) async {
    return repository.getAllMCQs();
  }
}
