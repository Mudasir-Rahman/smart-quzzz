// import 'package:equatable/equatable.dart';
//
// import '../../domain/entity/entity.dart';
//
// abstract class MCQEvent extends Equatable {
//   const MCQEvent();
//
//   @override
//   List<Object?> get props => [];
// }
//
// class LoadAllMCQsEvent extends MCQEvent {}
//
// class LoadQuestionsForReviewEvent extends MCQEvent {}
//
// class SubmitAnswerEvent extends MCQEvent {
//   final UserAnswer answer;
//
//   const SubmitAnswerEvent(this.answer);
//
//   @override
//   List<Object?> get props => [answer];
// }
//
// class AddMCQEvent extends MCQEvent {
//   final MCQ mcq;
//
//   const AddMCQEvent(this.mcq);
//
//   @override
//   List<Object?> get props => [mcq];
// }
//
// class UpdateMCQEvent extends MCQEvent {
//   final MCQ mcq;
//
//   const UpdateMCQEvent(this.mcq);
//
//   @override
//   List<Object?> get props => [mcq];
// }
//
// class DeleteMCQEvent extends MCQEvent {
//   final String id;
//
//   const DeleteMCQEvent(this.id);
//
//   @override
//   List<Object?> get props => [id];
// }
// // mcqs_event.dart
// class FetchMCQByIdEvent extends MCQEvent {
//   final String mcqId;
//
//   const FetchMCQByIdEvent(this.mcqId);
//
//   @override
//   List<Object?> get props => [mcqId];
// }
import 'package:equatable/equatable.dart';
import '../../domain/entity/entity.dart';

import '../progress_bloc/progres_bloc.dart'; // Import ProgressBloc

abstract class MCQEvent extends Equatable {
  const MCQEvent();

  @override
  List<Object?> get props => [];
}

/// Load all MCQs
class LoadAllMCQsEvent extends MCQEvent {}

/// Load questions for review
class LoadQuestionsForReviewEvent extends MCQEvent {}

/// Fetch a single MCQ by ID
class FetchMCQByIdEvent extends MCQEvent {
  final String mcqId;

  const FetchMCQByIdEvent(this.mcqId);

  @override
  List<Object?> get props => [mcqId];
}

/// Submit a user answer
class SubmitAnswerEvent extends MCQEvent {
  final UserAnswer answer;
  final ProgressBloc? progressBloc; // Optional reference to ProgressBloc

  const SubmitAnswerEvent({
    required this.answer,
    this.progressBloc,
  });

  @override
  List<Object?> get props => [answer];
}

/// Add a new MCQ
class AddMCQEvent extends MCQEvent {
  final MCQ mcq;

  const AddMCQEvent(this.mcq);

  @override
  List<Object?> get props => [mcq];
}

/// Update an existing MCQ
class UpdateMCQEvent extends MCQEvent {
  final MCQ mcq;

  const UpdateMCQEvent(this.mcq);

  @override
  List<Object?> get props => [mcq];
}

/// Delete an MCQ
class DeleteMCQEvent extends MCQEvent {
  final String id;

  const DeleteMCQEvent(this.id);

  @override
  List<Object?> get props => [id];
}
