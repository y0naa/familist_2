import 'package:familist_2/screens/auth/register.dart';
import 'package:familist_2/screens/auth/signIn.dart';
import 'package:familist_2/screens/auth/verifyEmail.dart';
import 'package:familist_2/screens/mainPage.dart';
import 'package:familist_2/screens/profile/addMember.dart';
import 'package:familist_2/screens/reminders/remindersPage.dart';
import 'package:familist_2/screens/shopping/shoppingPage.dart';
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
      path: '/shopping',
      builder: (context, state) => const SuperPage(
        page: 1,
      ),
    ),
    GoRoute(
      path: '/reminders',
      builder: (context, state) => const SuperPage(
        page: 2,
      ),
    ),
    GoRoute(
      path: '/bills',
      builder: (context, state) => const SuperPage(
        page: 2,
        subPage: 1,
      ),
    ),
    GoRoute(
      path: '/schedule',
      builder: (context, state) => const SuperPage(
        page: 3,
      ),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const SuperPage(
        page: 4,
      ),
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
