import 'package:dartz/dartz.dart';
import 'package:quiez_assigenment/core/error/failures.dart';
import 'package:quiez_assigenment/core/usecase/usecase.dart';
import '../entity/auth_entity.dart';
import '../repository_interface/auth_interface.dart';

class GetCurrentUser implements UseCase<UserEntity?, NoParams> {
  final AuthRepository authRepository;
  GetCurrentUser(this.authRepository);

  @override
  Future<Either<Failures, UserEntity?>> call(NoParams params) async {
    return await authRepository.getCurrentUser();
  }
}