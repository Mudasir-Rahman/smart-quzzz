//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:quiez_assigenment/feature/presentaion/screen/splash_screen.dart';
//
// import 'feature/presentaion/screen/home_screen.dart';
// import 'feature/presentaion/bloc/mcqs_bloc.dart';
// import 'feature/presentaion/bloc/mcqs_event.dart';
// import 'feature/presentaion/progress_bloc/progres_bloc.dart';
// import 'feature/presentaion/progress_bloc/progres_event.dart';
// import 'init_dependence.dart' as di;
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   // Initialize dependencies (DI, repos, usecases)
//   // Supabase will be initialized inside SupabaseHelper
//   await di.init();
//
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider<MCQBloc>(
//           create: (_) => di.sl<MCQBloc>()..add(LoadAllMCQsEvent()),
//         ),
//         BlocProvider<ProgressBloc>(
//           create: (_) => di.sl<ProgressBloc>()..add(LoadProgressEvent()),
//         ),
//       ],
//       child: MaterialApp(
//         title: 'Smart MCQ Practice',
//         theme: ThemeData(
//           colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//           useMaterial3: true,
//         ),
//         home: const SplashScreen(),
//         debugShowCheckedModeBanner: false,
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'feature/auth/presentaion/bloc/auth_event.dart';
import 'feature/presentaion/bloc/mcqs_bloc.dart';
import 'feature/presentaion/bloc/mcqs_event.dart';
import 'feature/presentaion/progress_bloc/progres_bloc.dart';
import 'feature/presentaion/progress_bloc/progres_event.dart';
import 'feature/auth/presentaion/bloc/auth_bloc.dart';
import 'feature/auth/presentaion/bloc/auth_state.dart';
import 'feature/auth/presentaion/screen/signin_screen.dart';
import 'feature/auth/presentaion/screen/signup_screen.dart';
import 'feature/presentaion/screen/home_screen.dart';
import 'init_dependence.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependencies
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
        ),
        BlocProvider<MCQBloc>(
          create: (_) => di.sl<MCQBloc>()..add(LoadAllMCQsEvent()),
        ),
        BlocProvider<ProgressBloc>(
          create: (_) => di.sl<ProgressBloc>()..add(LoadProgressEvent()),
        ),
      ],
      child: MaterialApp(
        title: 'Smart MCQ Practice',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: const AuthWrapper(),
        routes: {
          '/signin': (context) => const SigninUi(),
          '/signup': (context) => const SignupUi(),
          '/home': (context) => const HomeScreen(),
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthBlocState>(
      listener: (context, state) {
        print('🔔 AuthWrapper listener - State: ${state.runtimeType}');
        if (state is AuthSuccess) {
          print('🎯 AuthWrapper: AuthSuccess detected - ${state.user.email}');
        }
      },
      builder: (context, state) {
        print('🔄 AuthWrapper builder - Current state: ${state.runtimeType}');

        // Show loading while checking auth
        if (state is AuthLoading) {
          print('⏳ AuthWrapper: Showing loading screen (AuthLoading)');
          return const LoadingScreen();
        }

        // Handle initial state
        if (state is AuthInitial) {
          print('⏳ AuthWrapper: Showing loading screen (AuthInitial)');
          return const LoadingScreen();
        }

        // User is authenticated - go to home
        if (state is AuthSuccess) {
          print('✅ AuthWrapper: User authenticated - ${state.user.email}');
          print('✅ AuthWrapper: Navigating to HomeScreen');
          return const HomeScreen();
        }

        // User is not authenticated - go to sign in
        if (state is AuthLoggedOut || state is AuthFailure) {
          print('🔒 AuthWrapper: User not authenticated, showing SigninUi');
          return const SigninUi();
        }

        // Fallback - show loading
        print('⚠️ AuthWrapper: Unknown state, showing loading');
        return const LoadingScreen();
      },
    );
  }
}

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool _showRefreshButton = false;

  @override
  void initState() {
    super.initState();

    // Add a timeout to prevent getting stuck
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showRefreshButton = true;
        });
        print('⚠️ LoadingScreen: Timeout reached, showing refresh button');
      }
    });

    // Check auth status again after a delay
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        print('🔄 LoadingScreen: Checking auth status again');
        context.read<AuthBloc>().add(CheckAuthStatusEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.deepPurple.shade400,
              Colors.deepPurple.shade700,
              Colors.purple.shade900,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.quiz,
                  size: 100,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Smart MCQ',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Practice. Learn. Master.',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white.withOpacity(0.9),
                  letterSpacing: 1,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(height: 60),
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white.withOpacity(0.7),
                  ),
                  strokeWidth: 3,
                ),
              ),
              const SizedBox(height: 20),
              if (_showRefreshButton)
                Column(
                  children: [
                    Text(
                      'Taking too long?',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        print('🔄 Manual refresh triggered from LoadingScreen');
                        context.read<AuthBloc>().add(CheckAuthStatusEvent());
                        setState(() {
                          _showRefreshButton = false;
                        });
                        // Hide button again after 3 seconds
                        Future.delayed(const Duration(seconds: 3), () {
                          if (mounted) {
                            setState(() {
                              _showRefreshButton = true;
                            });
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        'Refresh',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}