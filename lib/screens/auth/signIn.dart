import 'package:familist_2/constants.dart';
import 'package:familist_2/utils/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../widgets/dialog.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool isLoading = false;
  bool _visible = false;

  // text constrollers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _forgotPasswordEmailController = TextEditingController();

  Future signIn() async {
    try {
      await Auth().signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      GetStorage box = GetStorage();
      box.write("email", _emailController.text.trim());
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
      dialog(context, e.message.toString());
    }
  }

  Future forgotPassword() async {
    try {
      await Auth().forgotPassword(
        email: _forgotPasswordEmailController.text.trim(),
      );
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text(
                "The link has been sent to your email address, please check it out",
              ),
            );
          },
        );
      }
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(
              e.message.toString(),
            ),
          );
        },
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: bgColor,
      body: Stack(
        children: [
          Container(
            height: size.height * 0.4,
            decoration: const BoxDecoration(
              color: pColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(100),
                bottomRight: Radius.circular(100),
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0, 0.05),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(70),
                  topRight: Radius.circular(70),
                ),
              ),
              width: size.width * 0.9,
              height: size.height * 0.7,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                  //set border radius more than 50% of height and width to make circle
                ),
                elevation: 12,
                child: Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24, top: 75),
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Center(
                              child: Text(
                                "Reminders & Schedule For",
                                style: GoogleFonts.inter(
                                  fontSize: 24,
                                  color: sColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Center(
                              child: Text(
                                "Families",
                                style: GoogleFonts.inter(
                                  fontSize: 24,
                                  color: sColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),

                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Divider(
                                color: sColor,
                              ),
                            ),
                            Center(
                              child: Text(
                                "Sign In",
                                style: GoogleFonts.inter(
                                  fontSize: 24,
                                  color: sColor,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),

                            // email field
                            Text(
                              "Email",
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: sColor,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, right: 8),
                                child: TextField(
                                  controller: _emailController,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Enter your email",
                                    filled: false,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),

                            // password field
                            Text(
                              "Password",
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: sColor,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            // password
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 8,
                                  right: 8,
                                ),
                                child: TextField(
                                  controller: _passwordController,
                                  obscureText: _visible,
                                  decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.only(top: 15),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _visible = !_visible;
                                        });
                                      },
                                      icon: Icon(
                                        _visible
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                        color: sColor,
                                      ),
                                    ),
                                    border: InputBorder.none,
                                    hintText: "Enter your password",
                                    filled: false,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    await showForgotPassword(context);
                                  },
                                  child: Text(
                                    "Forgot Password?",
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: sColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),

                            TextButton(
                              onPressed: () async {
                                if (mounted) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                }

                                await signIn();
                                if (mounted) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll<Color>(
                                  const Color(0xFF0A369D).withOpacity(0.8),
                                ),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 16, bottom: 16),
                                child: Text(
                                  "Sign in",
                                  style: GoogleFonts.inter(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Not a member? ",
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    color: sColor,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    GoRouter.of(context).go("/register");
                                  },
                                  child: Text(
                                    "Register now",
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      color: sColor,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                ),
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0, -0.75),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30), //or 15.0
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      spreadRadius: 10,
                      blurRadius: 10,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Image(
                    image: AssetImage("assets/images/familist.png"),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<dynamic> showForgotPassword(BuildContext context) {
    return showBarModalBottomSheet(
      context: context,
      builder: (context) =>
          StatefulBuilder(builder: (BuildContext context, setState) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            controller: ModalScrollController.of(context),
            child: Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Forgot Password",
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
                    padding:
                        const EdgeInsets.only(top: 15, left: 32, right: 32),
                    child: Text(
                      "Please enter your email and we will send you a reset password link",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: sColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 32, right: 32, top: 20, bottom: 32),
                    child: TextField(
                      controller: _forgotPasswordEmailController,
                      decoration: InputDecoration(
                        hintText: "Your email here...",
                        filled: true,
                        fillColor: Colors.grey.shade100.withOpacity(0.5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                              color: Colors.grey.shade100, width: 0.0),
                        ),
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
                                const Color(0xFF0A369D).withOpacity(0.8),
                              ),
                            ),
                            onPressed: forgotPassword,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 16, bottom: 16),
                              child: Text(
                                "Reset Password",
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
            ),
          ),
        );
      }),
    );
  }
}
