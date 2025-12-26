// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import '../../../core/usecase/usecase.dart'; // for NoParams
// // import '../../domain/usecase/getOverallProgress.dart';
// //
// // import '../../domain/usecase/get_user_answer.dart';
// // import 'progres_event.dart';
// // import 'progres_state.dart';
// //
// // class ProgressBloc extends Bloc<ProgressEvent, ProgressState> {
// //   final GetOverallProgress getOverallProgress;
// //   final GetUserAnswers getUserAnswers;
// //
// //   ProgressBloc({
// //     required this.getOverallProgress,
// //     required this.getUserAnswers,
// //   }) : super(ProgressInitial()) {
// //     on<LoadProgressEvent>(_onLoadProgress);
// //   }
// //
// //   Future<void> _onLoadProgress(
// //       LoadProgressEvent event,
// //       Emitter<ProgressState> emit,
// //       ) async {
// //     emit(ProgressLoading());
// //     try {
// //       // Call use cases with NoParams
// //       final overallProgress = await getOverallProgress(NoParams());
// //       final recentAnswers = await getUserAnswers(NoParams());
// //
// //       // Take only the most recent 10 answers
// //       final limitedAnswers = recentAnswers.take(10).toList();
// //
// //       emit(ProgressLoaded(
// //         overallProgress: overallProgress,
// //         recentAnswers: limitedAnswers,
// //       ));
// //     } catch (e) {
// //       emit(ProgressError('Failed to load progress: ${e.toString()}'));
// //     }
// //   }
// // }
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:dartz/dartz.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
//
// import '../../../core/error/failures.dart';
// import '../../../core/usecase/usecase.dart';
// import '../../domain/usecase/getOverallProgress.dart';
// import '../../domain/usecase/get_user_answer.dart';
// import 'progres_event.dart';
// import 'progres_state.dart';
//
// class ProgressBloc extends Bloc<ProgressEvent, ProgressState> {
//   final GetOverallProgressUseCase getOverallProgressUseCase;
//   final GetUserAnswersUseCase getUserAnswersUseCase;
//
//   ProgressBloc({
//     required this.getOverallProgressUseCase,
//     required this.getUserAnswersUseCase,
//   }) : super(ProgressInitial()) {
//     on<LoadProgressEvent>(_onLoadProgress);
//   }
//
//   Future<void> _onLoadProgress(
//       LoadProgressEvent event, Emitter<ProgressState> emit) async {
//     // Check for logged-in user
//     final user = Supabase.instance.client.auth.currentUser;
//     if (user == null) {
//       emit(const ProgressError('No logged-in user found'));
//       return;
//     }
//
//     emit(ProgressLoading());
//
//     final overallResult = await getOverallProgressUseCase(NoParams());
//     final answersResult = await getUserAnswersUseCase(NoParams());
//
//     overallResult.fold(
//           (failure) => emit(ProgressError('Failed to load progress: ${failure.message}')),
//           (overallProgress) {
//         answersResult.fold(
//               (failure) =>
//               emit(ProgressError('Failed to load user answers: ${failure.message}')),
//               (recentAnswers) {
//             final limitedAnswers = recentAnswers.take(10).toList();
//             emit(ProgressLoaded(
//               overallProgress: overallProgress,
//               recentAnswers: limitedAnswers,
//             ));
//           },
//         );
//       },
//     );
//   }
// }
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:quiez_assigenment/feature/domain/usecase/getOverallProgress.dart';
import 'package:quiez_assigenment/feature/presentaion/progress_bloc/progres_event.dart';
import 'package:quiez_assigenment/feature/presentaion/progress_bloc/progres_state.dart';
import '../../../../core/error/failures.dart';
import '../../../core/usecase/usecase.dart';
import '../../domain/entity/entity.dart';

import '../../domain/repository_interface/repository_interface.dart';
import '../../domain/usecase/get_user_answer.dart';

class ProgressBloc extends Bloc<ProgressEvent, ProgressState> {
  final GetUserAnswersUseCase getUserAnswersUseCase;

  ProgressBloc({required this.getUserAnswersUseCase, required GetOverallProgressUseCase getOverallProgressUseCase}) : super(ProgressInitial()) {
    on<LoadProgressEvent>(_onLoadProgress);
  }

  Future<void> _onLoadProgress(
      LoadProgressEvent event, Emitter<ProgressState> emit) async {
    emit(ProgressLoading());

    final Either<Failures, List<UserAnswer>> answersOrFailure =
    await getUserAnswersUseCase(NoParams());

    answersOrFailure.fold(
          (failure) => emit(ProgressError(failure.toString())),
          (answers) {
        final overallProgress = _calculateOverallProgress(answers);
        emit(ProgressLoaded(
          overallProgress: overallProgress,
          recentAnswers: answers,
        ));
      },
    );
  }

  OverallProgress _calculateOverallProgress(List<UserAnswer> answers) {
    int totalAttempted = answers.length;
    int totalCorrect = answers.where((a) => a.isCorrect).length;
    int totalIncorrect = answers.where((a) => !a.isCorrect).length;

    // Example: calculate streaks (simplified)
    int currentStreak = 0;
    int longestStreak = 0;
    int tempStreak = 0;

    for (var answer in answers..sort((a, b) => a.answeredAt.compareTo(b.answeredAt))) {
      if (answer.isCorrect) {
        tempStreak++;
        if (tempStreak > longestStreak) longestStreak = tempStreak;
      } else {
        tempStreak = 0;
      }
    }
    currentStreak = tempStreak;

    return OverallProgress(
      totalQuestionsAttempted: totalAttempted,
      totalCorrectAnswers: totalCorrect,
      totalIncorrectAnswers: totalIncorrect,
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      categoryPerformance: {}, // No category for now
    );
  }
}
