import 'package:equatable/equatable.dart';
import '../../domain/entity/entity.dart';

import '../progress_bloc/progres_bloc.dart';

abstract class MCQEvent extends Equatable {
  const MCQEvent();

  @override
  List<Object?> get props => [];
}

class LoadAllMCQsEvent extends MCQEvent {}

class LoadQuestionsForReviewEvent extends MCQEvent {
  final String userId;

  const LoadQuestionsForReviewEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class FetchMCQByIdEvent extends MCQEvent {
  final String mcqId;

  const FetchMCQByIdEvent(this.mcqId);

  @override
  List<Object?> get props => [mcqId];
}

class SubmitAnswerEvent extends MCQEvent {
  final UserAnswer answer;
  final ProgressBloc? progressBloc;

  const SubmitAnswerEvent({
    required this.answer,
    this.progressBloc,
  });

  @override
  List<Object?> get props => [answer];
}

class AddMCQEvent extends MCQEvent {
  final MCQ mcq;

  const AddMCQEvent(this.mcq);

  @override
  List<Object?> get props => [mcq];
}

class UpdateMCQEvent extends MCQEvent {
  final MCQ mcq;

  const UpdateMCQEvent(this.mcq);

  @override
  List<Object?> get props => [mcq];
}

class DeleteMCQEvent extends MCQEvent {
  final String id;

  const DeleteMCQEvent(this.id);

  @override
  List<Object?> get props => [id];
}
