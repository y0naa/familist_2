import 'package:familist_2/constants.dart';
import 'package:familist_2/screens/reminders/bills.dart';
import 'package:familist_2/screens/reminders/reminders.dart';
import 'package:familist_2/widgets/tagButton.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class RemindersPage extends StatefulWidget {
  const RemindersPage({super.key});

  @override
  State<RemindersPage> createState() => _RemindersPageState();
}

class _RemindersPageState extends State<RemindersPage> {
  int _index = 0;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0A369D),
        child: const Icon(Icons.add),
        onPressed: () {
          showRemindersModal(context);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 64),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Reminders",
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
                              padding: EdgeInsets.only(top: size.height * 0.1),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TagButton(
                                    tapped: _index == 0 ? true : false,
                                    text: "Reminders",
                                    onTap: () {
                                      setState(() {
                                        _index = 0;
                                      });
                                    },
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  TagButton(
                                    tapped: _index == 1 ? true : false,
                                    text: "Bills",
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
                              padding:
                                  const EdgeInsets.only(left: 24, right: 24),
                              child:
                                  // separate widget
                                  _index == 0
                                      ? const Reminders()
                                      : const Bills(),
                            ),
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
                      height: size.height * 0.17,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                          //set border radius more than 50% of height and width to make circle
                        ),
                        elevation: 12,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 24, right: 24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const CircleAvatar(
                                backgroundColor: pColor,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 32, bottom: 32),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Buang Sampah",
                                      style: GoogleFonts.inter(
                                        fontSize: 16,
                                        color: pColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.alarm,
                                          color: Colors.red,
                                          size: 14,
                                        ),
                                        Text(
                                          " 13 Jan 2023",
                                          style: GoogleFonts.inter(
                                            fontSize: 14,
                                            color: Colors.red,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "Jowna",
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        color: pColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 32, bottom: 32),
                                child: Column(
                                  children: [
                                    Text(
                                      "235",
                                      style: GoogleFonts.inter(
                                        fontSize: 42,
                                        color: tColor,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    Text(
                                      "Day(s) left",
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        color: tColor,
                                      ),
                                    ),
                                  ],
                                ),
                              )
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

  Future<dynamic> showRemindersModal(BuildContext context) {
    return showBarModalBottomSheet(
      context: context,
      builder: (context) =>
          StatefulBuilder(builder: (BuildContext context, setState) {
        return SingleChildScrollView(
          controller: ModalScrollController.of(context),
          child: Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "Create an item",
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TagButton(
                      tapped: _index == 0 ? true : false,
                      text: "Reminders",
                      onTap: () {
                        setState(() {
                          _index = 0;
                        });
                      },
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    TagButton(
                      tapped: _index == 1 ? true : false,
                      text: "Bills",
                      onTap: () {
                        setState(() {
                          _index = 1;
                        });
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15, left: 32),
                  child: Text(
                    "Item name",
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: sColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 32, right: 32, top: 14, bottom: 32),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Input item name here",
                      filled: true,
                      fillColor: Colors.grey.shade100.withOpacity(0.5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide:
                            BorderSide(color: Colors.grey.shade100, width: 0.0),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 32),
                  child: Text(
                    "Date due",
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: sColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 32, right: 32, top: 14, bottom: 32),
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: const Padding(
                        padding: EdgeInsets.all(15),
                        child: Icon(
                          Icons.calendar_month,
                          color: sColor,
                        ),
                      ),
                      hintText: "dd/mm/yyyy",
                      filled: true,
                      fillColor: Colors.grey.shade100.withOpacity(0.5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide:
                            BorderSide(color: Colors.grey.shade100, width: 0.0),
                      ),
                    ),
                  ),
                ),
                _index == 1
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 32),
                            child: Text(
                              "Repeated in",
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: sColor,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 32, right: 32, top: 14, bottom: 32),
                            child: TextField(
                              decoration: InputDecoration(
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Text(
                                    "Days",
                                    style: GoogleFonts.inter(
                                        fontSize: 18,
                                        color: sColor,
                                        fontWeight: FontWeight.w900),
                                  ),
                                ),
                                hintText: "Enter number of days",
                                filled: true,
                                fillColor:
                                    Colors.grey.shade100.withOpacity(0.5),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                      color: Colors.grey.shade100, width: 0.0),
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    : Container(),
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
                          onPressed: () {},
                          child: Padding(
                            padding: const EdgeInsets.only(top: 16, bottom: 16),
                            child: Text(
                              "Done",
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
        );
      }),
    );
  }
}