import 'package:familist_2/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Info extends StatelessWidget {
  const Info({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 32),
        height: double.infinity,
        color: bgColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BackButton(
              color: sColor,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 32,
                  ),
                  Text(
                    "Help",
                    textAlign: TextAlign.left,
                    style: GoogleFonts.inter(
                      fontSize: 36,
                      color: sColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        ExpansionTile(
                          tilePadding: const EdgeInsets.all(0),
                          title: const Text(
                            "Home",
                            textAlign: TextAlign.left,
                          ),
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: RichText(
                                textAlign: TextAlign.justify,
                                text: TextSpan(
                                  children: const [
                                    TextSpan(
                                      text:
                                          "The home page is divided into 2 sections: ",
                                    ),
                                    TextSpan(
                                      text: "Shopping section ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: "and ",
                                    ),
                                    TextSpan(
                                      text: "Reminders section. ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text:
                                          "Both sections will show up to 5 items of the corresponding collection that is added by you ",
                                    ),
                                  ],
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    color: sColor,
                                  ),
                                ),
                              ),
                            ),
                            const Divider(),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: RichText(
                                textAlign: TextAlign.justify,
                                text: TextSpan(
                                  children: const [
                                    TextSpan(
                                      text:
                                          "You can view today's date and your profile on the home page. ",
                                    ),
                                  ],
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    color: sColor,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        ExpansionTile(
                          tilePadding: const EdgeInsets.all(0),
                          title: const Text("Shopping"),
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: RichText(
                                textAlign: TextAlign.justify,
                                text: TextSpan(
                                  children: const [
                                    TextSpan(
                                      text:
                                          "You can view your completed or incomplete shopping items and filter out by pressing on a category ",
                                    ),
                                  ],
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    color: sColor,
                                  ),
                                ),
                              ),
                            ),
                            const Divider(),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: RichText(
                                textAlign: TextAlign.justify,
                                text: TextSpan(
                                  children: const [
                                    TextSpan(
                                      text:
                                          "To toggle completed and incomplete on a shopping item you can ",
                                    ),
                                    TextSpan(
                                      text: "swipe item horizontally. ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                            const Divider(),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: RichText(
                                textAlign: TextAlign.start,
                                text: TextSpan(
                                  children: const [
                                    TextSpan(
                                      text:
                                          "You can also add an item by pressing  \"+\".",
                                    ),
                                  ],
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    color: sColor,
                                  ),
                                ),
                              ),
                            ),
                            const Divider(),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: RichText(
                                textAlign: TextAlign.justify,
                                text: TextSpan(
                                  children: const [
                                    TextSpan(
                                      text:
                                          "You can only delete your own items. ",
                                    ),
                                  ],
                                  style: GoogleFonts.inter(
                                      fontSize: 16,
                                      color: sColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                        ExpansionTile(
                          tilePadding: const EdgeInsets.all(0),
                          title: const Text("Reminders"),
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: RichText(
                                textAlign: TextAlign.justify,
                                text: TextSpan(
                                  children: const [
                                    TextSpan(
                                      text:
                                          "The reminders page is divided into 2 sections: ",
                                    ),
                                    TextSpan(
                                      text: "Reminders ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: "and ",
                                    ),
                                    TextSpan(
                                      text: "Bills section. ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                        text:
                                            "Reminders will store and notify users once while Bills will repeatedly notify users by a set interval."),
                                  ],
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    color: sColor,
                                  ),
                                ),
                              ),
                            ),
                            const Divider(),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: RichText(
                                textAlign: TextAlign.justify,
                                text: TextSpan(
                                  children: const [
                                    TextSpan(
                                      text: "To ",
                                    ),
                                    TextSpan(
                                      text: "delete reminders ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: "you can ",
                                    ),
                                    TextSpan(
                                      text: "swipe item horizontally ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: "or press ",
                                    ),
                                    WidgetSpan(
                                      child: Icon(
                                        Icons.delete_outline_rounded,
                                        color: Colors.red,
                                        size: 18,
                                      ),
                                    ),
                                    TextSpan(
                                      text: " for ",
                                    ),
                                    TextSpan(
                                      text: "bills.",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                            const Divider(),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: RichText(
                                textAlign: TextAlign.start,
                                text: TextSpan(
                                  children: const [
                                    TextSpan(
                                      text:
                                          "You can also add an item by pressing  \"+\". ",
                                    ),
                                  ],
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    color: sColor,
                                  ),
                                ),
                              ),
                            ),
                            const Divider(),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: RichText(
                                textAlign: TextAlign.justify,
                                text: TextSpan(
                                  children: const [
                                    TextSpan(
                                      text:
                                          "You can only delete your own items ",
                                    ),
                                  ],
                                  style: GoogleFonts.inter(
                                      fontSize: 16,
                                      color: sColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: RichText(
                                textAlign: TextAlign.justify,
                                text: TextSpan(
                                  children: const [
                                    TextSpan(
                                      text:
                                          "Press the card of a bill to toggle",
                                    ),
                                    TextSpan(
                                      text: " paid and unpaid",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: " status.",
                                    ),
                                  ],
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    color: sColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        ExpansionTile(
                          tilePadding: const EdgeInsets.all(0),
                          title: const Text("Schedule"),
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: RichText(
                                textAlign: TextAlign.justify,
                                text: TextSpan(
                                  children: const [
                                    TextSpan(
                                      text:
                                          "The Schedule page is divided into 2 sections: ",
                                    ),
                                    TextSpan(
                                      text: "Schedule ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: "and ",
                                    ),
                                    TextSpan(
                                      text: "Events section. ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    color: sColor,
                                  ),
                                ),
                              ),
                            ),
                            const Divider(),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: RichText(
                                textAlign: TextAlign.justify,
                                text: TextSpan(
                                  children: const [
                                    TextSpan(
                                        text:
                                            "You can view each person schedule by selecting a user's name and the day of the week."),
                                  ],
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    color: sColor,
                                  ),
                                ),
                              ),
                            ),
                            const Divider(),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: RichText(
                                textAlign: TextAlign.justify,
                                text: TextSpan(
                                  children: const [
                                    TextSpan(
                                      text: "To ",
                                    ),
                                    TextSpan(
                                      text: "delete items in schedule ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: "you can ",
                                    ),
                                    TextSpan(
                                      text: "press ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    WidgetSpan(
                                      child: Icon(
                                        Icons.delete_outline_rounded,
                                        color: Colors.red,
                                        size: 18,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ".",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                            const Divider(),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: RichText(
                                textAlign: TextAlign.start,
                                text: TextSpan(
                                  children: const [
                                    TextSpan(
                                      text:
                                          "You can also add an item by pressing  \"+\". ",
                                    ),
                                  ],
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    color: sColor,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        ExpansionTile(
                          tilePadding: const EdgeInsets.all(0),
                          title: const Text("Profile"),
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: RichText(
                                textAlign: TextAlign.justify,
                                text: TextSpan(
                                  children: const [
                                    TextSpan(
                                      text:
                                          "You can edit your profile information as well as manage family members. ",
                                    ),
                                  ],
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    color: sColor,
                                  ),
                                ),
                              ),
                            ),
                            const Divider(),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: RichText(
                                textAlign: TextAlign.justify,
                                text: TextSpan(
                                  children: const [
                                    TextSpan(
                                        text:
                                            "You can rename your family by pressing the "),
                                    WidgetSpan(
                                      child: Icon(
                                        Icons.edit,
                                        size: 18,
                                        color: sColor,
                                      ),
                                    ),
                                    TextSpan(
                                        text:
                                            "icon and then saving it by pressing "),
                                    WidgetSpan(
                                      child: Icon(
                                        Icons.save,
                                        size: 18,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    color: sColor,
                                  ),
                                ),
                              ),
                            ),
                            const Divider(),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: RichText(
                                textAlign: TextAlign.start,
                                text: TextSpan(
                                  children: const [
                                    TextSpan(
                                      text:
                                          "You can leave family, add members by showing or scanning a QR code",
                                    ),
                                  ],
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    color: sColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        ExpansionTile(
                          tilePadding: const EdgeInsets.all(0),
                          title: const Text("Notifications"),
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: RichText(
                                textAlign: TextAlign.justify,
                                text: TextSpan(
                                  children: const [
                                    TextSpan(
                                      text:
                                          "Notifications will be sent to remind user about ",
                                    ),
                                    TextSpan(
                                      text: "their own ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: "Events, Reminders, and Bills ",
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    color: sColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
