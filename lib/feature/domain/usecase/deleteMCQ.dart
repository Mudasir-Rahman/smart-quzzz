import '../../../core/usecase/usecase.dart';
import '../repository_interface/repository_interface.dart';

class DeleteMCQ extends UseCase<void, String> {
  final MCQRepository repository;

  DeleteMCQ(this.repository);

  @override
  Future<void> call(String mcqId) {
    return repository.deleteMCQ(mcqId);
  }
}
