import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repository_interface/auth_interface.dart';

class IsLoggedInUseCase implements UseCase<bool, NoParams> {
  final AuthRepository authRepository;

  IsLoggedInUseCase(this.authRepository);

  @override
  Future<Either<Failures, bool>> call(NoParams params) async {
    return await authRepository.isLoggedIn(); // Now this returns Either<Failures, bool>
  }
}