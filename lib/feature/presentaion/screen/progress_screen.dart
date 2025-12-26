//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fl_chart/fl_chart.dart';
//
// import '../progress_bloc/progres_bloc.dart';
// import '../progress_bloc/progres_event.dart';
// import '../progress_bloc/progres_state.dart';
//
// class ProgressScreen extends StatefulWidget {
//   const ProgressScreen({super.key, required String userId});
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
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Colors.blue.shade50,
//               Colors.white,
//             ],
//           ),
//         ),
//         child: SafeArea(
//           child: Column(
//             children: [
//               _buildHeader(context),
//               Expanded(
//                 child: BlocBuilder<ProgressBloc, ProgressState>(
//                   builder: (context, state) {
//                     if (state is ProgressLoading) {
//                       return const Center(child: CircularProgressIndicator());
//                     }
//
//                     if (state is ProgressError) {
//                       return _buildErrorState(context, state.message);
//                     }
//
//                     if (state is ProgressLoaded) {
//                       final progress = state.overallProgress;
//                       return SingleChildScrollView(
//                         padding: const EdgeInsets.all(16),
//                         child: Column(
//                           children: [
//                             _buildStatsCards(progress),
//                             const SizedBox(height: 20),
//                             _buildAccuracyCard(progress),
//                             const SizedBox(height: 20),
//                             _buildStreakCard(progress),
//                             const SizedBox(height: 20),
//                             _buildCategoryPerformance(progress),
//                             const SizedBox(height: 20),
//                             _buildRecentActivity(state.recentAnswers),
//                           ],
//                         ),
//                       );
//                     }
//
//                     return _buildEmptyState();
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildHeader(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Colors.blue.shade400, Colors.blue.shade600],
//               ),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: const Icon(Icons.analytics, color: Colors.white, size: 28),
//           ),
//           const SizedBox(width: 16),
//           const Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Your Progress',
//                   style: TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 Text(
//                   'Track your performance',
//                   style: TextStyle(fontSize: 14, color: Colors.grey),
//                 ),
//               ],
//             ),
//           ),
//           IconButton(
//             icon: const Icon(Icons.refresh_rounded),
//             onPressed: () {
//               context.read<ProgressBloc>().add(LoadProgressEvent());
//             },
//             style: IconButton.styleFrom(
//               backgroundColor: Colors.blue.shade50,
//               foregroundColor: Colors.blue,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStatsCards(progress) {
//     return Row(
//       children: [
//         Expanded(
//           child: _buildStatCard(
//             'Total',
//             progress.totalQuestionsAttempted.toString(),
//             Icons.quiz_outlined,
//             Colors.blue,
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: _buildStatCard(
//             'Correct',
//             progress.totalCorrectAnswers.toString(),
//             Icons.check_circle_outline,
//             Colors.green,
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: _buildStatCard(
//             'Wrong',
//             progress.totalIncorrectAnswers.toString(),
//             Icons.cancel_outlined,
//             Colors.red,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildStatCard(String label, String value, IconData icon, Color color) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: color.withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.1),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(icon, color: color, size: 24),
//           ),
//           const SizedBox(height: 12),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: color,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 12,
//               color: Colors.grey[600],
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildAccuracyCard(progress) {
//     final correct = progress.totalCorrectAnswers;
//     final incorrect = progress.totalIncorrectAnswers;
//     final total = correct + incorrect;
//     final accuracy = total > 0 ? (correct / total) * 100 : 0;
//
//     return Container(
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             blurRadius: 15,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text(
//                 'Overall Accuracy',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: accuracy >= 70
//                         ? [Colors.green.shade400, Colors.green.shade600]
//                         : accuracy >= 50
//                         ? [Colors.orange.shade400, Colors.orange.shade600]
//                         : [Colors.red.shade400, Colors.red.shade600],
//                   ),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Text(
//                   '${accuracy.toStringAsFixed(1)}%',
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 24),
//           SizedBox(
//             height: 200,
//             child: total > 0
//                 ? PieChart(
//               PieChartData(
//                 sectionsSpace: 3,
//                 centerSpaceRadius: 60,
//                 sections: [
//                   PieChartSectionData(
//                     value: correct.toDouble(),
//                     title: '$correct',
//                     color: Colors.green,
//                     radius: 60,
//                     titleStyle: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                   PieChartSectionData(
//                     value: incorrect.toDouble(),
//                     title: '$incorrect',
//                     color: Colors.red,
//                     radius: 50,
//                     titleStyle: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ],
//               ),
//             )
//                 : Center(
//               child: Text(
//                 'No data yet',
//                 style: TextStyle(color: Colors.grey[400], fontSize: 16),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStreakCard(progress) {
//     return Container(
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Colors.orange.shade400, Colors.deepOrange.shade600],
//         ),
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.orange.withOpacity(0.3),
//             blurRadius: 15,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: _buildStreakItem(
//               'Current Streak',
//               progress.currentStreak.toString(),
//               Icons.local_fire_department,
//             ),
//           ),
//           Container(
//             width: 2,
//             height: 60,
//             color: Colors.white.withOpacity(0.3),
//           ),
//           Expanded(
//             child: _buildStreakItem(
//               'Best Streak',
//               progress.longestStreak.toString(),
//               Icons.emoji_events,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStreakItem(String label, String value, IconData icon) {
//     return Column(
//       children: [
//         Icon(icon, color: Colors.white, size: 36),
//         const SizedBox(height: 12),
//         Text(
//           value,
//           style: const TextStyle(
//             fontSize: 32,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 14,
//             color: Colors.white.withOpacity(0.9),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildCategoryPerformance(progress) {
//     if (progress.categoryPerformance.isEmpty) return const SizedBox.shrink();
//
//     return Container(
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             blurRadius: 15,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Category Performance',
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 20),
//           ...progress.categoryPerformance.entries.map((entry) {
//             final value = entry.value > 10 ? 10.0 : entry.value.toDouble();
//             final percentage = (value / 10 * 100).toInt();
//             return Padding(
//               padding: const EdgeInsets.only(bottom: 16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         entry.key,
//                         style: const TextStyle(
//                           fontWeight: FontWeight.w600,
//                           fontSize: 15,
//                         ),
//                       ),
//                       Text(
//                         '${entry.value} correct',
//                         style: TextStyle(
//                           fontSize: 13,
//                           color: Colors.grey[600],
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(10),
//                     child: LinearProgressIndicator(
//                       value: value / 10,
//                       backgroundColor: Colors.grey[200],
//                       valueColor: AlwaysStoppedAnimation<Color>(
//                         percentage >= 70
//                             ? Colors.green
//                             : percentage >= 50
//                             ? Colors.orange
//                             : Colors.red,
//                       ),
//                       minHeight: 8,
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }).toList(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildRecentActivity(List<dynamic> recentAnswers) {
//     if (recentAnswers.isEmpty) return const SizedBox.shrink();
//
//     return Container(
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             blurRadius: 15,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Recent Activity',
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 16),
//           ...recentAnswers.map((answer) {
//             return Container(
//               margin: const EdgeInsets.only(bottom: 12),
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: answer.isCorrect
//                       ? [Colors.green.shade50, Colors.green.shade100]
//                       : [Colors.red.shade50, Colors.red.shade100],
//                 ),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Row(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       color: answer.isCorrect ? Colors.green : Colors.red,
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Icon(
//                       answer.isCorrect ? Icons.check : Icons.close,
//                       color: Colors.white,
//                       size: 20,
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Question ${_shortId(answer.mcqId)}',
//                           style: const TextStyle(fontWeight: FontWeight.w600),
//                         ),
//                         Text(
//                           _formatDate(answer.answeredAt),
//                           style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Text(
//                       '${answer.timeSpentSeconds}s',
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 12,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }).toList(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildErrorState(BuildContext context, String message) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
//           const SizedBox(height: 16),
//           Text(message, style: const TextStyle(fontSize: 16)),
//           const SizedBox(height: 16),
//           ElevatedButton(
//             onPressed: () {
//               context.read<ProgressBloc>().add(LoadProgressEvent());
//             },
//             child: const Text('Retry'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.analytics_outlined, size: 80, color: Colors.grey[300]),
//           const SizedBox(height: 16),
//           Text(
//             'No progress data yet',
//             style: TextStyle(fontSize: 18, color: Colors.grey[600]),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'Start practicing to see your stats!',
//             style: TextStyle(fontSize: 14, color: Colors.grey[500]),
//           ),
//         ],
//       ),
//     );
//   }
//
//   String _formatDate(DateTime date) {
//     final now = DateTime.now();
//     final difference = now.difference(date);
//     if (difference.inDays > 0) return '${difference.inDays}d ago';
//     if (difference.inHours > 0) return '${difference.inHours}h ago';
//     if (difference.inMinutes > 0) return '${difference.inMinutes}m ago';
//     return 'Just now';
//   }
//
//   String _shortId(String id) {
//     if (id.length <= 8) return id;
//     return id.substring(0, 8);
//   }
// }
// Update your ProgressScreen to use proper data
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fl_chart/fl_chart.dart';
//
//
// import '../../domain/entity/entity.dart';
// import '../progress_bloc/progres_bloc.dart';
// import '../progress_bloc/progres_event.dart';
// import '../progress_bloc/progres_state.dart';
//
// class ProgressScreen extends StatefulWidget {
//   const ProgressScreen({super.key, required String userId});
//
//   @override
//   State<ProgressScreen> createState() => _ProgressScreenState();
// }
//
// class _ProgressScreenState extends State<ProgressScreen> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<ProgressBloc>().add(LoadProgressEvent());
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Colors.blue.shade50,
//               Colors.white,
//             ],
//           ),
//         ),
//         child: SafeArea(
//           child: Column(
//             children: [
//               _buildHeader(context),
//               Expanded(
//                 child: BlocBuilder<ProgressBloc, ProgressState>(
//                   builder: (context, state) {
//                     if (state is ProgressLoading) {
//                       return const Center(child: CircularProgressIndicator());
//                     }
//
//                     if (state is ProgressError) {
//                       return _buildErrorState(context, state.message);
//                     }
//
//                     if (state is ProgressLoaded) {
//                       final progress = state.overallProgress;
//                       final recentAnswers = state.recentAnswers;
//
//                       return SingleChildScrollView(
//                         padding: const EdgeInsets.all(16),
//                         child: Column(
//                           children: [
//                             _buildStatsCards(progress),
//                             const SizedBox(height: 20),
//                             _buildAccuracyCard(progress),
//                             const SizedBox(height: 20),
//                             _buildStreakCard(progress),
//                             const SizedBox(height: 20),
//                             _buildCategoryPerformance(progress),
//                             const SizedBox(height: 20),
//                             _buildRecentActivity(recentAnswers),
//                           ],
//                         ),
//                       );
//                     }
//
//                     return _buildEmptyState();
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildHeader(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Colors.blue.shade400, Colors.blue.shade600],
//               ),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: const Icon(Icons.analytics, color: Colors.white, size: 28),
//           ),
//           const SizedBox(width: 16),
//           const Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Your Progress',
//                   style: TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 Text(
//                   'Track your performance',
//                   style: TextStyle(fontSize: 14, color: Colors.grey),
//                 ),
//               ],
//             ),
//           ),
//           IconButton(
//             icon: const Icon(Icons.refresh_rounded),
//             onPressed: () {
//               context.read<ProgressBloc>().add(LoadProgressEvent());
//             },
//             style: IconButton.styleFrom(
//               backgroundColor: Colors.blue.shade50,
//               foregroundColor: Colors.blue,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStatsCards(OverallProgress progress) {
//     return Row(
//       children: [
//         Expanded(
//           child: _buildStatCard(
//             'Total',
//             progress.totalQuestionsAttempted.toString(),
//             Icons.quiz_outlined,
//             Colors.blue,
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: _buildStatCard(
//             'Correct',
//             progress.totalCorrectAnswers.toString(),
//             Icons.check_circle_outline,
//             Colors.green,
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: _buildStatCard(
//             'Wrong',
//             progress.totalIncorrectAnswers.toString(),
//             Icons.cancel_outlined,
//             Colors.red,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildStatCard(String label, String value, IconData icon, Color color) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: color.withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.1),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(icon, color: color, size: 24),
//           ),
//           const SizedBox(height: 12),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: color,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 12,
//               color: Colors.grey[600],
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildAccuracyCard(OverallProgress progress) {
//     final correct = progress.totalCorrectAnswers;
//     final incorrect = progress.totalIncorrectAnswers;
//     final total = correct + incorrect;
//     final accuracy = total > 0 ? (correct / total) * 100 : 0;
//
//     return Container(
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             blurRadius: 15,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text(
//                 'Overall Accuracy',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: accuracy >= 70
//                         ? [Colors.green.shade400, Colors.green.shade600]
//                         : accuracy >= 50
//                         ? [Colors.orange.shade400, Colors.orange.shade600]
//                         : [Colors.red.shade400, Colors.red.shade600],
//                   ),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Text(
//                   '${accuracy.toStringAsFixed(1)}%',
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 24),
//           SizedBox(
//             height: 200,
//             child: total > 0
//                 ? PieChart(
//               PieChartData(
//                 sectionsSpace: 3,
//                 centerSpaceRadius: 60,
//                 sections: [
//                   PieChartSectionData(
//                     value: correct.toDouble(),
//                     title: '$correct',
//                     color: Colors.green,
//                     radius: 60,
//                     titleStyle: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                   PieChartSectionData(
//                     value: incorrect.toDouble(),
//                     title: '$incorrect',
//                     color: Colors.red,
//                     radius: 50,
//                     titleStyle: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ],
//               ),
//             )
//                 : Center(
//               child: Text(
//                 'No data yet',
//                 style: TextStyle(color: Colors.grey[400], fontSize: 16),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStreakCard(OverallProgress progress) {
//     return Container(
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Colors.orange.shade400, Colors.deepOrange.shade600],
//         ),
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.orange.withOpacity(0.3),
//             blurRadius: 15,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: _buildStreakItem(
//               'Current Streak',
//               progress.currentStreak.toString(),
//               Icons.local_fire_department,
//             ),
//           ),
//           Container(
//             width: 2,
//             height: 60,
//             color: Colors.white.withOpacity(0.3),
//           ),
//           Expanded(
//             child: _buildStreakItem(
//               'Best Streak',
//               progress.longestStreak.toString(),
//               Icons.emoji_events,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStreakItem(String label, String value, IconData icon) {
//     return Column(
//       children: [
//         Icon(icon, color: Colors.white, size: 36),
//         const SizedBox(height: 12),
//         Text(
//           value,
//           style: const TextStyle(
//             fontSize: 32,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 14,
//             color: Colors.white.withOpacity(0.9),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildCategoryPerformance(OverallProgress progress) {
//     if (progress.categoryPerformance.isEmpty) {
//       return Container(
//         padding: const EdgeInsets.all(24),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.1),
//               blurRadius: 15,
//               offset: const Offset(0, 5),
//             ),
//           ],
//         ),
//         child: const Center(
//           child: Text(
//             'No category data yet. Start answering questions!',
//             style: TextStyle(
//               fontSize: 16,
//               color: Colors.grey,
//             ),
//           ),
//         ),
//       );
//     }
//
//     return Container(
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             blurRadius: 15,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Category Performance',
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 20),
//           ...progress.categoryPerformance.entries.map((entry) {
//             final value = entry.value > 10 ? 10.0 : entry.value.toDouble();
//             final percentage = (value / 10 * 100).toInt();
//             return Padding(
//               padding: const EdgeInsets.only(bottom: 16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Expanded(
//                         child: Text(
//                           entry.key,
//                           style: const TextStyle(
//                             fontWeight: FontWeight.w600,
//                             fontSize: 15,
//                           ),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                       Text(
//                         '${entry.value} correct',
//                         style: TextStyle(
//                           fontSize: 13,
//                           color: Colors.grey[600],
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(10),
//                     child: LinearProgressIndicator(
//                       value: value / 10,
//                       backgroundColor: Colors.grey[200],
//                       valueColor: AlwaysStoppedAnimation<Color>(
//                         percentage >= 70
//                             ? Colors.green
//                             : percentage >= 50
//                             ? Colors.orange
//                             : Colors.red,
//                       ),
//                       minHeight: 8,
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }).toList(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildRecentActivity(List<UserAnswer> recentAnswers) {
//     if (recentAnswers.isEmpty) {
//       return Container(
//         padding: const EdgeInsets.all(24),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.1),
//               blurRadius: 15,
//               offset: const Offset(0, 5),
//             ),
//           ],
//         ),
//         child: const Center(
//           child: Text(
//             'No recent activity yet. Start practicing!',
//             style: TextStyle(
//               fontSize: 16,
//               color: Colors.grey,
//             ),
//           ),
//         ),
//       );
//     }
//
//     return Container(
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             blurRadius: 15,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Recent Activity',
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 16),
//           ...recentAnswers.map((answer) {
//             return Container(
//               margin: const EdgeInsets.only(bottom: 12),
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: answer.isCorrect
//                       ? [Colors.green.shade50, Colors.green.shade100]
//                       : [Colors.red.shade50, Colors.red.shade100],
//                 ),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Row(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       color: answer.isCorrect ? Colors.green : Colors.red,
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Icon(
//                       answer.isCorrect ? Icons.check : Icons.close,
//                       color: Colors.white,
//                       size: 20,
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Question ${_shortId(answer.mcqId)}',
//                           style: const TextStyle(fontWeight: FontWeight.w600),
//                         ),
//                         Text(
//                           _formatDate(answer.answeredAt),
//                           style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Text(
//                       '${answer.timeSpentSeconds ?? 0}s',
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 12,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }).toList(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildErrorState(BuildContext context, String message) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
//           const SizedBox(height: 16),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Text(
//               message,
//               style: const TextStyle(fontSize: 16),
//               textAlign: TextAlign.center,
//             ),
//           ),
//           const SizedBox(height: 16),
//           ElevatedButton(
//             onPressed: () {
//               context.read<ProgressBloc>().add(LoadProgressEvent());
//             },
//             child: const Text('Retry'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.analytics_outlined, size: 80, color: Colors.grey[300]),
//           const SizedBox(height: 16),
//           Text(
//             'No progress data yet',
//             style: TextStyle(fontSize: 18, color: Colors.grey[600]),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'Start practicing to see your stats!',
//             style: TextStyle(fontSize: 14, color: Colors.grey[500]),
//           ),
//           const SizedBox(height: 16),
//           ElevatedButton(
//             onPressed: () {
//               // Navigate to practice screen
//               Navigator.pushNamed(context, '/practice');
//             },
//             child: const Text('Start Practicing'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   String _formatDate(DateTime date) {
//     final now = DateTime.now();
//     final difference = now.difference(date);
//     if (difference.inDays > 0) return '${difference.inDays}d ago';
//     if (difference.inHours > 0) return '${difference.inHours}h ago';
//     if (difference.inMinutes > 0) return '${difference.inMinutes}m ago';
//     return 'Just now';
//   }
//
//   String _shortId(String id) {
//     if (id.length <= 6) return id;
//     return '${id.substring(0, 6)}...';
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../domain/entity/entity.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProgressBloc>().add(LoadProgressEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade50,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: BlocBuilder<ProgressBloc, ProgressState>(
                  builder: (context, state) {
                    if (state is ProgressLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is ProgressError) {
                      return _buildErrorState(state.message);
                    }

                    if (state is ProgressLoaded) {
                      final progress = state.overallProgress;
                      final recentAnswers = state.recentAnswers;

                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            _buildStatsCards(progress),
                            const SizedBox(height: 20),
                            _buildAccuracyCard(progress),
                            const SizedBox(height: 20),
                            _buildStreakCard(progress),
                            const SizedBox(height: 20),
                            _buildCategoryPerformance(progress),
                            const SizedBox(height: 20),
                            _buildRecentActivity(recentAnswers),
                          ],
                        ),
                      );
                    }

                    return _buildEmptyState();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade400, Colors.blue.shade600],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.analytics, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Progress',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'Track your performance',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              context.read<ProgressBloc>().add(LoadProgressEvent());
            },
            style: IconButton.styleFrom(
              backgroundColor: Colors.blue.shade50,
              foregroundColor: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards(OverallProgress progress) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Total',
            progress.totalQuestionsAttempted.toString(),
            Icons.quiz_outlined,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Correct',
            progress.totalCorrectAnswers.toString(),
            Icons.check_circle_outline,
            Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Wrong',
            progress.totalIncorrectAnswers.toString(),
            Icons.cancel_outlined,
            Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccuracyCard(OverallProgress progress) {
    final correct = progress.totalCorrectAnswers;
    final incorrect = progress.totalIncorrectAnswers;
    final total = correct + incorrect;
    final accuracy = total > 0 ? (correct / total) * 100 : 0;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Overall Accuracy',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: accuracy >= 70
                        ? [Colors.green.shade400, Colors.green.shade600]
                        : accuracy >= 50
                        ? [Colors.orange.shade400, Colors.orange.shade600]
                        : [Colors.red.shade400, Colors.red.shade600],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${accuracy.toStringAsFixed(1)}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: total > 0
                ? PieChart(
              PieChartData(
                sectionsSpace: 3,
                centerSpaceRadius: 60,
                sections: [
                  PieChartSectionData(
                    value: correct.toDouble(),
                    title: '$correct',
                    color: Colors.green,
                    radius: 60,
                    titleStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  PieChartSectionData(
                    value: incorrect.toDouble(),
                    title: '$incorrect',
                    color: Colors.red,
                    radius: 50,
                    titleStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              ),
            )
                : Center(
              child: Text(
                'No data yet',
                style: TextStyle(color: Colors.grey[400], fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakCard(OverallProgress progress) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange.shade400, Colors.deepOrange.shade600],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStreakItem(
              'Current Streak',
              progress.currentStreak.toString(),
              Icons.local_fire_department,
            ),
          ),
          Container(
            width: 2,
            height: 60,
            color: Colors.white.withOpacity(0.3),
          ),
          Expanded(
            child: _buildStreakItem(
              'Best Streak',
              progress.longestStreak.toString(),
              Icons.emoji_events,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 36),
        const SizedBox(height: 12),
        Text(
          value,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryPerformance(OverallProgress progress) {
    if (progress.categoryPerformance.isEmpty) {
      return Container();
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Category Performance',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ...progress.categoryPerformance.entries.map((entry) {
            final value = entry.value > 10 ? 10.0 : entry.value.toDouble();
            final percentage = (value / 10 * 100).toInt();
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          entry.key,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '${entry.value} correct',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: value / 10,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        percentage >= 70
                            ? Colors.green
                            : percentage >= 50
                            ? Colors.orange
                            : Colors.red,
                      ),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildRecentActivity(List<UserAnswer> recentAnswers) {
    if (recentAnswers.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            'No recent activity yet. Start practicing!',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
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
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: answer.isCorrect
                      ? [Colors.green.shade50, Colors.green.shade100]
                      : [Colors.red.shade50, Colors.red.shade100],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: answer.isCorrect ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      answer.isCorrect ? Icons.check : Icons.close,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Question ${_shortId(answer.mcqId)}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          _formatDate(answer.answeredAt),
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${answer.timeSpentSeconds ?? 0}s',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              message,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.analytics_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'No progress data yet',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Start practicing to see your stats!',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/practice');
            },
            child: const Text('Start Practicing'),
          ),
        ],
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

  String _shortId(String id) {
    if (id.length <= 6) return id;
    return '${id.substring(0, 6)}...';
  }
}
