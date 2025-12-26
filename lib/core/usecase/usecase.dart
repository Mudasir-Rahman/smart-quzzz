// import 'package:equatable/equatable.dart';
//
//
// abstract class UseCase<Type, Params> {
//   Future<Type> call(Params params);
// }
//
//
// class NoParams extends Equatable {
//   @override
//   List<Object?> get props => [];
// }
import 'package:equatable/equatable.dart';
import '../error/failures.dart';
import 'package:dartz/dartz.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failures, Type>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
