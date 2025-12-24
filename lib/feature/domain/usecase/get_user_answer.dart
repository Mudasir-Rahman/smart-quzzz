

import '../../../core/usecase/usecase.dart';
import '../entity/entity.dart';
import '../repository_interface/repository_interface.dart';

class GetUserAnswers extends UseCase<List<UserAnswer>, NoParams> {
  final MCQRepository repository;

  GetUserAnswers(this.repository);

  @override
  Future<List<UserAnswer>> call(NoParams params) async {
    return await repository.getUserAnswers();
  }
}