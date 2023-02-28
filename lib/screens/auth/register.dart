import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familist_2/constants.dart';
import 'package:familist_2/widgets/dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/auth.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _visible = false;
  bool isLoading = false;

  // text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _telephoneController = TextEditingController();

  Future signUp() async {
    // create user
    try {
      await Auth().createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (context.mounted) {
        Auth().signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // add user details
        addUserDetails(
          _nameController.text.trim(),
          _telephoneController.text.trim(),
          _emailController.text.trim(),
        );

        GoRouter.of(context).push("/verifyEmail");
      }
    } on FirebaseAuthException catch (e) {
      dialog(context, e.message.toString());
    }
  }

  Future addUserDetails(String name, String telephone, String email) async {
    await FirebaseFirestore.instance.collection("users").add({
      "full name": name,
      "telephone": telephone,
      "email": email,
      "bio": "",
      "fuid": "",
      "imageUrl": "",
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _telephoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool _keyboardVisible =
        MediaQuery.of(context).viewInsets.bottom == 0 ? true : false;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: bgColor,
      body: Builder(builder: (context) {
        return Stack(
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
              child: SingleChildScrollView(
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
                      padding:
                          const EdgeInsets.only(left: 24, right: 24, top: 75),
                      child: isLoading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Center(
                                  child: Text(
                                    "Register",
                                    style: GoogleFonts.inter(
                                      fontSize: 24,
                                      color: sColor,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Full name",
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
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8, right: 8),
                                    child: TextField(
                                      controller: _nameController,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Enter your full name",
                                        filled: false,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Telephone",
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
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 8,
                                      right: 8,
                                    ),
                                    child: TextField(
                                      controller: _telephoneController,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Enter your phone number",
                                        filled: false,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
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
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 8,
                                      right: 8,
                                    ),
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
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    border:
                                        Border.all(color: Colors.grey.shade300),
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
                                TextButton(
                                  onPressed: () async {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    await signUp();
                                    setState(() {
                                      isLoading = false;
                                    });
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStatePropertyAll<Color>(
                                      const Color(0xFF0A369D).withOpacity(0.8),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 10),
                                    child: Text(
                                      "Register",
                                      style: GoogleFonts.inter(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Have an account? ",
                                      style: GoogleFonts.inter(
                                        fontSize: 16,
                                        color: sColor,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        GoRouter.of(context).go("/");
                                      },
                                      child: Text(
                                        "Login",
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
            ),
            _keyboardVisible
                ? Align(
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
                              offset:
                                  Offset(0, 3), // changes position of shadow
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
                : Container(),
          ],
        );
      }),
    );
  }
}
