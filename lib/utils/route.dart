import 'package:familist_2/screens/auth/register.dart';
import 'package:familist_2/screens/auth/signIn.dart';
import 'package:familist_2/screens/auth/verifyEmail.dart';
import 'package:familist_2/screens/mainPage.dart';
import 'package:familist_2/screens/superPage.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainPage(),
    ),
    GoRoute(
      path: '/verifyEmail',
      builder: (context, state) => const VerifyEmail(),
    ),
    GoRoute(
      path: '/signIn',
      builder: (context, state) => const SignIn(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const Register(),
    ),
    GoRoute(
      path: '/super',
      builder: (context, state) => const SuperPage(),
    ),
  ],
);
