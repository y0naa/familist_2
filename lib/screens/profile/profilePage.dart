import 'package:familist_2/constants.dart';
import 'package:familist_2/screens/reminders/bills.dart';
import 'package:familist_2/screens/reminders/reminders.dart';
import 'package:familist_2/widgets/profile/profileItem.dart';
import 'package:familist_2/widgets/tagButton.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../utils/auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _index = 0;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 64),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Profile",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 28,
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Expanded(
              child: Stack(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(70),
                            topRight: Radius.circular(70),
                          ),
                        ),
                        child:
                            // main column for white area
                            Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // continue from card
                            Padding(
                              padding: EdgeInsets.only(top: size.height * 0.2),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const ProfileItem(
                                    title: "Email",
                                    description: "ajownaa@gmail.com",
                                    icon: Icons.mail_outline_rounded,
                                    isFamily: false,
                                  ),
                                  const ProfileItem(
                                    title: "Phone Number",
                                    description: "085172411337",
                                    icon: Icons.phone_outlined,
                                    isFamily: false,
                                  ),
                                  const ProfileItem(
                                    title: "Family",
                                    description: "Wibowo Family",
                                    icon: Icons.family_restroom_outlined,
                                    isFamily: true,
                                  ),
                                  SizedBox(
                                    height: size.height * 0.1,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 24, left: 24),
                                    child: TextButton(
                                      onPressed: signOut,
                                      style: const ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll<Color>(
                                                Color(0xFFD26F6F)),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 16, bottom: 16),
                                        child: Text(
                                          "Sign Out",
                                          style: GoogleFonts.inter(
                                              fontSize: 18,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // show list
                          ],
                        ),
                      ),
                    ),
                  ),

                  // elevated
                  Align(
                    alignment: const Alignment(0, -1.1),
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(70),
                          topRight: Radius.circular(70),
                        ),
                      ),
                      width: size.width * 0.8,
                      height: size.height * 0.25,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                          //set border radius more than 50% of height and width to make circle
                        ),
                        elevation: 12,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 24, right: 24, top: 24),
                          child: Column(
                            children: [
                              Material(
                                borderRadius: BorderRadius.circular(50),
                                elevation: 10,
                                child: const CircleAvatar(
                                  radius: 45,
                                  backgroundColor: tColor,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Stack(
                                children: [
                                  Align(
                                    child: Column(
                                      children: [
                                        Text(
                                          "Jowna Alynsah",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.inter(
                                            fontSize: 18,
                                            color: sColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "Daughter and Student",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.inter(
                                            fontSize: 16,
                                            color: sColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Positioned(
                                    right: 0,
                                    top: 20,
                                    child: Icon(
                                      Icons.edit,
                                      size: 14,
                                      color: sColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
