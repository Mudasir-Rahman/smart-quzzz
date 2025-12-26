// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import '../../../core/usecase/usecase.dart';
// // import '../../domain/usecase/addMCQ.dart';
// // import '../../domain/usecase/deleteMCQ.dart';
// // import '../../domain/usecase/getMcqsByid.dart';
// // import '../../domain/usecase/getQuestionsForReview.dart';
// // import '../../domain/usecase/get_all_mcqs.dart';
// //
// // import '../../domain/usecase/submitAnswer.dart';
// // import '../../domain/usecase/updateMCQ.dart';
// // import 'mcqs_event.dart';
// // import 'mcqs_state.dart';
// //
// // class MCQBloc extends Bloc<MCQEvent, MCQState> {
// //   final GetAllMCQs getAllMCQsUseCase;
// //   final GetQuestionsForReview getQuestionsForReviewUseCase;
// //   final GetMCQById getMCQByIdUseCase;
// //   final SubmitAnswer submitAnswerUseCase;
// //   final AddMCQ addMCQUseCase;
// //   final UpdateMCQ updateMCQUseCase;
// //   final DeleteMCQ deleteMCQUseCase;
// //
// //   MCQBloc({
// //     required this.getAllMCQsUseCase,
// //     required this.getQuestionsForReviewUseCase,
// //     required this.getMCQByIdUseCase,
// //     required this.submitAnswerUseCase,
// //     required this.addMCQUseCase,
// //     required this.updateMCQUseCase,
// //     required this.deleteMCQUseCase,
// //   }) : super(MCQInitial()) {
// //     on<LoadAllMCQsEvent>(_onLoadAllMCQs);
// //     on<LoadQuestionsForReviewEvent>(_onLoadQuestionsForReview);
// //     on<FetchMCQByIdEvent>(_onFetchMCQById);
// //     on<SubmitAnswerEvent>(_onSubmitAnswer);
// //     on<AddMCQEvent>(_onAddMCQ);
// //     on<UpdateMCQEvent>(_onUpdateMCQ);
// //     on<DeleteMCQEvent>(_onDeleteMCQ);
// //   }
// //
// //   Future<void> _onLoadAllMCQs(
// //       LoadAllMCQsEvent event,
// //       Emitter<MCQState> emit,
// //       ) async {
// //     emit(MCQLoading());
// //     try {
// //       final mcqs = await getAllMCQsUseCase(NoParams());
// //       emit(MCQsLoaded(mcqs: mcqs));
// //     } catch (e) {
// //       emit(MCQError('Failed to load MCQs: ${e.toString()}'));
// //     }
// //   }
// //
// //   Future<void> _onLoadQuestionsForReview(
// //       LoadQuestionsForReviewEvent event,
// //       Emitter<MCQState> emit,
// //       ) async {
// //     emit(MCQLoading());
// //     try {
// //       final mcqs = await getQuestionsForReviewUseCase(NoParams());
// //       emit(MCQsLoaded(mcqs: mcqs));
// //     } catch (e) {
// //       emit(MCQError('Failed to load questions for review: ${e.toString()}'));
// //     }
// //   }
// //
// //   Future<void> _onFetchMCQById(
// //       FetchMCQByIdEvent event,
// //       Emitter<MCQState> emit,
// //       ) async {
// //     emit(MCQLoading());
// //     try {
// //       final mcq = await getMCQByIdUseCase(event.mcqId);
// //       if (mcq != null) {
// //         emit(MCQDetailLoaded(mcq: mcq));
// //       } else {
// //         emit(MCQError('MCQ not found'));
// //       }
// //     } catch (e) {
// //       emit(MCQError('Failed to fetch MCQ: ${e.toString()}'));
// //     }
// //   }
// //
// //   Future<void> _onSubmitAnswer(
// //       SubmitAnswerEvent event,
// //       Emitter<MCQState> emit,
// //       ) async {
// //     final currentState = state;
// //     if (currentState is MCQsLoaded) {
// //       try {
// //         await submitAnswerUseCase(SubmitAnswerParams(
// //           id: event.answer.id,
// //           mcqId: event.answer.mcqId,
// //           selectedOption: event.answer.selectedAnswerIndex,
// //           isCorrect: event.answer.isCorrect,
// //           submittedAt: event.answer.answeredAt,
// //           timeSpentSeconds: event.answer.timeSpentSeconds,
// //         ));
// //
// //         final newSelectedAnswers = Map<String, int?>.from(currentState.selectedAnswers);
// //         newSelectedAnswers[event.answer.mcqId] = event.answer.selectedAnswerIndex;
// //
// //         final newShowResults = Map<String, bool>.from(currentState.showResults);
// //         newShowResults[event.answer.mcqId] = true;
// //
// //         emit(currentState.copyWith(
// //           selectedAnswers: newSelectedAnswers,
// //           showResults: newShowResults,
// //         ));
// //       } catch (e) {
// //         emit(MCQError('Failed to submit answer: ${e.toString()}'));
// //       }
// //     }
// //   }
// //
// //   Future<void> _onAddMCQ(
// //       AddMCQEvent event,
// //       Emitter<MCQState> emit,
// //       ) async {
// //     try {
// //       await addMCQUseCase(event.mcq);
// //       emit(const MCQOperationSuccess('MCQ added successfully'));
// //       add(LoadAllMCQsEvent());
// //     } catch (e) {
// //       emit(MCQError('Failed to add MCQ: ${e.toString()}'));
// //     }
// //   }
// //
// //   Future<void> _onUpdateMCQ(
// //       UpdateMCQEvent event,
// //       Emitter<MCQState> emit,
// //       ) async {
// //     try {
// //       await updateMCQUseCase(event.mcq);
// //       emit(const MCQOperationSuccess('MCQ updated successfully'));
// //       add(LoadAllMCQsEvent());
// //     } catch (e) {
// //       emit(MCQError('Failed to update MCQ: ${e.toString()}'));
// //     }
// //   }
// //
// //   Future<void> _onDeleteMCQ(
// //       DeleteMCQEvent event,
// //       Emitter<MCQState> emit,
// //       ) async {
// //     try {
// //       await deleteMCQUseCase(event.id);
// //       emit(const MCQOperationSuccess('MCQ deleted successfully'));
// //       add(LoadAllMCQsEvent());
// //     } catch (e) {
// //       emit(MCQError('Failed to delete MCQ: ${e.toString()}'));
// //     }
// //   }
// // }
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:dartz/dartz.dart';
//
// import '../../../core/error/failures.dart';
// import '../../../core/usecase/usecase.dart';
// import '../../domain/usecase/addMCQ.dart';
// import '../../domain/usecase/deleteMCQ.dart';
// import '../../domain/usecase/getMcqsByid.dart';
// import '../../domain/usecase/getQuestionsForReview.dart';
// import '../../domain/usecase/get_all_mcqs.dart';
// import '../../domain/usecase/submitAnswer.dart';
// import '../../domain/usecase/updateMCQ.dart';
//
// import 'mcqs_event.dart';
// import 'mcqs_state.dart';
//
// class MCQBloc extends Bloc<MCQEvent, MCQState> {
//   final GetAllMCQs getAllMCQsUseCase;
//   final GetQuestionsForReview getQuestionsForReviewUseCase;
//   final GetMCQById getMCQByIdUseCase;
//   final SubmitAnswer submitAnswerUseCase;
//   final AddMCQ addMCQUseCase;
//   final UpdateMCQ updateMCQUseCase;
//   final DeleteMCQ deleteMCQUseCase;
//
//   MCQBloc({
//     required this.getAllMCQsUseCase,
//     required this.getQuestionsForReviewUseCase,
//     required this.getMCQByIdUseCase,
//     required this.submitAnswerUseCase,
//     required this.addMCQUseCase,
//     required this.updateMCQUseCase,
//     required this.deleteMCQUseCase,
//   }) : super(MCQInitial()) {
//     on<LoadAllMCQsEvent>(_onLoadAllMCQs);
//     on<LoadQuestionsForReviewEvent>(_onLoadQuestionsForReview);
//     on<FetchMCQByIdEvent>(_onFetchMCQById);
//     on<SubmitAnswerEvent>(_onSubmitAnswer);
//     on<AddMCQEvent>(_onAddMCQ);
//     on<UpdateMCQEvent>(_onUpdateMCQ);
//     on<DeleteMCQEvent>(_onDeleteMCQ);
//   }
//
//   Future<void> _onLoadAllMCQs(
//       LoadAllMCQsEvent event, Emitter<MCQState> emit) async {
//     emit(MCQLoading());
//     final result = await getAllMCQsUseCase(NoParams());
//     result.fold(
//           (failure) => emit(MCQError('Failed to load MCQs: ${failure.message}')),
//           (mcqs) => emit(MCQsLoaded(mcqs: mcqs)),
//     );
//   }
//
//   Future<void> _onLoadQuestionsForReview(
//       LoadQuestionsForReviewEvent event, Emitter<MCQState> emit) async {
//     emit(MCQLoading());
//     final result = await getQuestionsForReviewUseCase(NoParams());
//     result.fold(
//           (failure) =>
//           emit(MCQError('Failed to load questions for review: ${failure.message}')),
//           (mcqs) => emit(MCQsLoaded(mcqs: mcqs)),
//     );
//   }
//
//   Future<void> _onFetchMCQById(
//       FetchMCQByIdEvent event, Emitter<MCQState> emit) async {
//     emit(MCQLoading());
//     final result = await getMCQByIdUseCase(event.mcqId);
//     result.fold(
//           (failure) => emit(MCQError('Failed to fetch MCQ: ${failure.message}')),
//           (mcq) => mcq != null
//           ? emit(MCQDetailLoaded(mcq: mcq))
//           : emit(MCQError('MCQ not found')),
//     );
//   }
//
//   Future<void> _onSubmitAnswer(
//       SubmitAnswerEvent event, Emitter<MCQState> emit) async {
//     final currentState = state;
//     if (currentState is MCQsLoaded) {
//       final result = await submitAnswerUseCase(SubmitAnswerParams(
//         id: event.answer.id,
//         mcqId: event.answer.mcqId,
//         selectedOption: event.answer.selectedAnswerIndex,
//         isCorrect: event.answer.isCorrect,
//         submittedAt: event.answer.answeredAt,
//         timeSpentSeconds: event.answer.timeSpentSeconds,
//       ));
//
//       result.fold(
//             (failure) => emit(MCQError('Failed to submit answer: ${failure.message}')),
//             (_) {
//           final newSelectedAnswers = Map<String, int?>.from(currentState.selectedAnswers);
//           newSelectedAnswers[event.answer.mcqId] = event.answer.selectedAnswerIndex;
//
//           final newShowResults = Map<String, bool>.from(currentState.showResults);
//           newShowResults[event.answer.mcqId] = true;
//
//           emit(currentState.copyWith(
//             selectedAnswers: newSelectedAnswers,
//             showResults: newShowResults,
//           ));
//         },
//       );
//     }
//   }
//
//   Future<void> _onAddMCQ(AddMCQEvent event, Emitter<MCQState> emit) async {
//     final result = await addMCQUseCase(event.mcq);
//     result.fold(
//           (failure) => emit(MCQError('Failed to add MCQ: ${failure.message}')),
//           (_) {
//         emit(const MCQOperationSuccess('MCQ added successfully'));
//         add(LoadAllMCQsEvent());
//       },
//     );
//   }
//
//   Future<void> _onUpdateMCQ(UpdateMCQEvent event, Emitter<MCQState> emit) async {
//     final result = await updateMCQUseCase(event.mcq);
//     result.fold(
//           (failure) => emit(MCQError('Failed to update MCQ: ${failure.message}')),
//           (_) {
//         emit(const MCQOperationSuccess('MCQ updated successfully'));
//         add(LoadAllMCQsEvent());
//       },
//     );
//   }
//
//   Future<void> _onDeleteMCQ(DeleteMCQEvent event, Emitter<MCQState> emit) async {
//     final result = await deleteMCQUseCase(event.id);
//     result.fold(
//           (failure) => emit(MCQError('Failed to delete MCQ: ${failure.message}')),
//           (_) {
//         emit(const MCQOperationSuccess('MCQ deleted successfully'));
//         add(LoadAllMCQsEvent());
//       },
//     );
//   }
// }
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/usecase/usecase.dart';
import '../../domain/entity/entity.dart';
import '../../domain/usecase/addMCQ.dart';
import '../../domain/usecase/deleteMCQ.dart';
import '../../domain/usecase/getMcqsByid.dart';
import '../../domain/usecase/getQuestionsForReview.dart';
import '../../domain/usecase/get_all_mcqs.dart';
import '../../domain/usecase/submitAnswer.dart';
import '../../domain/usecase/updateMCQ.dart';
import '../progress_bloc/progres_event.dart';
import 'mcqs_event.dart';
import 'mcqs_state.dart';


class MCQBloc extends Bloc<MCQEvent, MCQState> {
  final GetAllMCQsUseCase getAllMCQsUseCase;
  final GetQuestionsForReviewUseCase getQuestionsForReviewUseCase;
  final GetMCQByIdUseCase getMCQByIdUseCase;
  final SubmitAnswerUseCase submitAnswerUseCase;
  final AddMCQUseCase addMCQUseCase;
  final UpdateMCQUseCase updateMCQUseCase;
  final DeleteMCQUseCase deleteMCQUseCase;

  MCQBloc({
    required this.getAllMCQsUseCase,
    required this.getQuestionsForReviewUseCase,
    required this.getMCQByIdUseCase,
    required this.submitAnswerUseCase,
    required this.addMCQUseCase,
    required this.updateMCQUseCase,
    required this.deleteMCQUseCase,
  }) : super(MCQInitial()) {
    on<LoadAllMCQsEvent>(_onLoadAllMCQs);
    on<LoadQuestionsForReviewEvent>(_onLoadQuestionsForReview);
    on<FetchMCQByIdEvent>(_onFetchMCQById);
    on<SubmitAnswerEvent>(_onSubmitAnswer);
    on<AddMCQEvent>(_onAddMCQ);
    on<UpdateMCQEvent>(_onUpdateMCQ);
    on<DeleteMCQEvent>(_onDeleteMCQ);
  }

  Future<void> _onLoadAllMCQs(LoadAllMCQsEvent event, Emitter<MCQState> emit) async {
    emit(MCQLoading());
    final result = await getAllMCQsUseCase(NoParams());
    result.fold(
          (failure) => emit(MCQError('Failed to load MCQs: ${failure.message}')),
          (mcqs) => emit(MCQsLoaded(mcqs: mcqs)),
    );
  }

  Future<void> _onLoadQuestionsForReview(LoadQuestionsForReviewEvent event, Emitter<MCQState> emit) async {
    emit(MCQLoading());
    final result = await getQuestionsForReviewUseCase(NoParams());
    result.fold(
          (failure) => emit(MCQError('Failed to load questions for review: ${failure.message}')),
          (mcqs) => emit(MCQsLoaded(mcqs: mcqs)),
    );
  }

  Future<void> _onFetchMCQById(FetchMCQByIdEvent event, Emitter<MCQState> emit) async {
    emit(MCQLoading());
    final result = await getMCQByIdUseCase(event.mcqId);
    result.fold(
          (failure) => emit(MCQError('Failed to fetch MCQ: ${failure.message}')),
          (mcq) => mcq != null
          ? emit(MCQDetailLoaded(mcq: mcq))
          : emit(MCQError('MCQ not found')),
    );
  }

  Future<void> _onSubmitAnswer(SubmitAnswerEvent event, Emitter<MCQState> emit) async {
    final currentState = state;
    if (currentState is MCQsLoaded) {
      final result = await submitAnswerUseCase(
        SubmitAnswerParams(
          id: event.answer.id,
          mcqId: event.answer.mcqId,
          selectedOption: event.answer.selectedAnswerIndex,
          isCorrect: event.answer.isCorrect,
          submittedAt: event.answer.answeredAt,
          timeSpentSeconds: event.answer.timeSpentSeconds,
        ),
      );

      result.fold(
            (failure) => emit(MCQError('Failed to submit answer: ${failure.message}')),
            (_) {
          final newSelectedAnswers = Map<String, int?>.from(currentState.selectedAnswers);
          newSelectedAnswers[event.answer.mcqId] = event.answer.selectedAnswerIndex;

          final newShowResults = Map<String, bool>.from(currentState.showResults);
          newShowResults[event.answer.mcqId] = true;

          emit(currentState.copyWith(
            selectedAnswers: newSelectedAnswers,
            showResults: newShowResults,
          ));

          // Trigger progress reload if ProgressBloc is provided
          event.progressBloc?.add(LoadProgressEvent());
        },
      );
    }
  }

  Future<void> _onAddMCQ(AddMCQEvent event, Emitter<MCQState> emit) async {
    final result = await addMCQUseCase(event.mcq);
    result.fold(
          (failure) => emit(MCQError('Failed to add MCQ: ${failure.message}')),
          (_) {
        emit(const MCQOperationSuccess('MCQ added successfully'));
        add(LoadAllMCQsEvent());
      },
    );
  }

  Future<void> _onUpdateMCQ(UpdateMCQEvent event, Emitter<MCQState> emit) async {
    final result = await updateMCQUseCase(event.mcq);
    result.fold(
          (failure) => emit(MCQError('Failed to update MCQ: ${failure.message}')),
          (_) {
        emit(const MCQOperationSuccess('MCQ updated successfully'));
        add(LoadAllMCQsEvent());
      },
    );
  }

  Future<void> _onDeleteMCQ(DeleteMCQEvent event, Emitter<MCQState> emit) async {
    final result = await deleteMCQUseCase(event.id);
    result.fold(
          (failure) => emit(MCQError('Failed to delete MCQ: ${failure.message}')),
          (_) {
        emit(const MCQOperationSuccess('MCQ deleted successfully'));
        add(LoadAllMCQsEvent());
      },
    );
  }
}
