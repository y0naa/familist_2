import 'package:familist_2/constants.dart';
import 'package:familist_2/screens/Home/homeShopping.dart';
import 'package:familist_2/screens/home/homeReminders.dart';
import 'package:familist_2/widgets/tagButton.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        // Upper side blue area
        Padding(
          padding: const EdgeInsets.only(top: 64, left: 42, right: 42),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Column for welcome title and stuff
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Welcome,",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      "Jowna", // changed
                      style: GoogleFonts.inter(
                        fontSize: 36,
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),

                  // Row For Date and Day
                  Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "[13 February 2023] ",
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "[Monday]",
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Avatar
              const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 45,
              )
            ],
          ),
        ),
        const SizedBox(
          height: 50,
        ),
        Expanded(
          child: Container(
            height: 200,
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
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TagButton(
                        tapped: _index == 0 ? true : false,
                        text: "Shopping List",
                        onTap: () {
                          setState(() {
                            _index = 0;
                          });
                        },
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      TagButton(
                        tapped: _index == 1 ? true : false,
                        text: "Reminders",
                        onTap: () {
                          setState(() {
                            _index = 1;
                          });
                        },
                      ),
                    ],
                  ),
                ),

                // show list
                const SizedBox(
                  height: 10,
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24),
                  child:
                      // separate widget
                      Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Added by you",
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: sColor,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      _index == 0 ? const HomeShopping() : const HomeReminders()
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
