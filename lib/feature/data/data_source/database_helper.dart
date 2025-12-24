// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
//
// class DatabaseHelper {
//   static final DatabaseHelper instance = DatabaseHelper._init();
//   static Database? _database;
//
//   DatabaseHelper._init();
//
//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDB('smart_mcq.db');
//     return _database!;
//   }
//
//   Future<Database> _initDB(String filePath) async {
//     final dbPath = await getDatabasesPath();
//     final path = join(dbPath, filePath);
//
//     return await openDatabase(
//       path,
//       version: 1,
//       onCreate: _createDB,
//     );
//   }
//
//   Future<void> _createDB(Database db, int version) async {
//     const idType = 'TEXT PRIMARY KEY';
//     const textType = 'TEXT NOT NULL';
//     const intType = 'INTEGER NOT NULL';
//     const textTypeNullable = 'TEXT';
//
//     await db.execute('''
//       CREATE TABLE mcqs (
//         id $idType,
//         question $textType,
//         options $textType,
//         correctAnswerIndex $intType,
//         explanation $textTypeNullable,
//         category $textType,
//         difficultyLevel $intType,
//         createdAt $textType
//       )
//     ''');
//
//     await db.execute('''
//       CREATE TABLE user_answers (
//         id $idType,
//         mcqId $textType,
//         selectedAnswerIndex $intType,
//         isCorrect $intType,
//         answeredAt $textType,
//         timeSpentSeconds $intType,
//         FOREIGN KEY (mcqId) REFERENCES mcqs (id) ON DELETE CASCADE
//       )
//     ''');
//
//     await db.execute('''
//       CREATE TABLE question_progress (
//         mcqId $idType,
//         timesAttempted $intType,
//         timesCorrect $intType,
//         timesIncorrect $intType,
//         lastAttempted $textType,
//         nextReviewDate $textTypeNullable,
//         repetitionLevel $intType,
//         FOREIGN KEY (mcqId) REFERENCES mcqs (id) ON DELETE CASCADE
//       )
//     ''');
//
//     // Insert sample MCQs
//     await _insertSampleData(db);
//   }
//
//   Future<void> _insertSampleData(Database db) async {
//     final sampleMCQs = [
//       {
//         'id': '1',
//         'question': 'What is Flutter?',
//         'options':
//         '["A mobile app SDK", "A programming language", "A database", "An operating system"]',
//         'correctAnswerIndex': 0,
//         'explanation':
//         'Flutter is an open-source UI software development kit created by Google.',
//         'category': 'Flutter',
//         'difficultyLevel': 1,
//         'createdAt': DateTime.now().toIso8601String(),
//       },
//       {
//         'id': '2',
//         'question': 'Which programming language is used in Flutter?',
//         'options': '["Java", "Kotlin", "Dart", "Swift"]',
//         'correctAnswerIndex': 2,
//         'explanation': 'Flutter uses Dart programming language.',
//         'category': 'Flutter',
//         'difficultyLevel': 1,
//         'createdAt': DateTime.now().toIso8601String(),
//       },
//       {
//         'id': '3',
//         'question': 'What is the capital of France?',
//         'options': '["London", "Berlin", "Paris", "Madrid"]',
//         'correctAnswerIndex': 2,
//         'explanation': 'Paris is the capital and largest city of France.',
//         'category': 'Geography',
//         'difficultyLevel': 1,
//         'createdAt': DateTime.now().toIso8601String(),
//       },
//       {
//         'id': '4',
//         'question': 'What does BLoC stand for?',
//         'options':
//         '["Basic Logic Component", "Business Logic Component", "Build Logic Controller", "Backend Logic Core"]',
//         'correctAnswerIndex': 1,
//         'explanation':
//         'BLoC stands for Business Logic Component, a design pattern in Flutter.',
//         'category': 'Flutter',
//         'difficultyLevel': 2,
//         'createdAt': DateTime.now().toIso8601String(),
//       },
//       {
//         'id': '5',
//         'question': 'Which widget is used for state management in Flutter?',
//         'options':
//         '["StatelessWidget", "StatefulWidget", "Both", "Neither"]',
//         'correctAnswerIndex': 2,
//         'explanation':
//         'Both StatelessWidget and StatefulWidget are used, but StatefulWidget manages mutable state.',
//         'category': 'Flutter',
//         'difficultyLevel': 2,
//         'createdAt': DateTime.now().toIso8601String(),
//       },
//     ];
//
//     for (var mcq in sampleMCQs) {
//       await db.insert('mcqs', mcq);
//       await db.insert('question_progress', {
//         'mcqId': mcq['id'],
//         'timesAttempted': 0,
//         'timesCorrect': 0,
//         'timesIncorrect': 0,
//         'lastAttempted': DateTime.now().toIso8601String(),
//         'nextReviewDate': null,
//         'repetitionLevel': 0,
//       });
//     }
//   }
//
//   Future<void> close() async {
//     final db = await instance.database;
//     db.close();
//   }
//
//   Future<void> resetDatabase() async {
//     final dbPath = await getDatabasesPath();
//     final path = join(dbPath, 'smart_mcq.db');
//     await deleteDatabase(path);
//     _database = null;
//   }
// }