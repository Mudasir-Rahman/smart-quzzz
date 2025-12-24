// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fl_chart/fl_chart.dart';
//
// import '../progress_bloc/progres_bloc.dart';
// import '../progress_bloc/progres_event.dart';
// import '../progress_bloc/progres_state.dart';
//
// class ProgressScreen extends StatefulWidget {
//   const ProgressScreen({super.key});
//
//   @override
//   State<ProgressScreen> createState() => _ProgressScreenState();
// }
//
// class _ProgressScreenState extends State<ProgressScreen> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<ProgressBloc>().add(LoadProgressEvent());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Your Progress'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: () {
//               context.read<ProgressBloc>().add(LoadProgressEvent());
//             },
//           ),
//         ],
//       ),
//       body: BlocBuilder<ProgressBloc, ProgressState>(
//         builder: (context, state) {
//           if (state is ProgressLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           if (state is ProgressError) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Icon(Icons.error_outline, size: 48, color: Colors.red),
//                   const SizedBox(height: 16),
//                   Text(state.message),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: () {
//                       context.read<ProgressBloc>().add(LoadProgressEvent());
//                     },
//                     child: const Text('Retry'),
//                   ),
//                 ],
//               ),
//             );
//           }
//
//           if (state is ProgressLoaded) {
//             final progress = state.overallProgress;
//
//             // Ensure correct answers are counted
//             final totalCorrect = progress.totalCorrectAnswers;
//             final totalIncorrect = progress.totalIncorrectAnswers;
//
//             return SingleChildScrollView(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildOverviewCard(progress),
//                   const SizedBox(height: 16),
//                   _buildAccuracyChart(totalCorrect, totalIncorrect),
//                   const SizedBox(height: 16),
//                   _buildStreakCard(progress),
//                   const SizedBox(height: 16),
//                   _buildCategoryPerformance(progress),
//                   const SizedBox(height: 16),
//                   _buildRecentActivity(state.recentAnswers),
//                 ],
//               ),
//             );
//           }
//
//           return const Center(
//             child: Text('No progress data yet. Start practicing!'),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildOverviewCard(progress) {
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       elevation: 4,
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Overview',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 _buildStatItem(
//                   'Total',
//                   progress.totalQuestionsAttempted.toString(),
//                   Icons.quiz,
//                   Colors.blue,
//                 ),
//                 _buildStatItem(
//                   'Correct',
//                   progress.totalCorrectAnswers.toString(),
//                   Icons.check_circle,
//                   Colors.green,
//                 ),
//                 _buildStatItem(
//                   'Incorrect',
//                   progress.totalIncorrectAnswers.toString(),
//                   Icons.cancel,
//                   Colors.red,
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildStatItem(String label, String value, IconData icon, Color color) {
//     return Column(
//       children: [
//         Icon(icon, color: color, size: 32),
//         const SizedBox(height: 8),
//         Text(
//           value,
//           style: TextStyle(
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//             color: color,
//           ),
//         ),
//         Text(
//           label,
//           style: TextStyle(color: Colors.grey[600]),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildAccuracyChart(int correct, int incorrect) {
//     final total = correct + incorrect;
//     final accuracy = total > 0 ? (correct / total) * 100 : 0;
//
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       elevation: 4,
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Overall Accuracy',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 24),
//             SizedBox(
//               height: 200,
//               child: PieChart(
//                 PieChartData(
//                   sectionsSpace: 2,
//                   centerSpaceRadius: 60,
//                   sections: [
//                     PieChartSectionData(
//                       value: correct.toDouble(),
//                       title: '${accuracy.toStringAsFixed(1)}%',
//                       color: Colors.green,
//                       radius: 60,
//                       titleStyle: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                     PieChartSectionData(
//                       value: incorrect.toDouble(),
//                       title: '',
//                       color: Colors.red,
//                       radius: 50,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildStreakCard(progress) {
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       elevation: 4,
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             Column(
//               children: [
//                 const Icon(Icons.local_fire_department, color: Colors.orange, size: 40),
//                 const SizedBox(height: 8),
//                 Text(
//                   progress.currentStreak.toString(),
//                   style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                 ),
//                 const Text('Current Streak'),
//               ],
//             ),
//             Column(
//               children: [
//                 const Icon(Icons.emoji_events, color: Colors.amber, size: 40),
//                 const SizedBox(height: 8),
//                 Text(
//                   progress.longestStreak.toString(),
//                   style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                 ),
//                 const Text('Longest Streak'),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCategoryPerformance(progress) {
//     if (progress.categoryPerformance.isEmpty) return const SizedBox.shrink();
//
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       elevation: 4,
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Category Performance',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             ...progress.categoryPerformance.entries.map((entry) {
//               final value = entry.value > 10 ? 10.0 : entry.value.toDouble();
//               return Padding(
//                 padding: const EdgeInsets.only(bottom: 12),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       entry.key,
//                       style: const TextStyle(fontWeight: FontWeight.w600),
//                     ),
//                     const SizedBox(height: 4),
//                     LinearProgressIndicator(
//                       value: value / 10,
//                       backgroundColor: Colors.grey[200],
//                       valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       '${entry.value} correct',
//                       style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//                     ),
//                   ],
//                 ),
//               );
//             }).toList(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildRecentActivity(List<dynamic> recentAnswers) {
//     if (recentAnswers.isEmpty) return const SizedBox.shrink();
//
//     String shortId(String id, [int length = 8]) {
//       return id.length > length ? id.substring(0, length) : id;
//     }
//
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       elevation: 4,
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Recent Activity',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             ...recentAnswers.map((answer) {
//               return Container(
//                 margin: const EdgeInsets.only(bottom: 12),
//                 decoration: BoxDecoration(
//                   color: answer.isCorrect ? Colors.green[50] : Colors.red[50],
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: ListTile(
//                   leading: Icon(
//                     answer.isCorrect ? Icons.check_circle : Icons.cancel,
//                     color: answer.isCorrect ? Colors.green : Colors.red,
//                   ),
//                   title: Text('Question ${shortId(answer.mcqId)}'),
//                   subtitle: Text('Answered ${_formatDate(answer.answeredAt)}'),
//                   trailing: Text('${answer.timeSpentSeconds}s'),
//                 ),
//               );
//             }).toList(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   String _formatDate(DateTime date) {
//     final now = DateTime.now();
//     final difference = now.difference(date);
//
//     if (difference.inDays > 0) return '${difference.inDays}d ago';
//     if (difference.inHours > 0) return '${difference.inHours}h ago';
//     if (difference.inMinutes > 0) return '${difference.inMinutes}m ago';
//     return 'Just now';
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';

import '../progress_bloc/progres_bloc.dart';
import '../progress_bloc/progres_event.dart';
import '../progress_bloc/progres_state.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProgressBloc>().add(LoadProgressEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Progress'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<ProgressBloc>().add(LoadProgressEvent());
            },
          ),
        ],
      ),
      body: BlocBuilder<ProgressBloc, ProgressState>(
        builder: (context, state) {
          if (state is ProgressLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProgressError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ProgressBloc>().add(LoadProgressEvent());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is ProgressLoaded) {
            final progress = state.overallProgress;

            final totalCorrect = progress.totalCorrectAnswers;
            final totalIncorrect = progress.totalIncorrectAnswers;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOverviewCard(progress),
                  const SizedBox(height: 16),
                  _buildAccuracyChart(totalCorrect, totalIncorrect),
                  const SizedBox(height: 16),
                  _buildStreakCard(progress),
                  const SizedBox(height: 16),
                  _buildCategoryPerformance(progress),
                  const SizedBox(height: 16),
                  _buildRecentActivity(state.recentAnswers),
                ],
              ),
            );
          }

          return const Center(
            child: Text('No progress data yet. Start practicing!'),
          );
        },
      ),
    );
  }

  Widget _buildOverviewCard(progress) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Overview',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'Total',
                  progress.totalQuestionsAttempted.toString(),
                  Icons.quiz,
                  Colors.blue,
                ),
                _buildStatItem(
                  'Correct',
                  progress.totalCorrectAnswers.toString(),
                  Icons.check_circle,
                  Colors.green,
                ),
                _buildStatItem(
                  'Incorrect',
                  progress.totalIncorrectAnswers.toString(),
                  Icons.cancel,
                  Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildAccuracyChart(int correct, int incorrect) {
    final total = correct + incorrect;
    final accuracy = total > 0 ? (correct / total) * 100 : 0;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Overall Accuracy',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 60,
                  sections: [
                    PieChartSectionData(
                      value: correct.toDouble(),
                      title: '${accuracy.toStringAsFixed(1)}%',
                      color: Colors.green,
                      radius: 60,
                      titleStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      value: incorrect.toDouble(),
                      title: '',
                      color: Colors.red,
                      radius: 50,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakCard(progress) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                const Icon(Icons.local_fire_department, color: Colors.orange, size: 40),
                const SizedBox(height: 8),
                Text(
                  progress.currentStreak.toString(),
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const Text('Current Streak'),
              ],
            ),
            Column(
              children: [
                const Icon(Icons.emoji_events, color: Colors.amber, size: 40),
                const SizedBox(height: 8),
                Text(
                  progress.longestStreak.toString(),
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const Text('Longest Streak'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryPerformance(progress) {
    if (progress.categoryPerformance.isEmpty) return const SizedBox.shrink();

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Category Performance',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...progress.categoryPerformance.entries.map((entry) {
              final value = entry.value > 10 ? 10.0 : entry.value.toDouble();
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.key,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: value / 10,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${entry.value} correct',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity(List<dynamic> recentAnswers) {
    if (recentAnswers.isEmpty) return const SizedBox.shrink();

    String shortId(String id, [int length = 8]) {
      return id.length <= length ? id : id.substring(0, length);
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Activity',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...recentAnswers.map((answer) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: answer.isCorrect ? Colors.green[50] : Colors.red[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: Icon(
                    answer.isCorrect ? Icons.check_circle : Icons.cancel,
                    color: answer.isCorrect ? Colors.green : Colors.red,
                  ),
                  title: Text('Question ${shortId(answer.mcqId)}'),
                  subtitle: Text('Answered ${_formatDate(answer.answeredAt)}'),
                  trailing: Text('${answer.timeSpentSeconds}s'),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) return '${difference.inDays}d ago';
    if (difference.inHours > 0) return '${difference.inHours}h ago';
    if (difference.inMinutes > 0) return '${difference.inMinutes}m ago';
    return 'Just now';
  }
}
