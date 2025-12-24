import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/usecase/usecase.dart'; // for NoParams
import '../../domain/usecase/getOverallProgress.dart';

import '../../domain/usecase/get_user_answer.dart';
import 'progres_event.dart';
import 'progres_state.dart';

class ProgressBloc extends Bloc<ProgressEvent, ProgressState> {
  final GetOverallProgress getOverallProgress;
  final GetUserAnswers getUserAnswers;

  ProgressBloc({
    required this.getOverallProgress,
    required this.getUserAnswers,
  }) : super(ProgressInitial()) {
    on<LoadProgressEvent>(_onLoadProgress);
  }

  Future<void> _onLoadProgress(
      LoadProgressEvent event,
      Emitter<ProgressState> emit,
      ) async {
    emit(ProgressLoading());
    try {
      // Call use cases with NoParams
      final overallProgress = await getOverallProgress(NoParams());
      final recentAnswers = await getUserAnswers(NoParams());

      // Take only the most recent 10 answers
      final limitedAnswers = recentAnswers.take(10).toList();

      emit(ProgressLoaded(
        overallProgress: overallProgress,
        recentAnswers: limitedAnswers,
      ));
    } catch (e) {
      emit(ProgressError('Failed to load progress: ${e.toString()}'));
    }
  }
}
