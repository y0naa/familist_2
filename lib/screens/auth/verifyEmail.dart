import 'dart:async';

import 'package:familist_2/screens/superPage.dart';
import 'package:familist_2/utils/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants.dart';
import '../../widgets/dialog.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});
  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  bool _isEmailVerified = false;
  bool _canResendEmail = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _isEmailVerified = Auth().currentUser!.emailVerified;

    if (!_isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      if (mounted) {
        setState(() => _canResendEmail = false);
      }

      await Future.delayed(
        const Duration(seconds: 5),
      );
      if (mounted) {
        setState(() => _canResendEmail = true);
      }
    } catch (e) {
      dialog(context, e.toString());
    }
  }

  Future checkEmailVerified() async {
    if (Auth().currentUser != null) {
      await Auth().currentUser!.reload();
    }
    if (mounted) {
      setState(() {
        if (Auth().currentUser == null) {
          GoRouter.of(context).pushReplacement("/signIn");
        } else {
          _isEmailVerified = Auth().currentUser!.emailVerified;
        }
      });
    }

    if (_isEmailVerified) timer?.cancel();
  }

  @override
  void dispose() {
    timer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isEmailVerified
        ? const SuperPage()
        : Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "Verify Email",
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      color: sColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15, left: 32, right: 32),
                  child: Text(
                    "A verification email has been sent to your email. Please click on the link to verify",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: sColor,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 32, right: 32, top: 32, bottom: 32),
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll<Color>(
                                _canResendEmail
                                    ? const Color(0xFF0A369D).withOpacity(0.8)
                                    : const Color(0xFF0A369D).withOpacity(0.5)),
                          ),
                          onPressed:
                              _canResendEmail ? sendVerificationEmail : () {},
                          child: Padding(
                            padding: const EdgeInsets.only(top: 16, bottom: 16),
                            child: Text(
                              "Resend Email",
                              style: GoogleFonts.inter(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 32, right: 32, bottom: 32),
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll<Color>(
                              const Color.fromARGB(255, 238, 0, 0)
                                  .withOpacity(0.5),
                            ),
                          ),
                          onPressed: () {
                            if (Auth().currentUser != null) {
                              Auth().signOut();
                            } else {
                              GoRouter.of(context).pushReplacement("/signIn");
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 16, bottom: 16),
                            child: Text(
                              "Cancel",
                              style: GoogleFonts.inter(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
  }
}
