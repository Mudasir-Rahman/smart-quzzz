import 'package:flutter/material.dart';
import 'package:quiez_assigenment/feature/auth/domain/entity/auth_entity.dart';
import 'package:quiez_assigenment/feature/auth/presentaion/screen/signin_screen.dart';
import 'package:quiez_assigenment/feature/auth/presentaion/screen/signup_screen.dart';
import 'package:quiez_assigenment/feature/presentaion/screen/home_screen.dart';
import 'package:quiez_assigenment/loading_screen.dart';

class AppRoutes {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static const String loading = '/';
  static const String signin = '/signin';
  static const String signup = '/signup';
  static const String home = '/home';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loading:
        return MaterialPageRoute(builder: (_) => const LoadingScreen());
      case signin:
        return MaterialPageRoute(builder: (_) => const SigninUi());
      case signup:
        return MaterialPageRoute(builder: (_) => const SignupUi());
      case home:
        final user = settings.arguments as UserEntity?;
        if (user != null) {
          return MaterialPageRoute(builder: (_) => HomeScreen(user: user));
        } else {
          return _errorRoute(settings.name);
        }
      default:
        return _errorRoute(settings.name);
    }
  }

  static Route<dynamic> _errorRoute(String? routeName) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(
          child: Text('Error: No route defined for $routeName'),
        ),
      ),
    );
  }
}
