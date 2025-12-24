import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiez_assigenment/feature/presentaion/screen/home_screen.dart';

import 'feature/presentaion/bloc/mcqs_bloc.dart';
import 'feature/presentaion/bloc/mcqs_event.dart';
import 'feature/presentaion/progress_bloc/progres_bloc.dart';
import 'feature/presentaion/progress_bloc/progres_event.dart';
import 'init_dependence.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependencies (DI, database, repos, usecases)
  await init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MCQBloc>(
          create: (_) => sl<MCQBloc>()..add(LoadAllMCQsEvent()),
        ),
        BlocProvider<ProgressBloc>(
          create: (_) => sl<ProgressBloc>()..add(LoadProgressEvent()),
        ),
      ],
      child: MaterialApp(
        title: 'MCQ App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomeScreen(), // Your main screen
      ),
    );
  }
}
