import 'package:familist_2/screens/auth/register.dart';
import 'package:familist_2/screens/auth/signIn.dart';
import 'package:familist_2/screens/auth/verifyEmail.dart';
import 'package:familist_2/screens/mainPage.dart';
import 'package:familist_2/screens/profile/addMember.dart';
import 'package:familist_2/screens/superPage.dart';
import 'package:go_router/go_router.dart';
import '../screens/profile/scanBarcode.dart';

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
    GoRoute(
      path: '/scanQR',
      builder: (context, state) => const ScanQR(),
    ),
    GoRoute(
        path: '/addMember/:fuid',
        name: "addMember",
        builder: (context, state) {
          print("state params ${state.params["fuid"]!}");
          return AddMember(
            fuid: state.params["fuid"]!,
          );
        }),
  ],
);
