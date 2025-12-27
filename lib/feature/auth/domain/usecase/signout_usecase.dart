import 'package:dartz/dartz.dart';
import 'package:quiez_assigenment/core/error/failures.dart';
import 'package:quiez_assigenment/core/usecase/usecase.dart';
import '../repository_interface/auth_interface.dart';

class SignOutUseCase implements UseCase<void, NoParams> {
  final AuthRepository authRepository;
  SignOutUseCase(this.authRepository);

  @override
  Future<Either<Failures, void>> call(NoParams params) async {
    return await authRepository.logout();
  }
}