import '../../../core/usecase/usecase.dart';
import '../entity/entity.dart';
import '../repository_interface/repository_interface.dart';

class GetMCQById extends UseCase<MCQ?, String> {
  final MCQRepository repository;

  GetMCQById(this.repository);

  @override
  Future<MCQ?> call(String id) async {
    return await repository.getMCQById(id);
  }
}
