import 'package:familist_2/constants.dart';

import 'package:familist_2/screens/home/home_reminders_section.dart';
import 'package:familist_2/widgets/tag_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';

import '../../utils/auth.dart';
import '../../utils/profile.dart';
import '../../widgets/dialog.dart';
import 'home_shopping_section.dart';

class HomePage extends StatefulWidget {
  final int? pageIndex;
  const HomePage({super.key, this.pageIndex});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;
  String _name = "";
  String _imageUrl = "";

  Future<void> signOut() async {
    try {
      await Auth().signOut();
      if (context.mounted) {
        GoRouter.of(context).pushReplacement("/");
      }
    } catch (e) {
      dialog(context, e.toString());
    }
  }

  void getName() async {
    Map temp = await Profile().getUserDetails();
    if (mounted) {
      setState(() {
        _name = temp["full name"];
        _imageUrl = temp["imageUrl"] ?? "";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    widget.pageIndex != null ? _index = widget.pageIndex! : 0;
    print("hello $_index");
    getName();
  }

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
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: SizedBox(
                      width: size.width * 0.5,
                      child: Text(
                        _name,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
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
                          Jiffy(DateTime.now()).format("EEEE[,] "),
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          Jiffy(DateTime.now()).format("do MMMM yyyy"),
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Avatar
              _imageUrl.isEmpty
                  ? const CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 45,
                    )
                  : CircleAvatar(
                      radius: 45,
                      backgroundColor: tColor,
                      child: ClipOval(
                        child: Image.network(
                          _imageUrl,
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
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
                          if (mounted) {
                            setState(() {
                              _index = 0;
                            });
                          }
                        },
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      TagButton(
                        tapped: _index == 1 ? true : false,
                        text: "Reminders",
                        onTap: () {
                          if (mounted) {
                            setState(() {
                              _index = 1;
                            });
                          }
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
                  padding:
                      const EdgeInsets.only(left: 24, right: 24, bottom: 0),
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
                      _index == 0 ? const HomeShopping() : const HomeReminders()
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
