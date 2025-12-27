import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiez_assigenment/app_routes.dart';
import 'package:quiez_assigenment/app_theme.dart';
import 'package:quiez_assigenment/feature/auth/presentaion/bloc/auth_bloc.dart';
import 'package:quiez_assigenment/feature/auth/presentaion/bloc/auth_event.dart';
import 'package:quiez_assigenment/feature/auth/presentaion/bloc/auth_state.dart';
import 'package:quiez_assigenment/feature/presentaion/bloc/mcqs_bloc.dart';
import 'package:quiez_assigenment/feature/presentaion/progress_bloc/progres_bloc.dart';
import 'init_dependence.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => di.sl<AuthBloc>()..add(CheckAuthStatusEvent()),
          lazy: false,
        ),
        BlocProvider<MCQBloc>(
          create: (_) => di.sl<MCQBloc>(),
        ),
        BlocProvider<ProgressBloc>(
          create: (_) => di.sl<ProgressBloc>(),
        ),
      ],
      child: const AppNavigation(),
    );
  }
}

class AppNavigation extends StatelessWidget {
  const AppNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthBlocState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          AppRoutes.navigatorKey.currentState?.pushNamedAndRemoveUntil(
            AppRoutes.home,
                (route) => false,
            arguments: state.user,
          );
        } else if (state is AuthLoggedOut || state is AuthError) {
          AppRoutes.navigatorKey.currentState?.pushNamedAndRemoveUntil(
            AppRoutes.signin,
                (route) => false,
          );
        }
      },
      child: MaterialApp(
        title: 'Smart MCQ Practice',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.loading,
        onGenerateRoute: AppRoutes.onGenerateRoute,
        navigatorKey: AppRoutes.navigatorKey,
      ),
    );
  }
}
