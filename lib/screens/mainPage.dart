// ignore_for_file: file_names

import 'package:familist_2/screens/auth/signIn.dart';
import 'package:familist_2/screens/auth/verifyEmail.dart';
import 'package:familist_2/utils/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// authentication page for signing in
class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: StreamBuilder<User?>(
        stream: Auth().authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const VerifyEmail();
          } else {
            return const SignIn();
          }
        },
      ),
    );
  }
}
