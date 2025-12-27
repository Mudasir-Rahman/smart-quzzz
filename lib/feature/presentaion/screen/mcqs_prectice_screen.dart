//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:uuid/uuid.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
//
// import '../../domain/entity/entity.dart';
// import '../bloc/mcqs_bloc.dart';
// import '../bloc/mcqs_event.dart';
// import '../bloc/mcqs_state.dart';
// import '../widget/mcqs_cards.dart';
//
// class MCQPracticeScreen extends StatefulWidget {
//   final String userId;
//   const MCQPracticeScreen({super.key, required this.userId});
//
//   @override
//   State<MCQPracticeScreen> createState() => _MCQPracticeScreenState();
// }
//
// class _MCQPracticeScreenState extends State<MCQPracticeScreen> {
//   final Map<String, DateTime> _startTimes = {};
//   bool _hasLoadedMCQs = false; // Add this flag
//
//   // Get current user safely
//   String? get _currentUserId {
//     try {
//       final user = Supabase.instance.client.auth.currentUser;
//       return user?.id;
//     } catch (e) {
//       print('Error getting current user: $e');
//       return null;
//     }
//   }
//
//   String get _userName {
//     final user = Supabase.instance.client.auth.currentUser;
//     if (user?.email != null) {
//       final email = user!.email!;
//       return email.contains('@') ? email.split('@')[0] : email;
//     }
//     return 'User';
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _loadMCQs();
//   }
//
//   void _loadMCQs() {
//     if (_currentUserId == null) {
//       print('❌ No user logged in');
//       return;
//     }
//
//     // Prevent duplicate loading
//     if (_hasLoadedMCQs) {
//       print('⚠️ MCQs already loaded, skipping duplicate load');
//       return;
//     }
//
//     print('🔄 Loading MCQs for user: $_currentUserId');
//     context.read<MCQBloc>().add(LoadAllMCQsEvent());
//     _hasLoadedMCQs = true; // Set flag to true
//   }
//
//   void _onAnswerSelected(MCQ mcq, int selectedIndex) {
//     if (_currentUserId == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please login to submit answers')),
//       );
//       return;
//     }
//
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
//     context.read<MCQBloc>().add(SubmitAnswerEvent(answer: answer));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (_currentUserId == null) {
//       return Scaffold(
//         body: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [Colors.deepPurple.shade50, Colors.white],
//             ),
//           ),
//           child: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   Icons.login,
//                   size: 80,
//                   color: Colors.deepPurple.shade300,
//                 ),
//                 const SizedBox(height: 24),
//                 const Text(
//                   'Please Login',
//                   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 12),
//                 const Text(
//                   'You need to be logged in to practice',
//                   style: TextStyle(fontSize: 16, color: Colors.grey),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     }
//
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [Colors.deepPurple.shade50, Colors.white],
//         ),
//       ),
//       child: SafeArea(
//         child: Column(
//           children: [
//             // Practice Screen Header (without menu button or profile icon)
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     Colors.deepPurple.shade400,
//                     Colors.deepPurple.shade600,
//                   ],
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.2),
//                     blurRadius: 10,
//                     offset: const Offset(0, 3),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Colors.white.withOpacity(0.2),
//                     ),
//                     child: const Icon(
//                       Icons.quiz,
//                       color: Colors.white,
//                       size: 28,
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Welcome, $_userName!',
//                           style: const TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         const Text(
//                           'Practice MCQs',
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.white,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         const SizedBox(height: 2),
//                         const Text(
//                           'Test your knowledge and improve',
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: Colors.white70,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: BlocBuilder<MCQBloc, MCQState>(
//                 builder: (context, state) {
//                   if (state is MCQLoading) {
//                     return Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           CircularProgressIndicator(
//                             valueColor: AlwaysStoppedAnimation<Color>(
//                               Colors.deepPurple,
//                             ),
//                           ),
//                           const SizedBox(height: 16),
//                           Text(
//                             'Loading questions...',
//                             style: TextStyle(
//                               color: Colors.grey[600],
//                               fontSize: 16,
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   }
//
//                   if (state is MCQError) {
//                     return Center(
//                       child: Padding(
//                         padding: const EdgeInsets.all(24),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Container(
//                               padding: const EdgeInsets.all(20),
//                               decoration: BoxDecoration(
//                                 color: Colors.red.shade50,
//                                 shape: BoxShape.circle,
//                               ),
//                               child: Icon(
//                                 Icons.error_outline,
//                                 size: 64,
//                                 color: Colors.red.shade400,
//                               ),
//                             ),
//                             const SizedBox(height: 24),
//                             Text(
//                               'Oops!',
//                               style: TextStyle(
//                                 fontSize: 24,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.grey[800],
//                               ),
//                             ),
//                             const SizedBox(height: 12),
//                             Text(
//                               state.message,
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 color: Colors.grey[600],
//                               ),
//                               textAlign: TextAlign.center,
//                             ),
//                             const SizedBox(height: 24),
//                             ElevatedButton.icon(
//                               onPressed: _loadMCQs,
//                               icon: const Icon(Icons.refresh),
//                               label: const Text('Try Again'),
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.deepPurple,
//                                 foregroundColor: Colors.white,
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 32,
//                                   vertical: 16,
//                                 ),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(30),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   }
//
//                   if (state is MCQsLoaded) {
//                     if (state.mcqs.isEmpty) {
//                       return Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Container(
//                               padding: const EdgeInsets.all(24),
//                               decoration: BoxDecoration(
//                                 color: Colors.purple.shade50,
//                                 shape: BoxShape.circle,
//                               ),
//                               child: Icon(
//                                 Icons.quiz,
//                                 size: 80,
//                                 color: Colors.deepPurple.shade300,
//                               ),
//                             ),
//                             const SizedBox(height: 24),
//                             Text(
//                               'No Questions Yet',
//                               style: TextStyle(
//                                 fontSize: 24,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.grey[800],
//                               ),
//                             ),
//                             const SizedBox(height: 12),
//                             Text(
//                               'Add some questions to get started!',
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 color: Colors.grey[600],
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     }
//
//                     final total = state.mcqs.length;
//                     final completed = state.selectedAnswers.length;
//                     final progress = total > 0 ? completed / total : 0.0;
//
//                     return Column(
//                       children: [
//                         _buildProgressSection(completed, total, progress),
//                         Expanded(
//                           child: ListView.builder(
//                             padding: const EdgeInsets.all(16),
//                             itemCount: state.mcqs.length,
//                             itemBuilder: (context, index) {
//                               final mcq = state.mcqs[index];
//                               final selectedAnswer = state.selectedAnswers[mcq.id];
//                               final showResult = state.showResults[mcq.id] ?? false;
//
//                               if (!_startTimes.containsKey(mcq.id)) {
//                                 _startTimes[mcq.id] = DateTime.now();
//                               }
//
//                               return MCQCard(
//                                 mcq: mcq,
//                                 questionNumber: index + 1,
//                                 selectedAnswer: selectedAnswer,
//                                 showResult: showResult,
//                                 onAnswerSelected: (answerIndex) {
//                                   _onAnswerSelected(mcq, answerIndex);
//                                 },
//                               );
//                             },
//                           ),
//                         ),
//                       ],
//                     );
//                   }
//
//                   return Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Icons.psychology,
//                           size: 80,
//                           color: Colors.deepPurple.shade200,
//                         ),
//                         const SizedBox(height: 16),
//                         Text(
//                           'Ready to Practice?',
//                           style: TextStyle(
//                             fontSize: 20,
//                             color: Colors.grey[700],
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildProgressSection(int completed, int total, double progress) {
//     return Container(
//       margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             Colors.deepPurple.shade400,
//             Colors.deepPurple.shade600,
//           ],
//         ),
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.deepPurple.withOpacity(0.3),
//             blurRadius: 12,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text(
//                 'Your Progress',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Text(
//                   '$completed / $total',
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           ClipRRect(
//             borderRadius: BorderRadius.circular(10),
//             child: LinearProgressIndicator(
//               value: progress,
//               backgroundColor: Colors.white.withOpacity(0.3),
//               valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
//               minHeight: 10,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             '${(progress * 100).toStringAsFixed(0)}% Complete',
//             style: TextStyle(
//               color: Colors.white.withOpacity(0.9),
//               fontSize: 14,
//             ),
//           ),
//         ],
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

class MCQPracticeScreen extends StatefulWidget {
  final String userId;
  const MCQPracticeScreen({super.key, required this.userId});

  @override
  State<MCQPracticeScreen> createState() => _MCQPracticeScreenState();
}

class _MCQPracticeScreenState extends State<MCQPracticeScreen> {
  final Map<String, DateTime> _startTimes = {};
  bool _hasLoadedMCQs = false;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    print('📱 MCQPracticeScreen: initState for user: ${widget.userId}');

    // Delay loading to ensure context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_initialized) {
        _initialized = true;
        _loadMCQs();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('📱 MCQPracticeScreen: didChangeDependencies');

    // Load MCQs if not already loaded
    if (!_hasLoadedMCQs && widget.userId.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadMCQs();
      });
    }
  }

  void _loadMCQs() {
    // Prevent duplicate loading
    if (_hasLoadedMCQs) {
      print('⚠️ MCQPracticeScreen: MCQs already loaded, skipping');
      return;
    }

    if (widget.userId.isEmpty) {
      print('❌ MCQPracticeScreen: Invalid user ID');
      return;
    }

    print('🔄 MCQPracticeScreen: Loading MCQs for user: ${widget.userId}');

    try {
      context.read<MCQBloc>().add(LoadAllMCQsEvent());
      _hasLoadedMCQs = true;
      print('✅ MCQPracticeScreen: LoadAllMCQsEvent dispatched');
    } catch (e) {
      print('❌ MCQPracticeScreen: Error loading MCQs: $e');
    }
  }

  String get _userName {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user?.email != null) {
        final email = user!.email!;
        return email.contains('@') ? email.split('@')[0] : email;
      }
    } catch (e) {
      print('❌ Error getting user name: $e');
    }
    return 'User';
  }

  void _onAnswerSelected(MCQ mcq, int selectedIndex) {
    if (widget.userId.isEmpty) {
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

    print('📝 MCQPracticeScreen: Submitting answer for MCQ ${mcq.id}');
    context.read<MCQBloc>().add(SubmitAnswerEvent(answer: answer));
  }

  @override
  Widget build(BuildContext context) {
    print('📱 MCQPracticeScreen: Building with userId: ${widget.userId}');

    if (widget.userId.isEmpty) {
      return _buildLoginRequiredScreen();
    }

    return _buildPracticeScreen();
  }

  Widget _buildLoginRequiredScreen() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple.shade50, Colors.white],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.login,
                  size: 80,
                  color: Colors.deepPurple.shade300,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Authentication Required',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const Text(
                  'You need to be logged in to practice MCQs',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Add navigation to login
                  },
                  icon: const Icon(Icons.login),
                  label: const Text('Go to Login'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPracticeScreen() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.deepPurple.shade50, Colors.white],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.deepPurple.shade400,
                    Colors.deepPurple.shade600,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.2),
                    ),
                    child: const Icon(
                      Icons.quiz,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome, $_userName!',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Practice MCQs',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Test your knowledge and improve',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<MCQBloc, MCQState>(
                builder: (context, state) {
                  print('📱 MCQPracticeScreen: BlocBuilder state: ${state.runtimeType}');

                  if (state is MCQLoading) {
                    return _buildLoadingState();
                  }

                  if (state is MCQError) {
                    return _buildErrorState(state.message);
                  }

                  if (state is MCQsLoaded) {
                    return _buildLoadedState(state);
                  }

                  // Initial state
                  return _buildInitialState();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Colors.deepPurple,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading questions...',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red.shade400,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Oops!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadMCQs,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadedState(MCQsLoaded state) {
    if (state.mcqs.isEmpty) {
      return _buildEmptyState();
    }

    final total = state.mcqs.length;
    final completed = state.selectedAnswers.length;
    final progress = total > 0 ? completed / total : 0.0;

    return Column(
      children: [
        _buildProgressSection(completed, total, progress),
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.quiz,
              size: 80,
              color: Colors.deepPurple.shade300,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Questions Available',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Questions will appear here once added',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.psychology,
            size: 80,
            color: Colors.deepPurple.shade200,
          ),
          const SizedBox(height: 16),
          Text(
            'Ready to Practice?',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Loading questions...',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadMCQs,
            child: const Text('Load Questions'),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection(int completed, int total, double progress) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.deepPurple.shade400,
            Colors.deepPurple.shade600,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Your Progress',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$completed / $total',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 10,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${(progress * 100).toStringAsFixed(0)}% Complete',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}