import '../../../core/usecase/usecase.dart';
import '../entity/entity.dart';
import '../repository_interface/repository_interface.dart';

class GetOverallProgress extends UseCase<OverallProgress, NoParams> {
  final MCQRepository repository;

  GetOverallProgress(this.repository);

  @override
  Future<OverallProgress> call(NoParams params) async {
    return await repository.getOverallProgress();
  }
}
