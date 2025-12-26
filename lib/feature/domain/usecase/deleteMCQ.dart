// import 'package:dartz/dartz.dart';
// import '../../../core/error/failures.dart';
// import '../../../core/usecase/usecase.dart';
// import '../repository_interface/repository_interface.dart';
//
// class DeleteMCQ extends UseCase<void, String> {
//   final MCQRepository repository;
//
//   DeleteMCQ(this.repository);
//
//   @override
//   Future<Either<Failures, void>> call(String mcqId) async {
//     try {
//       await repository.deleteMCQ(mcqId);
//       return const Right(null);
//     } catch (e) {
//       return Left(ServerFailure(e.toString()));
//     }
//   }
// }
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repository_interface/repository_interface.dart';

class DeleteMCQUseCase implements UseCase<void, String> {
  final MCQRepository repository;

  DeleteMCQUseCase(this.repository);

  @override
  Future<Either<Failures, void>> call(String id) async {
    return repository.deleteMCQ(id);
  }
}
