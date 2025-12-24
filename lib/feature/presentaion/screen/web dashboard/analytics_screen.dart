// import 'package:flutter/material.dart';
//
// import 'package:fl_chart/fl_chart.dart';
// import '../../../../init_dependence.dart';
// import '../../../data/data_source/local_data_source.dart';
// import '../../../domain/entity/entity.dart';
//
//
// class AnalyticsScreen extends StatefulWidget {
//   const AnalyticsScreen({super.key});
//
//   @override
//   State<AnalyticsScreen> createState() => _AnalyticsScreenState();
// }
//
// class _AnalyticsScreenState extends State<AnalyticsScreen> {
//   bool _isLoading = true;
//   List<MCQ> _allMCQs = [];
//   List<QuestionProgress> _allProgress = [];
//   List<UserAnswer> _allAnswers = [];
//   Map<String, MCQ> _mcqMap = {};
//
//   @override
//   void initState() {
//     super.initState();
//     _loadAnalytics();
//   }
//
//   Future<void> _loadAnalytics() async {
//     setState(() => _isLoading = true);
//     try {
//       final dataSource = sl<LocalDataSource>();
//       final mcqs = await dataSource.getAllMCQs();
//       final progress = await dataSource.getAllQuestionProgress();
//       final answers = await dataSource.getUserAnswers();
//
//       _mcqMap = {for (var mcq in mcqs) mcq.id: mcq};
//
//       setState(() {
//         _allMCQs = mcqs;
//         _allProgress = progress;
//         _allAnswers = answers;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() => _isLoading = false);
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error loading analytics: $e')),
//         );
//       }
//     }
//   }
//
//   List<_QuestionStats> _getMostAttemptedQuestions() {
//     return _allProgress
//         .map((p) => _QuestionStats(
//       mcq: _mcqMap[p.mcqId],
//       progress: p,
//     ))
//         .where((s) => s.mcq != null)
//         .toList()
//       ..sort((a, b) => b.progress.timesAttempted.compareTo(a.progress.timesAttempted))
//       ..take(10);
//   }
//
//   List<_QuestionStats> _getMostMissedQuestions() {
//     return _allProgress
//         .map((p) => _QuestionStats(
//       mcq: _mcqMap[p.mcqId],
//       progress: p,
//     ))
//         .where((s) => s.mcq != null && s.progress.timesIncorrect > 0)
//         .toList()
//       ..sort((a, b) => b.progress.timesIncorrect.compareTo(a.progress.timesIncorrect))
//       ..take(10);
//   }
//
//   Map<String, int> _getCategoryDistribution() {
//     Map<String, int> distribution = {};
//     for (var mcq in _allMCQs) {
//       distribution[mcq.category] = (distribution[mcq.category] ?? 0) + 1;
//     }
//     return distribution;
//   }
//
//   Map<int, int> _getDifficultyDistribution() {
//     Map<int, int> distribution = {};
//     for (var mcq in _allMCQs) {
//       distribution[mcq.difficultyLevel] = (distribution[mcq.difficultyLevel] ?? 0) + 1;
//     }
//     return distribution;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Analytics Dashboard'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: _loadAnalytics,
//           ),
//         ],
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildOverviewCards(),
//             const SizedBox(height: 24),
//             _buildChartsSection(),
//             const SizedBox(height: 24),
//             _buildMostAttemptedSection(),
//             const SizedBox(height: 24),
//             _buildMostMissedSection(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildOverviewCards() {
//     final totalAttempts = _allAnswers.length;
//     final correctAnswers = _allAnswers.where((a) => a.isCorrect).length;
//     final avgAccuracy = totalAttempts > 0 ? (correctAnswers / totalAttempts * 100) : 0;
//
//     return Wrap(
//       spacing: 16,
//       runSpacing: 16,
//       children: [
//         _buildStatCard(
//           'Total Questions',
//           _allMCQs.length.toString(),
//           Icons.quiz,
//           Colors.blue,
//         ),
//         _buildStatCard(
//           'Total Attempts',
//           totalAttempts.toString(),
//           Icons.play_arrow,
//           Colors.purple,
//         ),
//         _buildStatCard(
//           'Correct Answers',
//           correctAnswers.toString(),
//           Icons.check_circle,
//           Colors.green,
//         ),
//         _buildStatCard(
//           'Average Accuracy',
//           '${avgAccuracy.toStringAsFixed(1)}%',
//           Icons.analytics,
//           Colors.orange,
//         ),
//       ],
//     );
//   }
//
//   Widget _buildStatCard(String title, String value, IconData icon, Color color) {
//     return SizedBox(
//       width: 200,
//       child: Card(
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Icon(icon, color: color, size: 24),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: Text(
//                       title,
//                       style: TextStyle(
//                         color: Colors.grey[700],
//                         fontSize: 14,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 12),
//               Text(
//                 value,
//                 style: TextStyle(
//                   fontSize: 32,
//                   fontWeight: FontWeight.bold,
//                   color: color,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildChartsSection() {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Expanded(child: _buildCategoryChart()),
//         const SizedBox(width: 16),
//         Expanded(child: _buildDifficultyChart()),
//       ],
//     );
//   }
//
//   Widget _buildCategoryChart() {
//     final distribution = _getCategoryDistribution();
//     if (distribution.isEmpty) {
//       return const Card(child: Padding(padding: EdgeInsets.all(16), child: Text('No data')));
//     }
//
//     final colors = [Colors.blue, Colors.green, Colors.orange, Colors.purple, Colors.red];
//     int colorIndex = 0;
//
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Questions by Category',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             SizedBox(
//               height: 200,
//               child: PieChart(
//                 PieChartData(
//                   sections: distribution.entries.map((entry) {
//                     final color = colors[colorIndex % colors.length];
//                     colorIndex++;
//                     return PieChartSectionData(
//                       value: entry.value.toDouble(),
//                       title: '${entry.value}',
//                       color: color,
//                       radius: 100,
//                       titleStyle: const TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             ...distribution.entries.map((entry) {
//               final color = colors[(distribution.keys.toList().indexOf(entry.key)) % colors.length];
//               return Padding(
//                 padding: const EdgeInsets.only(bottom: 8),
//                 child: Row(
//                   children: [
//                     Container(
//                       width: 16,
//                       height: 16,
//                       color: color,
//                     ),
//                     const SizedBox(width: 8),
//                     Text('${entry.key}: ${entry.value}'),
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
//   Widget _buildDifficultyChart() {
//     final distribution = _getDifficultyDistribution();
//     if (distribution.isEmpty) {
//       return const Card(child: Padding(padding: EdgeInsets.all(16), child: Text('No data')));
//     }
//
//     final difficultyNames = {1: 'Easy', 2: 'Medium', 3: 'Hard'};
//     final colors = {1: Colors.green, 2: Colors.orange, 3: Colors.red};
//
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Questions by Difficulty',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             SizedBox(
//               height: 200,
//               child: BarChart(
//                 BarChartData(
//                   alignment: BarChartAlignment.spaceAround,
//                   maxY: distribution.values.reduce((a, b) => a > b ? a : b).toDouble() + 2,
//                   barGroups: distribution.entries.map((entry) {
//                     return BarChartGroupData(
//                       x: entry.key,
//                       barRods: [
//                         BarChartRodData(
//                           toY: entry.value.toDouble(),
//                           color: colors[entry.key] ?? Colors.grey,
//                           width: 40,
//                         ),
//                       ],
//                     );
//                   }).toList(),
//                   titlesData: FlTitlesData(
//                     leftTitles: AxisTitles(
//                       sideTitles: SideTitles(showTitles: true),
//                     ),
//                     bottomTitles: AxisTitles(
//                       sideTitles: SideTitles(
//                         showTitles: true,
//                         getTitlesWidget: (value, meta) {
//                           return Text(difficultyNames[value.toInt()] ?? '');
//                         },
//                       ),
//                     ),
//                     rightTitles: AxisTitles(
//                       sideTitles: SideTitles(showTitles: false),
//                     ),
//                     topTitles: AxisTitles(
//                       sideTitles: SideTitles(showTitles: false),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildMostAttemptedSection() {
//     final stats = _getMostAttemptedQuestions();
//
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Most Attempted Questions',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             if (stats.isEmpty)
//               const Text('No data available')
//             else
//               ...stats.map((stat) => _buildQuestionStatTile(stat)).toList(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildMostMissedSection() {
//     final stats = _getMostMissedQuestions();
//
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Most Missed Questions',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             if (stats.isEmpty)
//               const Text('No data available')
//             else
//               ...stats.map((stat) => _buildQuestionStatTile(stat, showIncorrect: true)).toList(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildQuestionStatTile(_QuestionStats stat, {bool showIncorrect = false}) {
//     final mcq = stat.mcq!;
//     final progress = stat.progress;
//     final accuracy = progress.timesAttempted > 0
//         ? (progress.timesCorrect / progress.timesAttempted * 100)
//         : 0;
//
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.grey[50],
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: Colors.grey[300]!),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   mcq.question,
//                   style: const TextStyle(fontWeight: FontWeight.w600),
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   'Category: ${mcq.category}',
//                   style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(width: 16),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               if (showIncorrect)
//                 Text(
//                   '${progress.timesIncorrect} incorrect',
//                   style: const TextStyle(
//                     color: Colors.red,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 )
//               else
//                 Text(
//                   '${progress.timesAttempted} attempts',
//                   style: const TextStyle(
//                     color: Colors.blue,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               const SizedBox(height: 4),
//               Text(
//                 'Accuracy: ${accuracy.toStringAsFixed(1)}%',
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: accuracy >= 70 ? Colors.green : Colors.orange,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _QuestionStats {
//   final MCQ? mcq;
//   final QuestionProgress progress;
//
//   _QuestionStats({required this.mcq, required this.progress});
// }
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final _supabase = Supabase.instance.client;

  Map<String, dynamic> _analyticsData = {};
  bool _isLoading = true;
  List<Map<String, dynamic>> _recentActivity = [];

  @override
  void initState() {
    super.initState();
    _fetchAnalytics();
  }

  Future<void> _fetchAnalytics() async {
    setState(() => _isLoading = true);

    try {
      final mcqs = await _supabase.from('mcqs').select();
      final answers = await _supabase.from('user_answers').select();
      final progress = await _supabase.from('question_progress').select();

      final categoryStats = await _calculateCategoryStatsManually();

      final recentAnswers = await _supabase
          .from('user_answers')
          .select()
          .order('answered_at', ascending: false)
          .limit(10);

      final totalCorrect =
          answers.where((a) => a['is_correct'] == true).length;

      final double accuracy =
      answers.isNotEmpty ? (totalCorrect / answers.length * 100) : 0.0;

      final categoryPerformance = <String, Map<String, dynamic>>{};
      for (var c in categoryStats) {
        categoryPerformance[c['category'] as String] = {
          'attempted': c['total_attempts'],
          'correct': c['correct_attempts'],
          'accuracy': (c['accuracy'] as num).toDouble(),
        };
      }

      final recentActivity = <Map<String, dynamic>>[];
      for (var a in recentAnswers) {
        recentActivity.add({
          'question': 'Question ${a['mcqId']}',
          'category': 'General',
          'is_correct': a['is_correct'],
          'time_spent': a['time_spent_seconds'],
          'answered_at': a['answered_at'],
        });
      }

      setState(() {
        _analyticsData = {
          'totalQuestions': mcqs.length,
          'totalAttempts': answers.length,
          'correctAnswers': totalCorrect,
          'accuracy': accuracy,
          'categoryPerformance': categoryPerformance,
        };
        _recentActivity = recentActivity;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Analytics error: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<List<Map<String, dynamic>>> _calculateCategoryStatsManually() async {
    try {
      final mcqs = await _supabase.from('mcqs').select();
      final progress = await _supabase.from('question_progress').select();

      final Map<String, Map<String, num>> map = {};

      for (var mcq in mcqs) {
        final category = mcq['category'] as String;
        final id = mcq['id'] as String;

        map.putIfAbsent(category, () => {'attempted': 0, 'correct': 0});

        final mcqProg = progress.firstWhere(
              (p) => p['mcqId'] == id,
          orElse: () => {},
        );

        if (mcqProg.isNotEmpty) {
          final attempts = (mcqProg['times_attempted'] as int?) ?? 0;
          final correct = (mcqProg['times_correct'] as int?) ?? 0;

          map[category]!['attempted'] =
              map[category]!['attempted']! + attempts;
          map[category]!['correct'] = map[category]!['correct']! + correct;
        }
      }

      return map.entries.map((e) {
        final attempted = e.value['attempted']!.toDouble();
        final correct = e.value['correct']!.toDouble();
        final accuracy = attempted > 0 ? (correct / attempted * 100) : 0.0;

        return {
          'category': e.key,
          'total_attempts': attempted.toInt(),
          'correct_attempts': correct.toInt(),
          'accuracy': accuracy,
        };
      }).toList();
    } catch (e) {
      debugPrint('Manual stats error: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLarge = MediaQuery.of(context).size.width > 768;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchAnalytics,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: EdgeInsets.all(isLarge ? 24 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryCards(isLarge),
            const SizedBox(height: 24),
            isLarge ? _buildChartsRow() : _buildChartsColumn(),
            const SizedBox(height: 24),
            _buildRecentActivity(),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards(bool large) {
    final double accuracy = (_analyticsData['accuracy'] as double);

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: large ? 4 : 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: large ? 1.8 : 1.5,
      children: [
        _card('Total Questions', '${_analyticsData['totalQuestions']}', Icons.list),
        _card('Total Attempts', '${_analyticsData['totalAttempts']}', Icons.timeline),
        _card('Correct Answers', '${_analyticsData['correctAnswers']}', Icons.check),
        _card('Accuracy', '${accuracy.toStringAsFixed(1)}%', Icons.trending_up),
      ],
    );
  }

  Widget _card(String title, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 30),
            const SizedBox(height: 10),
            Text(title),
            const SizedBox(height: 6),
            Text(value, style: const TextStyle(fontSize: 26,fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildChartsRow() => Row(
    children: [
      Expanded(child: _buildCategoryChart()),
    ],
  );

  Widget _buildChartsColumn() => _buildCategoryChart();

  Widget _buildCategoryChart() {
    final performance =
    _analyticsData['categoryPerformance'] as Map<String, dynamic>;

    if (performance.isEmpty) return const Text('No category data');

    final categories = performance.keys.toList();
    final attempts =
    categories.map((c) => performance[c]['attempted'] as int).toList();
    final maxAttempts = attempts.reduce(max).toDouble();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 300,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, i) {
              final cat = categories[i];
              final acc = (performance[cat]['accuracy'] as num).toDouble();
              final attempted = performance[cat]['attempted'] as int;

              final double barHeight =
              maxAttempts > 0 ? (attempted / maxAttempts * 200) : 0.0;

              return Container(
                width: 80,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('${acc.toStringAsFixed(0)}%'),
                    const SizedBox(height: 4),
                    Container(
                      height: barHeight,
                      width: 40,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 8),
                    Text(cat, textAlign: TextAlign.center),
                    Text('$attempted', style: const TextStyle(fontSize: 11)),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivity() {
    if (_recentActivity.isEmpty) return const Text('No recent activity');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Recent Activity',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ..._recentActivity.map((a) => ListTile(
          title: Text(a['question']),
          subtitle: Text(a['answered_at'].toString()),
          trailing: Icon(
            a['is_correct'] ? Icons.check : Icons.close,
            color: a['is_correct'] ? Colors.green : Colors.red,
          ),
        ))
      ],
    );
  }
}
