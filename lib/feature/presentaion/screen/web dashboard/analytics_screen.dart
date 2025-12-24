
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
          .order('answeredat', ascending: false) // lowercase
          .limit(10);

      final totalCorrect = answers.where((a) => a['iscorrect'] == 1).length; // lowercase

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
          'question': 'Question ${a['mcqid']}', // lowercase
          'category': 'General',
          'is_correct': (a['iscorrect'] ?? 0) == 1, // lowercase
          'time_spent': a['timespentseconds'] ?? 0, // lowercase
          'answered_at': a['answeredat'] ?? '', // lowercase
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
              (p) => p['mcqid'] == id, // lowercase
          orElse: () => {},
        );

        if (mcqProg.isNotEmpty) {
          final attempts = (mcqProg['timesattempted'] as int?) ?? 0; // lowercase
          final correct = (mcqProg['timescorrect'] as int?) ?? 0; // lowercase

          map[category]!['attempted'] = map[category]!['attempted']! + attempts;
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
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: large ? 4 : 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: large ? 1.5 : 1.2, // Reduced aspect ratio
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return _buildStatCard(index);
      },
    );
  }

  Widget _buildStatCard(int index) {
    final double accuracy = (_analyticsData['accuracy'] as double? ?? 0.0);

    final Map<int, Map<String, dynamic>> cards = {
      0: {
        'title': 'Total Questions',
        'value': '${_analyticsData['totalQuestions'] ?? 0}',
        'icon': Icons.list,
        'color': Colors.blue,
      },
      1: {
        'title': 'Total Attempts',
        'value': '${_analyticsData['totalAttempts'] ?? 0}',
        'icon': Icons.timeline,
        'color': Colors.purple,
      },
      2: {
        'title': 'Correct Answers',
        'value': '${_analyticsData['correctAnswers'] ?? 0}',
        'icon': Icons.check,
        'color': Colors.green,
      },
      3: {
        'title': 'Accuracy',
        'value': '${accuracy.toStringAsFixed(1)}%',
        'icon': Icons.trending_up,
        'color': Colors.orange,
      },
    };

    final card = cards[index]!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12), // Reduced padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(card['icon'] as IconData, size: 24, color: card['color'] as Color),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    card['title'] as String,
                    style: const TextStyle(fontSize: 12), // Smaller font
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              card['value'] as String,
              style: TextStyle(
                fontSize: 20, // Smaller font
                fontWeight: FontWeight.bold,
                color: card['color'] as Color,
              ),
            ),
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
    final performance = _analyticsData['categoryPerformance'] as Map<String, dynamic>? ?? {};

    if (performance.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(child: Text('No category data available')),
        ),
      );
    }

    final categories = performance.keys.toList();
    final attempts =
    categories.map((c) => performance[c]['attempted'] as int? ?? 0).toList();
    final maxAttempts = attempts.isNotEmpty ? attempts.reduce(max).toDouble() : 0.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Performance by Category',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, i) {
                  final cat = categories[i];
                  final acc = (performance[cat]['accuracy'] as num?)?.toDouble() ?? 0.0;
                  final attempted = performance[cat]['attempted'] as int? ?? 0;

                  final double barHeight =
                  maxAttempts > 0 ? (attempted / maxAttempts * 200) : 0.0;

                  return Container(
                    width: 80,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${acc.toStringAsFixed(0)}%',
                          style: TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          height: barHeight,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          cat,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 11),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '$attempted',
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            ...categories.map((cat) {
              final acc = (performance[cat]['accuracy'] as num?)?.toDouble() ?? 0.0;
              final attempted = performance[cat]['attempted'] as int? ?? 0;
              final correct = performance[cat]['correct'] as int? ?? 0;

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        cat,
                        style: TextStyle(fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '$attempted attempts',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '($correct correct)',
                      style: TextStyle(fontSize: 12, color: Colors.green),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${acc.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: acc >= 70 ? Colors.green : Colors.orange,
                      ),
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

  Widget _buildRecentActivity() {
    if (_recentActivity.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(child: Text('No recent activity')),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Activity',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: min(_recentActivity.length * 70.0, 350), // Limit height
              child: ListView.builder(
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: _recentActivity.length,
                itemBuilder: (context, index) {
                  final a = _recentActivity[index];
                  final isCorrect = a['is_correct'] == true;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isCorrect ? Icons.check_circle : Icons.cancel,
                          color: isCorrect ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                a['question']?.toString() ?? 'Unknown Question',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Time spent: ${a['time_spent']}s',
                                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          _formatDate(a['answered_at']),
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(dynamic date) {
    if (date == null) return 'Just now';
    try {
      final dateTime = DateTime.parse(date.toString());
      return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'Recently';
    }
  }
}