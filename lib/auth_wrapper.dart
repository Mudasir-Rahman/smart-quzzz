import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiez_assigenment/app_routes.dart';
import 'package:quiez_assigenment/feature/auth/presentaion/bloc/auth_bloc.dart';
import 'package:quiez_assigenment/feature/auth/presentaion/bloc/auth_event.dart';
import 'package:quiez_assigenment/feature/auth/presentaion/bloc/auth_state.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(CheckAuthStatusEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthBlocState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.home);
        } else if (state is AuthLoggedOut || state is AuthError) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.signin);
        }
      },
      builder: (context, state) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
