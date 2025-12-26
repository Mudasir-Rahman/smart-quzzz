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
// class ReviewScreen extends StatefulWidget {
//   const ReviewScreen({super.key, required String userId});
//
//   @override
//   State<ReviewScreen> createState() => _ReviewScreenState();
// }
//
// class _ReviewScreenState extends State<ReviewScreen> {
//   final Map<String, DateTime> _startTimes = {};
//
//   @override
//   void initState() {
//     super.initState();
//     context.read<MCQBloc>().add(LoadQuestionsForReviewEvent());
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
//         title: const Text('Review Questions'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: () {
//               setState(() {
//                 _startTimes.clear();
//               });
//               context.read<MCQBloc>().add(LoadQuestionsForReviewEvent());
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
//                       context.read<MCQBloc>().add(LoadQuestionsForReviewEvent());
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
//               return Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       Icons.check_circle_outline,
//                       size: 80,
//                       color: Colors.green[300],
//                     ),
//                     const SizedBox(height: 24),
//                     const Text(
//                       'Great job!',
//                       style: TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     const Text(
//                       'No questions need review right now.',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(fontSize: 16),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       'Keep practicing to master all questions!',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//                     ),
//                   ],
//                 ),
//               );
//             }
//
//             return Column(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(16),
//                   color: Colors.blue[50],
//                   child: Row(
//                     children: [
//                       const Icon(Icons.info_outline, color: Colors.blue),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: Text(
//                           'These questions need review based on your performance and spaced repetition.',
//                           style: TextStyle(color: Colors.blue[900]),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Expanded(
//                   child: ListView.builder(
//                     padding: const EdgeInsets.all(16),
//                     itemCount: state.mcqs.length,
//                     itemBuilder: (context, index) {
//                       final mcq = state.mcqs[index];
//                       final selectedAnswer = state.selectedAnswers[mcq.id];
//                       final showResult = state.showResults[mcq.id] ?? false;
//
//                       if (!_startTimes.containsKey(mcq.id)) {
//                         _startTimes[mcq.id] = DateTime.now();
//                       }
//
//                       return MCQCard(
//                         mcq: mcq,
//                         questionNumber: index + 1,
//                         selectedAnswer: selectedAnswer,
//                         showResult: showResult,
//                         onAnswerSelected: (answerIndex) {
//                           _onAnswerSelected(mcq, answerIndex);
//                         },
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             );
//           }
//
//           return const Center(child: Text('Start reviewing!'));
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entity/entity.dart';
import '../bloc/mcqs_bloc.dart';
import '../bloc/mcqs_event.dart';
import '../bloc/mcqs_state.dart';
import '../widget/mcqs_cards.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key, required String userId});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final Map<String, DateTime> _startTimes = {};

  String? get _currentUserId {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      return user?.id;
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _loadReviewQuestions();
  }

  void _loadReviewQuestions() {
    if (_currentUserId == null) {
      print('❌ No user logged in');
      return;
    }
    print('🔄 Loading review questions for user: $_currentUserId');
    context.read<MCQBloc>().add(LoadQuestionsForReviewEvent());
  }

  void _onAnswerSelected(MCQ mcq, int selectedIndex) {
    if (_currentUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login to submit answers')),
      );
      return;
    }

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

    context.read<MCQBloc>().add(SubmitAnswerEvent(answer: answer));
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUserId == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Review Questions'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.login,
                size: 80,
                color: Colors.orange.shade300,
              ),
              const SizedBox(height: 24),
              const Text(
                'Please Login',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'You need to be logged in to review',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Questions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _startTimes.clear();
              });
              _loadReviewQuestions();
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
                    onPressed: _loadReviewQuestions,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is MCQsLoaded) {
            if (state.mcqs.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 80,
                      color: Colors.green[300],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Great job!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'No questions need review right now.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Keep practicing to master all questions!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.blue[50],
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: Colors.blue),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'These questions need review based on your performance and spaced repetition.',
                          style: TextStyle(color: Colors.blue[900]),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
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

          return const Center(child: Text('Start reviewing!'));
        },
      ),
    );
  }
}