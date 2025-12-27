import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entity/entity.dart';
import '../bloc/mcqs_bloc.dart';
import '../bloc/mcqs_event.dart';
import '../bloc/mcqs_state.dart';
import '../widget/mcqs_cards.dart';

class ReviewScreen extends StatefulWidget {
  final String userId;

  const ReviewScreen({super.key, required this.userId});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  @override
  void initState() {
    super.initState();
    _loadReviewQuestions();
  }

  void _loadReviewQuestions() {
    context.read<MCQBloc>().add(LoadQuestionsForReviewEvent(widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Questions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadReviewQuestions,
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
                          'Reviewing questions you\'ve struggled with.',
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

                      return MCQCard(
                        mcq: mcq,
                        questionNumber: index + 1,
                        selectedAnswer: mcq.correctAnswerIndex, // Always show the correct answer
                        showResult: true, // Always show the result
                        onAnswerSelected: (answerIndex) {},
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
