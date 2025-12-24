import 'package:equatable/equatable.dart';

import '../../domain/entity/entity.dart';

abstract class MCQState extends Equatable {
  const MCQState();

  @override
  List<Object?> get props => [];
}

class MCQInitial extends MCQState {}

class MCQLoading extends MCQState {}

class MCQsLoaded extends MCQState {
  final List<MCQ> mcqs;
  final Map<String, int?> selectedAnswers;
  final Map<String, bool> showResults;

  const MCQsLoaded({
    required this.mcqs,
    this.selectedAnswers = const {},
    this.showResults = const {},
  });

  @override
  List<Object?> get props => [mcqs, selectedAnswers, showResults];

  MCQsLoaded copyWith({
    List<MCQ>? mcqs,
    Map<String, int?>? selectedAnswers,
    Map<String, bool>? showResults,
  }) {
    return MCQsLoaded(
      mcqs: mcqs ?? this.mcqs,
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
      showResults: showResults ?? this.showResults,
    );
  }
}

class MCQError extends MCQState {
  final String message;

  const MCQError(this.message);

  @override
  List<Object?> get props => [message];
}

class MCQOperationSuccess extends MCQState {
  final String message;

  const MCQOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
// mcqs_state.dart
class MCQDetailLoaded extends MCQState {
  final MCQ mcq;

  const MCQDetailLoaded({required this.mcq});

  @override
  List<Object?> get props => [mcq];
}
