import 'package:familist_2/screens/auth/register.dart';
import 'package:familist_2/screens/auth/sign_in.dart';
import 'package:familist_2/screens/auth/verify_email.dart';
import 'package:familist_2/screens/info.dart';
import 'package:familist_2/screens/main_page.dart';
import 'package:familist_2/screens/super_page.dart';
import 'package:go_router/go_router.dart';

import '../screens/profile/join_family.dart';
import '../screens/profile/scan_barcode.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/homeReminders',
      builder: (context, state) => const SuperPage(
        page: 0,
        subPage: 1,
      ),
    ),
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
      builder: (context, state) => const SuperPage(
        page: 0,
      ),
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
      path: '/info',
      builder: (context, state) => const Info(),
    ),
    GoRoute(
      path: '/schedule',
      builder: (context, state) => const SuperPage(
        page: 3,
      ),
    ),
    GoRoute(
      path: '/events',
      builder: (context, state) => const SuperPage(
        page: 3,
        subPage: 1,
      ),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const SuperPage(
        page: 4,
      ),
    ),
    GoRoute(
        path: "/joinFamily",
        name: "/joinFamily",
        builder: (context, state) {
          return const JoinFamily();
        }),
  ],
);
