


import '../../../core/usecase/usecase.dart';
import '../entity/entity.dart';
import '../repository_interface/repository_interface.dart';

class GetAllMCQs extends UseCase<List<MCQ>, NoParams> {
  final MCQRepository repository;

  GetAllMCQs(this.repository);

  @override
  Future<List<MCQ>> call(NoParams params) async {
    return await repository.getAllMCQs();
  }
}