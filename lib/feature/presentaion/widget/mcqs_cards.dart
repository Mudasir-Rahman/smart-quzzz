// import 'package:flutter/material.dart';
//
// import '../../domain/entity/entity.dart';
//
//
// class MCQCard extends StatelessWidget {
//   final MCQ mcq;
//   final int questionNumber;
//   final int? selectedAnswer;
//   final bool showResult;
//   final Function(int) onAnswerSelected;
//
//   const MCQCard({
//     super.key,
//     required this.mcq,
//     required this.questionNumber,
//     this.selectedAnswer,
//     required this.showResult,
//     required this.onAnswerSelected,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 16),
//       elevation: 2,
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).primaryColor,
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Text(
//                     'Q$questionNumber',
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                     decoration: BoxDecoration(
//                       color: Colors.grey[200],
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Text(
//                       mcq.category,
//                       style: TextStyle(
//                         color: Colors.grey[800],
//                         fontSize: 12,
//                       ),
//                     ),
//                   ),
//                 ),
//                 _buildDifficultyIndicator(),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Text(
//               mcq.question,
//               style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const SizedBox(height: 16),
//             ...List.generate(
//               mcq.options.length,
//                   (index) => _buildOption(context, index),
//             ),
//             if (showResult && mcq.explanation != null) ...[
//               const SizedBox(height: 16),
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Colors.blue[50],
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: Colors.blue[200]!),
//                 ),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: Text(
//                         mcq.explanation!,
//                         style: TextStyle(
//                           color: Colors.blue[900],
//                           fontSize: 14,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildOption(BuildContext context, int index) {
//     final isSelected = selectedAnswer == index;
//     final isCorrect = index == mcq.correctAnswerIndex;
//
//     Color? backgroundColor;
//     Color? borderColor;
//     IconData? icon;
//
//     if (showResult) {
//       if (isCorrect) {
//         backgroundColor = Colors.green[50];
//         borderColor = Colors.green;
//         icon = Icons.check_circle;
//       } else if (isSelected) {
//         backgroundColor = Colors.red[50];
//         borderColor = Colors.red;
//         icon = Icons.cancel;
//       }
//     } else if (isSelected) {
//       backgroundColor = Colors.blue[50];
//       borderColor = Colors.blue;
//     }
//
//     return Container(
//       margin: const EdgeInsets.only(bottom: 8),
//       child: InkWell(
//         onTap: showResult ? null : () => onAnswerSelected(index),
//         borderRadius: BorderRadius.circular(8),
//         child: Container(
//           padding: const EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             color: backgroundColor,
//             borderRadius: BorderRadius.circular(8),
//             border: Border.all(
//               color: borderColor ?? Colors.grey[300]!,
//               width: 2,
//             ),
//           ),
//           child: Row(
//             children: [
//               Container(
//                 width: 24,
//                 height: 24,
//                 alignment: Alignment.center,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: borderColor?.withOpacity(0.2),
//                   border: Border.all(
//                     color: borderColor ?? Colors.grey[400]!,
//                     width: 2,
//                   ),
//                 ),
//                 child: Text(
//                   String.fromCharCode(65 + index),
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: borderColor ?? Colors.grey[700],
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Text(
//                   mcq.options[index],
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey[900],
//                   ),
//                 ),
//               ),
//               if (icon != null)
//                 Icon(
//                   icon,
//                   color: borderColor,
//                   size: 24,
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDifficultyIndicator() {
//     Color color;
//     String text;
//
//     switch (mcq.difficultyLevel) {
//       case 1:
//         color = Colors.green;
//         text = 'Easy';
//         break;
//       case 2:
//         color = Colors.orange;
//         text = 'Medium';
//         break;
//       case 3:
//         color = Colors.red;
//         text = 'Hard';
//         break;
//       default:
//         color = Colors.grey;
//         text = 'Unknown';
//     }
//
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(4),
//       ),
//       child: Text(
//         text,
//         style: TextStyle(
//           color: color,
//           fontSize: 12,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import '../../domain/entity/entity.dart';

class MCQCard extends StatelessWidget {
  final MCQ mcq;
  final int questionNumber;
  final int? selectedAnswer;
  final bool showResult;
  final Function(int) onAnswerSelected;

  const MCQCard({
    super.key,
    required this.mcq,
    required this.questionNumber,
    this.selectedAnswer,
    required this.showResult,
    required this.onAnswerSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      shadowColor: Colors.deepPurple.withOpacity(0.2),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Q# and Category + Difficulty
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Q$questionNumber',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      mcq.category,
                      style: TextStyle(color: Colors.grey[800], fontSize: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _buildDifficultyIndicator(),
              ],
            ),
            const SizedBox(height: 16),
            // Question
            Text(
              mcq.question,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            // Options
            Column(
              children: List.generate(mcq.options.length, (index) {
                final isSelected = selectedAnswer == index;
                final isCorrect = index == mcq.correctAnswerIndex;

                Color? bgColor;
                Color? borderColor;
                IconData? icon;

                if (showResult) {
                  if (isCorrect) {
                    bgColor = Colors.green[50];
                    borderColor = Colors.green;
                    icon = Icons.check_circle;
                  } else if (isSelected) {
                    bgColor = Colors.red[50];
                    borderColor = Colors.red;
                    icon = Icons.cancel;
                  } else {
                    bgColor = Colors.grey[100];
                    borderColor = Colors.grey[300];
                  }
                } else if (isSelected) {
                  bgColor = Colors.deepPurple.withOpacity(0.1);
                  borderColor = Colors.deepPurple;
                } else {
                  bgColor = Colors.grey[100];
                  borderColor = Colors.grey[300];
                }

                return GestureDetector(
                  onTap: showResult ? null : () => onAnswerSelected(index),
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor ?? Colors.grey[300]!, width: 2),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: borderColor?.withOpacity(0.2),
                            border: Border.all(color: borderColor ?? Colors.grey[400]!, width: 2),
                          ),
                          child: Text(
                            String.fromCharCode(65 + index),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: borderColor ?? Colors.grey[700]),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            mcq.options[index],
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[900],
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
                          ),
                        ),
                        if (icon != null) Icon(icon, color: borderColor, size: 22),
                      ],
                    ),
                  ),
                );
              }),
            ),
            // Explanation
            if (showResult && mcq.explanation != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        mcq.explanation!,
                        style: TextStyle(color: Colors.blue[900], fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyIndicator() {
    Color color;
    String text;

    switch (mcq.difficultyLevel) {
      case 1:
        color = Colors.green;
        text = 'Easy';
        break;
      case 2:
        color = Colors.orange;
        text = 'Medium';
        break;
      case 3:
        color = Colors.red;
        text = 'Hard';
        break;
      default:
        color = Colors.grey;
        text = 'Unknown';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}
