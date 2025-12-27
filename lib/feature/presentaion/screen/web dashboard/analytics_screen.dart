import 'dart:math';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AnalyticsScreen extends StatefulWidget {
  final String userId;
  const AnalyticsScreen({super.key, required this.userId});

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
    debugPrint('📊 AnalyticsScreen: Initializing for user ${widget.userId}');
    _fetchAnalytics();
  }

  @override
  void didUpdateWidget(covariant AnalyticsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userId != widget.userId) {
      debugPrint('📊 AnalyticsScreen: User changed! Refetching data for ${widget.userId}');
      _fetchAnalytics();
    }
  }

  Future<void> _fetchAnalytics() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      debugPrint('📊 AnalyticsScreen: Fetching analytics for user ${widget.userId}');
      // Fetch data for the current user
      final answers = await _supabase
          .from('user_answers')
          .select()
          .eq('userId', widget.userId);

      final categoryStats = await _calculateCategoryStatsManually();

      final recentAnswers = await _supabase
          .from('user_answers')
          .select()
          .eq('userId', widget.userId)
          .order('answeredAt', ascending: false)
          .limit(10);

      // Total questions is global
      final mcqs = await _supabase.from('mcqs').select();

      // Calculate stats
      final totalCorrect = answers.where((a) => a['isCorrect'] == true).length;
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
          'is_correct': a['isCorrect'] == true,
          'time_spent': a['timeSpentSeconds'] ?? 0,
          'answered_at': a['answeredAt'] ?? '',
        });
      }

      if (mounted) {
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
      }
    } catch (e) {
      debugPrint('Analytics error: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<List<Map<String, dynamic>>> _calculateCategoryStatsManually() async {
    try {
      final mcqs = await _supabase.from('mcqs').select();
      final progress = await _supabase
          .from('question_progress')
          .select()
          .eq('userId', widget.userId);

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
          final attempts = (mcqProg['timesAttempted'] as int?) ?? 0;
          final correct = (mcqProg['timesCorrect'] as int?) ?? 0;

          map[category]!['attempted'] = (map[category]!['attempted'] ?? 0) + attempts;
          map[category]!['correct'] = (map[category]!['correct'] ?? 0) + correct;
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
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple.shade50, Colors.white],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildSummaryCards(),
                      const SizedBox(height: 20),
                      _buildCategoryPerformance(),
                      const SizedBox(height: 20),
                      _buildRecentActivity(),
                    ],
                  ),
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
                colors: [Colors.purple.shade400, Colors.purple.shade600],
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
                  'Analytics',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'Performance insights',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _fetchAnalytics,
            style: IconButton.styleFrom(
              backgroundColor: Colors.purple.shade50,
              foregroundColor: Colors.purple,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    final double accuracy = (_analyticsData['accuracy'] as double? ?? 0.0);

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.3,
      children: [
        _buildStatCard(
          'Total Questions',
          '${_analyticsData['totalQuestions'] ?? 0}',
          Icons.quiz,
          Colors.blue,
        ),
        _buildStatCard(
          'Total Attempts',
          '${_analyticsData['totalAttempts'] ?? 0}',
          Icons.play_arrow,
          Colors.purple,
        ),
        _buildStatCard(
          'Correct Answers',
          '${_analyticsData['correctAnswers'] ?? 0}',
          Icons.check_circle,
          Colors.green,
        ),
        _buildStatCard(
          'Accuracy',
          '${accuracy.toStringAsFixed(1)}%',
          Icons.trending_up,
          Colors.orange,
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryPerformance() {
    final performance =
        _analyticsData['categoryPerformance'] as Map<String, dynamic>? ?? {};

    if (performance.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.category, size: 48, color: Colors.grey[300]),
              const SizedBox(height: 12),
              Text(
                'No category data available',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.bar_chart, color: Colors.purple),
                SizedBox(width: 12),
                Text(
                  'Performance by Category',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ...performance.entries.map((entry) {
              final cat = entry.key;
              final data = entry.value as Map<String, dynamic>;
              final acc = (data['accuracy'] as num?)?.toDouble() ?? 0.0;
              final attempted = data['attempted'] as int? ?? 0;
              final correct = data['correct'] as int? ?? 0;

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _getCategoryColor(cat).withOpacity(0.1),
                      _getCategoryColor(cat).withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _getCategoryColor(cat).withOpacity(0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            cat,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: _getCategoryColor(cat),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _getAccuracyColor(acc),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${acc.toStringAsFixed(1)}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: acc / 100,
                        minHeight: 8,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _getAccuracyColor(acc),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildStatBadge(
                          Icons.play_arrow,
                          '$attempted',
                          'attempts',
                          Colors.blue,
                        ),
                        const SizedBox(width: 12),
                        _buildStatBadge(
                          Icons.check,
                          '$correct',
                          'correct',
                          Colors.green,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        )
    );
  }

  Widget _buildStatBadge(IconData icon, String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    if (_recentActivity.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.history, size: 48, color: Colors.grey[300]),
              const SizedBox(height: 12),
              Text(
                'No recent activity',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.history, color: Colors.purple),
                SizedBox(width: 12),
                Text(
                  'Recent Activity',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ..._recentActivity.take(5).map((a) {
              final isCorrect = a['is_correct'] == true;
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isCorrect
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
                        color: isCorrect ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        isCorrect ? Icons.check : Icons.close,
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
                            a['question']?.toString() ?? 'Unknown',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            '${a['time_spent']}s • ${_formatDate(a['answered_at'])}',
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        )
    );
  }

  Color _getCategoryColor(String category) {
    final colors = [
      Colors.blue,
      Colors.purple,
      Colors.orange,
      Colors.teal,
      Colors.pink,
    ];
    return colors[category.hashCode % colors.length];
  }

  Color _getAccuracyColor(double accuracy) {
    if (accuracy >= 80) return Colors.green;
    if (accuracy >= 60) return Colors.orange;
    return Colors.red;
  }

  String _formatDate(dynamic date) {
    if (date == null) return 'Just now';
    try {
      final dateTime = DateTime.parse(date.toString());
      final now = DateTime.now();
      final diff = now.difference(dateTime);
      if (diff.inDays > 0) return '${diff.inDays}d ago';
      if (diff.inHours > 0) return '${diff.inHours}h ago';
      if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
      return 'Just now';
    } catch (e) {
      return 'Recently';
    }
  }
}
