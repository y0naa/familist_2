import 'package:familist_2/screens/superPage.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(routes: [
  GoRoute(
    path: '/',
    builder: (context, state) => const SuperPage(),
  ),
]);
