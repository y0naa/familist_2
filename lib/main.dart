import 'package:familist_2/constants.dart';
import 'package:familist_2/utils/route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: pColor,
          textTheme: Theme.of(context)
              .textTheme
              .apply(fontFamily: GoogleFonts.inter().fontFamily)),
    );
  }
}