// import 'package:equatable/equatable.dart';
// import '../../domain/entity/entity.dart';
//
// abstract class ProgressState extends Equatable {
//   const ProgressState();
//
//   @override
//   List<Object?> get props => [];
// }
//
// class ProgressInitial extends ProgressState {}
//
// class ProgressLoading extends ProgressState {}
//
// class ProgressLoaded extends ProgressState {
//   final OverallProgress overallProgress;
//   final List<UserAnswer> recentAnswers;
//
//   const ProgressLoaded({
//     required this.overallProgress,
//     required this.recentAnswers,
//   });
//
//   @override
//   List<Object?> get props => [overallProgress, recentAnswers];
// }
//
// class ProgressError extends ProgressState {
//   final String message;
//
//   const ProgressError(this.message);
//
//   @override
//   List<Object?> get props => [message];
// }
import 'package:equatable/equatable.dart';
import '../../domain/entity/entity.dart';

abstract class ProgressState extends Equatable {
  const ProgressState();

  @override
  List<Object?> get props => [];
}

class ProgressInitial extends ProgressState {}

class ProgressLoading extends ProgressState {}

class ProgressLoaded extends ProgressState {
  final OverallProgress overallProgress;
  final List<UserAnswer> recentAnswers;

  const ProgressLoaded({
    required this.overallProgress,
    required this.recentAnswers,
  });

  @override
  List<Object?> get props => [overallProgress, recentAnswers];
}

class ProgressError extends ProgressState {
  final String message;

  const ProgressError(this.message);

  @override
  List<Object?> get props => [message];
}
