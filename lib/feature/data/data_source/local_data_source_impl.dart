// import 'package:sqflite/sqflite.dart';
//
// import '../model/model.dart';
// import 'database_helper.dart';
// import 'local_data_source.dart';
//
// class LocalDataSourceImpl implements LocalDataSource {
//   final DatabaseHelper databaseHelper;
//
//   LocalDataSourceImpl({required this.databaseHelper});
//
//   @override
//   Future<List<MCQModel>> getAllMCQs() async {
//     final db = await databaseHelper.database;
//     final result = await db.query('mcqs', orderBy: 'createdAt DESC');
//     return result.map((map) => MCQModel.fromMap(map)).toList();
//   }
//
//   @override
//   Future<MCQModel?> getMCQById(String id) async {
//     final db = await databaseHelper.database;
//     final result = await db.query(
//       'mcqs',
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//
//     if (result.isEmpty) return null;
//     return MCQModel.fromMap(result.first);
//   }
//
//   @override
//   Future<void> insertMCQ(MCQModel mcq) async {
//     final db = await databaseHelper.database;
//     await db.insert(
//       'mcqs',
//       mcq.toMap(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//
//     // Initialize progress for this question
//     await db.insert(
//       'question_progress',
//       QuestionProgressModel(
//         mcqId: mcq.id,
//         timesAttempted: 0,
//         timesCorrect: 0,
//         timesIncorrect: 0,
//         lastAttempted: DateTime.now(),
//         repetitionLevel: 0,
//       ).toMap(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }
//
//   @override
//   Future<void> updateMCQ(MCQModel mcq) async {
//     final db = await databaseHelper.database;
//     await db.update(
//       'mcqs',
//       mcq.toMap(),
//       where: 'id = ?',
//       whereArgs: [mcq.id],
//     );
//   }
//
//   @override
//   Future<void> deleteMCQ(String id) async {
//     final db = await databaseHelper.database;
//     await db.delete(
//       'mcqs',
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//   }
//
//   @override
//   Future<void> insertUserAnswer(UserAnswerModel answer) async {
//     final db = await databaseHelper.database;
//     await db.insert(
//       'user_answers',
//       answer.toMap(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }
//
//   @override
//   Future<List<UserAnswerModel>> getUserAnswers() async {
//     final db = await databaseHelper.database;
//     final result = await db.query('user_answers', orderBy: 'answeredAt DESC');
//     return result.map((map) => UserAnswerModel.fromMap(map)).toList();
//   }
//
//   @override
//   Future<List<UserAnswerModel>> getUserAnswersByMCQId(String mcqId) async {
//     final db = await databaseHelper.database;
//     final result = await db.query(
//       'user_answers',
//       where: 'mcqId = ?',
//       whereArgs: [mcqId],
//       orderBy: 'answeredAt DESC',
//     );
//     return result.map((map) => UserAnswerModel.fromMap(map)).toList();
//   }
//
//   @override
//   Future<QuestionProgressModel?> getQuestionProgress(String mcqId) async {
//     final db = await databaseHelper.database;
//     final result = await db.query(
//       'question_progress',
//       where: 'mcqId = ?',
//       whereArgs: [mcqId],
//     );
//
//     if (result.isEmpty) return null;
//     return QuestionProgressModel.fromMap(result.first);
//   }
//
//   @override
//   Future<void> updateQuestionProgress(QuestionProgressModel progress) async {
//     final db = await databaseHelper.database;
//     await db.update(
//       'question_progress',
//       progress.toMap(),
//       where: 'mcqId = ?',
//       whereArgs: [progress.mcqId],
//     );
//   }
//
//   @override
//   Future<List<QuestionProgressModel>> getAllQuestionProgress() async {
//     final db = await databaseHelper.database;
//     final result = await db.query('question_progress');
//     return result.map((map) => QuestionProgressModel.fromMap(map)).toList();
//   }
// }