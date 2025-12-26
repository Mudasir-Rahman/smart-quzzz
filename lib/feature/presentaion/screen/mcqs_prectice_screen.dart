//
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
// class MCQPracticeScreen extends StatefulWidget {
//   const MCQPracticeScreen({super.key, required String userId});
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
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Colors.deepPurple.shade50,
//               Colors.white,
//             ],
//           ),
//         ),
//         child: SafeArea(
//           child: Column(
//             children: [
//               _buildHeader(context),
//               Expanded(
//                 child: BlocBuilder<MCQBloc, MCQState>(
//                   builder: (context, state) {
//                     if (state is MCQLoading) {
//                       return Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             CircularProgressIndicator(
//                               valueColor: AlwaysStoppedAnimation<Color>(
//                                 Colors.deepPurple,
//                               ),
//                             ),
//                             const SizedBox(height: 16),
//                             Text(
//                               'Loading questions...',
//                               style: TextStyle(
//                                 color: Colors.grey[600],
//                                 fontSize: 16,
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     }
//
//                     if (state is MCQError) {
//                       return Center(
//                         child: Padding(
//                           padding: const EdgeInsets.all(24),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Container(
//                                 padding: const EdgeInsets.all(20),
//                                 decoration: BoxDecoration(
//                                   color: Colors.red.shade50,
//                                   shape: BoxShape.circle,
//                                 ),
//                                 child: Icon(
//                                   Icons.error_outline,
//                                   size: 64,
//                                   color: Colors.red.shade400,
//                                 ),
//                               ),
//                               const SizedBox(height: 24),
//                               Text(
//                                 'Oops!',
//                                 style: TextStyle(
//                                   fontSize: 24,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.grey[800],
//                                 ),
//                               ),
//                               const SizedBox(height: 12),
//                               Text(
//                                 state.message,
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   color: Colors.grey[600],
//                                 ),
//                                 textAlign: TextAlign.center,
//                               ),
//                               const SizedBox(height: 24),
//                               ElevatedButton.icon(
//                                 onPressed: () {
//                                   context.read<MCQBloc>().add(LoadAllMCQsEvent());
//                                 },
//                                 icon: const Icon(Icons.refresh),
//                                 label: const Text('Try Again'),
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.deepPurple,
//                                   foregroundColor: Colors.white,
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 32,
//                                     vertical: 16,
//                                   ),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(30),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     }
//
//                     if (state is MCQsLoaded) {
//                       if (state.mcqs.isEmpty) {
//                         return Center(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Container(
//                                 padding: const EdgeInsets.all(24),
//                                 decoration: BoxDecoration(
//                                   color: Colors.purple.shade50,
//                                   shape: BoxShape.circle,
//                                 ),
//                                 child: Icon(
//                                   Icons.quiz,
//                                   size: 80,
//                                   color: Colors.deepPurple.shade300,
//                                 ),
//                               ),
//                               const SizedBox(height: 24),
//                               Text(
//                                 'No Questions Yet',
//                                 style: TextStyle(
//                                   fontSize: 24,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.grey[800],
//                                 ),
//                               ),
//                               const SizedBox(height: 12),
//                               Text(
//                                 'Add some questions to get started!',
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   color: Colors.grey[600],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         );
//                       }
//
//                       final total = state.mcqs.length;
//                       final completed = state.selectedAnswers.length;
//                       final progress = total > 0 ? completed / total : 0.0;
//
//                       return Column(
//                         children: [
//                           _buildProgressSection(completed, total, progress),
//                           Expanded(
//                             child: ListView.builder(
//                               padding: const EdgeInsets.all(16),
//                               itemCount: state.mcqs.length,
//                               itemBuilder: (context, index) {
//                                 final mcq = state.mcqs[index];
//                                 final selectedAnswer = state.selectedAnswers[mcq.id];
//                                 final showResult = state.showResults[mcq.id] ?? false;
//
//                                 if (!_startTimes.containsKey(mcq.id)) {
//                                   _startTimes[mcq.id] = DateTime.now();
//                                 }
//
//                                 return MCQCard(
//                                   mcq: mcq,
//                                   questionNumber: index + 1,
//                                   selectedAnswer: selectedAnswer,
//                                   showResult: showResult,
//                                   onAnswerSelected: (answerIndex) {
//                                     _onAnswerSelected(mcq, answerIndex);
//                                   },
//                                 );
//                               },
//                             ),
//                           ),
//                         ],
//                       );
//                     }
//
//                     return Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(
//                             Icons.psychology,
//                             size: 80,
//                             color: Colors.deepPurple.shade200,
//                           ),
//                           const SizedBox(height: 16),
//                           Text(
//                             'Ready to Practice?',
//                             style: TextStyle(
//                               fontSize: 20,
//                               color: Colors.grey[700],
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
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
//                 colors: [
//                   Colors.deepPurple.shade400,
//                   Colors.deepPurple.shade600,
//                 ],
//               ),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: const Icon(
//               Icons.quiz,
//               color: Colors.white,
//               size: 28,
//             ),
//           ),
//           const SizedBox(width: 16),
//           const Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Practice MCQs',
//                   style: TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 Text(
//                   'Test your knowledge',
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           IconButton(
//             icon: const Icon(Icons.refresh_rounded),
//             onPressed: () {
//               setState(() {
//                 _startTimes.clear();
//               });
//               context.read<MCQBloc>().add(LoadAllMCQsEvent());
//             },
//             style: IconButton.styleFrom(
//               backgroundColor: Colors.deepPurple.shade50,
//               foregroundColor: Colors.deepPurple,
//             ),
//           ),
//         ],
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
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 12,
//                   vertical: 6,
//                 ),
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
////////////////
////////////////



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
//   const MCQPracticeScreen({super.key, required String userId});
//
//   @override
//   State<MCQPracticeScreen> createState() => _MCQPracticeScreenState();
// }
//
// class _MCQPracticeScreenState extends State<MCQPracticeScreen> {
//   final Map<String, DateTime> _startTimes = {};
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
//     print('🔄 Loading MCQs for user: $_currentUserId');
//     context.read<MCQBloc>().add(LoadAllMCQsEvent());
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
//     context.read<MCQBloc>().add(SubmitAnswerEvent( answer: answer));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // Check if user is logged in
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
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
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
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Colors.deepPurple.shade50, Colors.white],
//           ),
//         ),
//         child: SafeArea(
//           child: Column(
//             children: [
//               _buildHeader(context),
//               Expanded(
//                 child: BlocBuilder<MCQBloc, MCQState>(
//                   builder: (context, state) {
//                     print('📊 MCQ State: ${state.runtimeType}');
//
//                     if (state is MCQLoading) {
//                       return Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             CircularProgressIndicator(
//                               valueColor: AlwaysStoppedAnimation<Color>(
//                                 Colors.deepPurple,
//                               ),
//                             ),
//                             const SizedBox(height: 16),
//                             Text(
//                               'Loading questions...',
//                               style: TextStyle(
//                                 color: Colors.grey[600],
//                                 fontSize: 16,
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     }
//
//                     if (state is MCQError) {
//                       return Center(
//                         child: Padding(
//                           padding: const EdgeInsets.all(24),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Container(
//                                 padding: const EdgeInsets.all(20),
//                                 decoration: BoxDecoration(
//                                   color: Colors.red.shade50,
//                                   shape: BoxShape.circle,
//                                 ),
//                                 child: Icon(
//                                   Icons.error_outline,
//                                   size: 64,
//                                   color: Colors.red.shade400,
//                                 ),
//                               ),
//                               const SizedBox(height: 24),
//                               Text(
//                                 'Oops!',
//                                 style: TextStyle(
//                                   fontSize: 24,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.grey[800],
//                                 ),
//                               ),
//                               const SizedBox(height: 12),
//                               Text(
//                                 state.message,
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   color: Colors.grey[600],
//                                 ),
//                                 textAlign: TextAlign.center,
//                               ),
//                               const SizedBox(height: 24),
//                               ElevatedButton.icon(
//                                 onPressed: _loadMCQs,
//                                 icon: const Icon(Icons.refresh),
//                                 label: const Text('Try Again'),
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.deepPurple,
//                                   foregroundColor: Colors.white,
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 32,
//                                     vertical: 16,
//                                   ),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(30),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     }
//
//                     if (state is MCQsLoaded) {
//                       print('✅ MCQs loaded: ${state.mcqs.length} questions');
//
//                       if (state.mcqs.isEmpty) {
//                         return Center(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Container(
//                                 padding: const EdgeInsets.all(24),
//                                 decoration: BoxDecoration(
//                                   color: Colors.purple.shade50,
//                                   shape: BoxShape.circle,
//                                 ),
//                                 child: Icon(
//                                   Icons.quiz,
//                                   size: 80,
//                                   color: Colors.deepPurple.shade300,
//                                 ),
//                               ),
//                               const SizedBox(height: 24),
//                               Text(
//                                 'No Questions Yet',
//                                 style: TextStyle(
//                                   fontSize: 24,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.grey[800],
//                                 ),
//                               ),
//                               const SizedBox(height: 12),
//                               Text(
//                                 'Add some questions to get started!',
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   color: Colors.grey[600],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         );
//                       }
//
//                       final total = state.mcqs.length;
//                       final completed = state.selectedAnswers.length;
//                       final progress = total > 0 ? completed / total : 0.0;
//
//                       return Column(
//                         children: [
//                           _buildProgressSection(completed, total, progress),
//                           Expanded(
//                             child: ListView.builder(
//                               padding: const EdgeInsets.all(16),
//                               itemCount: state.mcqs.length,
//                               itemBuilder: (context, index) {
//                                 final mcq = state.mcqs[index];
//                                 final selectedAnswer = state.selectedAnswers[mcq.id];
//                                 final showResult = state.showResults[mcq.id] ?? false;
//
//                                 if (!_startTimes.containsKey(mcq.id)) {
//                                   _startTimes[mcq.id] = DateTime.now();
//                                 }
//
//                                 return MCQCard(
//                                   mcq: mcq,
//                                   questionNumber: index + 1,
//                                   selectedAnswer: selectedAnswer,
//                                   showResult: showResult,
//                                   onAnswerSelected: (answerIndex) {
//                                     _onAnswerSelected(mcq, answerIndex);
//                                   },
//                                 );
//                               },
//                             ),
//                           ),
//                         ],
//                       );
//                     }
//
//                     return Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(
//                             Icons.psychology,
//                             size: 80,
//                             color: Colors.deepPurple.shade200,
//                           ),
//                           const SizedBox(height: 16),
//                           Text(
//                             'Ready to Practice?',
//                             style: TextStyle(
//                               fontSize: 20,
//                               color: Colors.grey[700],
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
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
//                 colors: [
//                   Colors.deepPurple.shade400,
//                   Colors.deepPurple.shade600,
//                 ],
//               ),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: const Icon(
//               Icons.quiz,
//               color: Colors.white,
//               size: 28,
//             ),
//           ),
//           const SizedBox(width: 16),
//           const Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Practice MCQs',
//                   style: TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 Text(
//                   'Test your knowledge',
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           IconButton(
//             icon: const Icon(Icons.refresh_rounded),
//             onPressed: () {
//               setState(() {
//                 _startTimes.clear();
//               });
//               _loadMCQs();
//             },
//             style: IconButton.styleFrom(
//               backgroundColor: Colors.deepPurple.shade50,
//               foregroundColor: Colors.deepPurple,
//             ),
//           ),
//         ],
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
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 12,
//                   vertical: 6,
//                 ),
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
//   const MCQPracticeScreen({super.key, required String userId});
//
//   @override
//   State<MCQPracticeScreen> createState() => _MCQPracticeScreenState();
// }
//
// class _MCQPracticeScreenState extends State<MCQPracticeScreen> {
//   final Map<String, DateTime> _startTimes = {};
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
//     print('🔄 Loading MCQs for user: $_currentUserId');
//     context.read<MCQBloc>().add(LoadAllMCQsEvent());
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
//     // Check if user is logged in
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
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
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
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Colors.deepPurple.shade50, Colors.white],
//           ),
//         ),
//         child: SafeArea(
//           child: Column(
//             children: [
//               _buildHeader(context),
//               Expanded(
//                 child: BlocBuilder<MCQBloc, MCQState>(
//                   builder: (context, state) {
//                     if (state is MCQLoading) {
//                       return Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             CircularProgressIndicator(
//                               valueColor: AlwaysStoppedAnimation<Color>(
//                                 Colors.deepPurple,
//                               ),
//                             ),
//                             const SizedBox(height: 16),
//                             Text(
//                               'Loading questions...',
//                               style: TextStyle(
//                                 color: Colors.grey[600],
//                                 fontSize: 16,
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     }
//
//                     if (state is MCQError) {
//                       return Center(
//                         child: Padding(
//                           padding: const EdgeInsets.all(24),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Container(
//                                 padding: const EdgeInsets.all(20),
//                                 decoration: BoxDecoration(
//                                   color: Colors.red.shade50,
//                                   shape: BoxShape.circle,
//                                 ),
//                                 child: Icon(
//                                   Icons.error_outline,
//                                   size: 64,
//                                   color: Colors.red.shade400,
//                                 ),
//                               ),
//                               const SizedBox(height: 24),
//                               Text(
//                                 'Oops!',
//                                 style: TextStyle(
//                                   fontSize: 24,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.grey[800],
//                                 ),
//                               ),
//                               const SizedBox(height: 12),
//                               Text(
//                                 state.message,
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   color: Colors.grey[600],
//                                 ),
//                                 textAlign: TextAlign.center,
//                               ),
//                               const SizedBox(height: 24),
//                               ElevatedButton.icon(
//                                 onPressed: _loadMCQs,
//                                 icon: const Icon(Icons.refresh),
//                                 label: const Text('Try Again'),
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.deepPurple,
//                                   foregroundColor: Colors.white,
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 32,
//                                     vertical: 16,
//                                   ),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(30),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     }
//
//                     if (state is MCQsLoaded) {
//                       if (state.mcqs.isEmpty) {
//                         return Center(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Container(
//                                 padding: const EdgeInsets.all(24),
//                                 decoration: BoxDecoration(
//                                   color: Colors.purple.shade50,
//                                   shape: BoxShape.circle,
//                                 ),
//                                 child: Icon(
//                                   Icons.quiz,
//                                   size: 80,
//                                   color: Colors.deepPurple.shade300,
//                                 ),
//                               ),
//                               const SizedBox(height: 24),
//                               Text(
//                                 'No Questions Yet',
//                                 style: TextStyle(
//                                   fontSize: 24,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.grey[800],
//                                 ),
//                               ),
//                               const SizedBox(height: 12),
//                               Text(
//                                 'Add some questions to get started!',
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   color: Colors.grey[600],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         );
//                       }
//
//                       final total = state.mcqs.length;
//                       final completed = state.selectedAnswers.length;
//                       final progress = total > 0 ? completed / total : 0.0;
//
//                       return Column(
//                         children: [
//                           _buildProgressSection(completed, total, progress),
//                           Expanded(
//                             child: ListView.builder(
//                               padding: const EdgeInsets.all(16),
//                               itemCount: state.mcqs.length,
//                               itemBuilder: (context, index) {
//                                 final mcq = state.mcqs[index];
//                                 final selectedAnswer = state.selectedAnswers[mcq.id];
//                                 final showResult = state.showResults[mcq.id] ?? false;
//
//                                 if (!_startTimes.containsKey(mcq.id)) {
//                                   _startTimes[mcq.id] = DateTime.now();
//                                 }
//
//                                 return MCQCard(
//                                   mcq: mcq,
//                                   questionNumber: index + 1,
//                                   selectedAnswer: selectedAnswer,
//                                   showResult: showResult,
//                                   onAnswerSelected: (answerIndex) {
//                                     _onAnswerSelected(mcq, answerIndex);
//                                   },
//                                 );
//                               },
//                             ),
//                           ),
//                         ],
//                       );
//                     }
//
//                     return Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(
//                             Icons.psychology,
//                             size: 80,
//                             color: Colors.deepPurple.shade200,
//                           ),
//                           const SizedBox(height: 16),
//                           Text(
//                             'Ready to Practice?',
//                             style: TextStyle(
//                               fontSize: 20,
//                               color: Colors.grey[700],
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
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
//         gradient: LinearGradient(
//           colors: [
//             Colors.deepPurple.shade400,
//             Colors.deepPurple.shade600,
//           ],
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.2),
//             blurRadius: 10,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: Colors.white.withOpacity(0.2),
//             ),
//             child: const Icon(
//               Icons.quiz,
//               color: Colors.white,
//               size: 28,
//             ),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Hello, $_userName!',
//                   style: const TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 const Text(
//                   'Ready to test your knowledge?',
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.white70,
//                   ),
//                 ),
//                 const SizedBox(height: 2),
//                 const Text(
//                   'Practice MCQs',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.white,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           IconButton(
//             icon: const Icon(Icons.refresh_rounded),
//             onPressed: () {
//               setState(() {
//                 _startTimes.clear();
//               });
//               _loadMCQs();
//             },
//             style: IconButton.styleFrom(
//               backgroundColor: Colors.white.withOpacity(0.2),
//               foregroundColor: Colors.white,
//             ),
//           ),
//         ],
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
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 12,
//                   vertical: 6,
//                 ),
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

import '../../auth/presentaion/bloc/auth_bloc.dart';
import '../../auth/presentaion/bloc/auth_event.dart';
import '../../auth/presentaion/bloc/auth_state.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Get current user safely
  String? get _currentUserId {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      return user?.id;
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }

  String get _userName {
    final user = Supabase.instance.client.auth.currentUser;
    if (user?.email != null) {
      final email = user!.email!;
      return email.contains('@') ? email.split('@')[0] : email;
    }
    return 'User';
  }

  String get _userInitial {
    final name = _userName;
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }

  @override
  void initState() {
    super.initState();
    _loadMCQs();
  }

  void _loadMCQs() {
    if (_currentUserId == null) {
      print('❌ No user logged in');
      return;
    }
    print('🔄 Loading MCQs for user: $_currentUserId');
    context.read<MCQBloc>().add(LoadAllMCQsEvent());
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

  void _handleLogout() async {
    print('🚪 MCQPracticeScreen: Logout requested');

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () {
              print('❌ Logout cancelled');
              Navigator.pop(context, false);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              print('✅ Logout confirmed');
              Navigator.pop(context, true);
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      print('🚪 Calling AuthBloc SignOutEvent');

      // Close the drawer first
      if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
        Navigator.pop(context);
      }

      try {
        // Access the AuthBloc from context
        final authBloc = context.read<AuthBloc>();
        print('✅ AuthBloc accessed successfully');

        // Dispatch the SignOutEvent
        authBloc.add(SignOutEvent());
        print('✅ SignOutEvent dispatched successfully');

        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Logging out...'),
            backgroundColor: Colors.blue,
            duration: Duration(seconds: 2),
          ),
        );

      } catch (e, stackTrace) {
        print('❌ Error accessing AuthBloc: $e');
        print('Stack trace: $stackTrace');

        // Fallback: try to sign out directly with Supabase
        try {
          print('🔄 Attempting direct Supabase logout...');
          await Supabase.instance.client.auth.signOut();
          print('✅ Direct Supabase logout successful');

          // Navigate to login screen
          Navigator.of(context).pushReplacementNamed('/signin');

        } catch (supabaseError) {
          print('❌ Direct Supabase logout failed: $supabaseError');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Logout failed. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Widget _buildDrawer() {
    final user = Supabase.instance.client.auth.currentUser;
    final userName = user?.email?.split('@').first ?? 'User';
    final userInitial = userName.isNotEmpty ? userName[0].toUpperCase() : 'U';

    // Screen navigation items
    final List<Map<String, dynamic>> screenItems = [
      {'icon': Icons.quiz, 'label': 'Practice', 'route': 'practice'},
      {'icon': Icons.repeat, 'label': 'Review', 'route': 'review'},
      {'icon': Icons.analytics, 'label': 'Progress', 'route': 'progress'},
      {'icon': Icons.dashboard, 'label': 'Manage', 'route': 'dashboard'},
      {'icon': Icons.bar_chart, 'label': 'Analytics', 'route': 'analytics'},
    ];

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              userName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            accountEmail: Text(
              user?.email ?? '',
              style: const TextStyle(color: Colors.white70),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                userInitial,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.deepPurple.shade400,
                  Colors.deepPurple.shade600,
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 16, top: 16, bottom: 8),
                  child: Text(
                    'Screens',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
                ...screenItems.map((item) {
                  return ListTile(
                    leading: Icon(item['icon'] as IconData, color: Colors.deepPurple),
                    title: Text(item['label'] as String),
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to different screens - you'll need to implement this
                      // For now, just show a snackbar
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Navigate to ${item['label']}')),
                      );
                    },
                  );
                }).toList(),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.help, color: Colors.deepPurple),
                  title: const Text('Help'),
                  onTap: () {
                    Navigator.pop(context);
                    // Add help functionality here
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Help')),
                    );
                  },
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: _handleLogout,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Listen for auth state changes
    return BlocListener<AuthBloc, AuthBlocState>(
      listener: (context, state) {
        print('🔔 MCQPracticeScreen listener - State: ${state.runtimeType}');

        if (state is AuthLoggedOut) {
          print('✅ User logged out, navigating to signin');
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacementNamed('/signin');
          });
        }

        if (state is AuthFailure) {
          print('🔴 Auth failure: ${state.message}');
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Logout error: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: _buildMainContent(context),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    if (_currentUserId == null) {
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
                  'Please Login',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const Text(
                  'You need to be logged in to practice',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(),
      body: Container(
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
              // Custom AppBar with menu button
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
                    // Menu Button
                    IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white),
                      onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.2),
                      ),
                      child: const Icon(
                        Icons.quiz,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello, $_userName!',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Ready to test your knowledge?',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Practice MCQs',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // User Avatar
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Text(
                        _userInitial,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: BlocBuilder<MCQBloc, MCQState>(
                  builder: (context, state) {
                    if (state is MCQLoading) {
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

                    if (state is MCQError) {
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
                                state.message,
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

                    if (state is MCQsLoaded) {
                      if (state.mcqs.isEmpty) {
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
                                'No Questions Yet',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Add some questions to get started!',
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
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
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
        )
    );
  }
}