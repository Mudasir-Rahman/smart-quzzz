// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:uuid/uuid.dart';
//
// import '../../domain/entity/entity.dart';
// import '../bloc/mcqs_bloc.dart';
// import '../bloc/mcqs_event.dart';
// import '../bloc/mcqs_state.dart';
// import '../widget/mcqs_cards.dart';
//
//
// class MCQPracticeScreen extends StatefulWidget {
//   const MCQPracticeScreen({super.key});
//
//   @override
//   State<MCQPracticeScreen> createState() => _MCQPracticeScreenState();
// }
//
// class _MCQPracticeScreenState extends State<MCQPracticeScreen> {
//   final Map<String, DateTime> _startTimes = {};
//
//   @override
//   void initState() {
//     super.initState();
//     context.read<MCQBloc>().add(LoadAllMCQsEvent());
//   }
//
//   void _onAnswerSelected(MCQ mcq, int selectedIndex) {
//     if (!_startTimes.containsKey(mcq.id)) {
//       _startTimes[mcq.id] = DateTime.now();
//     }
//
//     final timeSpent = DateTime.now().difference(_startTimes[mcq.id]!).inSeconds;
//     final isCorrect = selectedIndex == mcq.correctAnswerIndex;
//
//     final answer = UserAnswer(
//       id: const Uuid().v4(),
//       mcqId: mcq.id,
//       selectedAnswerIndex: selectedIndex,
//       isCorrect: isCorrect,
//       answeredAt: DateTime.now(),
//       timeSpentSeconds: timeSpent,
//     );
//
//     context.read<MCQBloc>().add(SubmitAnswerEvent(answer));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Practice MCQs'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: () {
//               setState(() {
//                 _startTimes.clear();
//               });
//               context.read<MCQBloc>().add(LoadAllMCQsEvent());
//             },
//           ),
//         ],
//       ),
//       body: BlocBuilder<MCQBloc, MCQState>(
//         builder: (context, state) {
//           if (state is MCQLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           if (state is MCQError) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Icon(Icons.error_outline, size: 48, color: Colors.red),
//                   const SizedBox(height: 16),
//                   Text(
//                     state.message,
//                     style: const TextStyle(fontSize: 16),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: () {
//                       context.read<MCQBloc>().add(LoadAllMCQsEvent());
//                     },
//                     child: const Text('Retry'),
//                   ),
//                 ],
//               ),
//             );
//           }
//
//           if (state is MCQsLoaded) {
//             if (state.mcqs.isEmpty) {
//               return const Center(
//                 child: Text(
//                   'No questions available.\nAdd some questions to get started!',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontSize: 16),
//                 ),
//               );
//             }
//
//             return ListView.builder(
//               padding: const EdgeInsets.all(16),
//               itemCount: state.mcqs.length,
//               itemBuilder: (context, index) {
//                 final mcq = state.mcqs[index];
//                 final selectedAnswer = state.selectedAnswers[mcq.id];
//                 final showResult = state.showResults[mcq.id] ?? false;
//
//                 if (!_startTimes.containsKey(mcq.id)) {
//                   _startTimes[mcq.id] = DateTime.now();
//                 }
//
//                 return MCQCard(
//                   mcq: mcq,
//                   questionNumber: index + 1,
//                   selectedAnswer: selectedAnswer,
//                   showResult: showResult,
//                   onAnswerSelected: (answerIndex) {
//                     _onAnswerSelected(mcq, answerIndex);
//                   },
//                 );
//               },
//             );
//           }
//
//           return const Center(child: Text('Start practicing!'));
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entity/entity.dart';
import '../bloc/mcqs_bloc.dart';
import '../bloc/mcqs_event.dart';
import '../bloc/mcqs_state.dart';
import '../widget/mcqs_cards.dart';


class MCQPracticeScreen extends StatefulWidget {
  const MCQPracticeScreen({super.key});

  @override
  State<MCQPracticeScreen> createState() => _MCQPracticeScreenState();
}

class _MCQPracticeScreenState extends State<MCQPracticeScreen> {
  final Map<String, DateTime> _startTimes = {};

  @override
  void initState() {
    super.initState();
    context.read<MCQBloc>().add(LoadAllMCQsEvent());
  }

  void _onAnswerSelected(MCQ mcq, int selectedIndex) {
    if (!_startTimes.containsKey(mcq.id)) {
      _startTimes[mcq.id] = DateTime.now();
    }

    final timeSpent = DateTime.now().difference(_startTimes[mcq.id]!).inSeconds;
    final isCorrect = selectedIndex == mcq.correctAnswerIndex;

    final answer = UserAnswer(
      id: const Uuid().v4(),
      mcqId: mcq.id,
      selectedAnswerIndex: selectedIndex,
      isCorrect: isCorrect,
      answeredAt: DateTime.now(),
      timeSpentSeconds: timeSpent,
    );

    context.read<MCQBloc>().add(SubmitAnswerEvent(answer));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Practice MCQs'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _startTimes.clear();
              });
              context.read<MCQBloc>().add(LoadAllMCQsEvent());
            },
          ),
        ],
      ),
      body: BlocBuilder<MCQBloc, MCQState>(
        builder: (context, state) {
          if (state is MCQLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MCQError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                    ),
                    onPressed: () {
                      context.read<MCQBloc>().add(LoadAllMCQsEvent());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is MCQsLoaded) {
            if (state.mcqs.isEmpty) {
              return const Center(
                child: Text(
                  'No questions available.\nAdd some questions to get started!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              );
            }

            final total = state.mcqs.length;
            final completed = state.selectedAnswers.length;

            return Column(
              children: [
                // Progress Bar
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: LinearProgressIndicator(
                    value: total == 0 ? 0 : completed / total,
                    backgroundColor: Colors.grey[300],
                    color: Colors.deepPurple,
                    minHeight: 8,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: state.mcqs.length,
                    itemBuilder: (context, index) {
                      final mcq = state.mcqs[index];
                      final selectedAnswer = state.selectedAnswers[mcq.id];
                      final showResult = state.showResults[mcq.id] ?? false;

                      if (!_startTimes.containsKey(mcq.id)) {
                        _startTimes[mcq.id] = DateTime.now();
                      }

                      return MCQCard(
                        mcq: mcq,
                        questionNumber: index + 1,
                        selectedAnswer: selectedAnswer,
                        showResult: showResult,
                        onAnswerSelected: (answerIndex) {
                          _onAnswerSelected(mcq, answerIndex);
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          }

          return const Center(child: Text('Start practicing!'));
        },
      ),
    );
  }
}
