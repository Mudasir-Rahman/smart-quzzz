import '../../../core/usecase/usecase.dart';
import '../entity/entity.dart';
import '../repository_interface/repository_interface.dart';

class AddMCQ extends UseCase<void, MCQ> {
  final MCQRepository repository;

  AddMCQ(this.repository);

  @override
  Future<void> call(MCQ mcq) {
    return repository.addMCQ(mcq);
  }
}
