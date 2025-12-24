import '../../../core/usecase/usecase.dart';
import '../entity/entity.dart';
import '../repository_interface/repository_interface.dart';

class UpdateMCQ extends UseCase<void, MCQ> {
  final MCQRepository repository;

  UpdateMCQ(this.repository);

  @override
  Future<void> call(MCQ mcq) {
    return repository.updateMCQ(mcq);
  }
}
