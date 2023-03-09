// ignore_for_file: depend_on_referenced_packages
import 'package:familist_2/constants.dart';
import 'package:familist_2/utils/auth.dart';
import 'package:familist_2/utils/notif.dart';
import 'package:familist_2/utils/remindersHelper.dart';
import 'package:familist_2/utils/route.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp();
  if (Auth().currentUser != null) {
    NotificationApi.initNotif();
    RemindersHelpers().setReminderNotif();
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
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
