import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:familist_2/constants.dart';
import 'package:familist_2/screens/schedule/eventsPage.dart';
import 'package:familist_2/screens/schedule/scheduleSection.dart';
import 'package:familist_2/widgets/schedule/dropdown.dart';
import 'package:familist_2/widgets/tagButton.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../widgets/schedule/dropdownTime.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  int _index = 0;
  String _initValue = "Jowna";
  var items = ["Jowna", "Musi"];

  @override
  Widget build(BuildContext context) {
    //final size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0A369D),
        child: const Icon(Icons.add),
        onPressed: () {
          showScheduleModal(context);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 64),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Schedule",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 28,
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(
              height: 20,
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: Dropdown(
                        items: items,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TagButton(
                            tapped: _index == 0 ? true : false,
                            text: "Schedule",
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
                            text: "Events",
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

                    _index == 0
                        ? const Expanded(child: Scheduler())
                        : const EventsPage(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<dynamic> showScheduleModal(BuildContext context) {
    List<String> items = ["A.M", "P.M."];
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
                      "Add Schedule",
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
                        text: "Schedule",
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
                        text: "Events",
                        onTap: () {
                          setState(() {
                            _index = 1;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 32),
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
                        left: 32, right: 32, top: 14, bottom: 24),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Input item name here",
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
                  Padding(
                    padding: const EdgeInsets.only(left: 32),
                    child: _index == 0
                        ? Text(
                            "Day",
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: sColor,
                            ),
                          )
                        : Text(
                            "Date",
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: sColor,
                            ),
                          ),
                  ),
                  _index == 0
                      ? const Center(
                          child: Dropdown(
                            items: [
                              "Monday",
                              "Tuesday",
                              "Wednesday",
                              "Thursday",
                              "Friday",
                              "Saturday",
                              "Sunday"
                            ],
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(
                              left: 32, right: 32, top: 14, bottom: 24),
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
                                borderSide: BorderSide(
                                    color: Colors.grey.shade100, width: 0.0),
                              ),
                            ),
                          ),
                        ),
                  _index == 0
                      ? Padding(
                          padding: const EdgeInsets.only(
                              left: 32, top: 24, right: 32),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Start time",
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: sColor,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.35,
                                    child: TextField(
                                      decoration: InputDecoration(
                                        prefixIcon: const Padding(
                                            padding: EdgeInsets.all(15),
                                            child: DropdownTime()),
                                        hintText: "00:00",
                                        filled: true,
                                        fillColor: Colors.grey.shade100
                                            .withOpacity(0.5),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          borderSide: BorderSide(
                                              color: Colors.grey.shade100,
                                              width: 0.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "End time",
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: sColor,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.35,
                                    child: TextField(
                                      decoration: InputDecoration(
                                        prefixIcon: const Padding(
                                            padding: EdgeInsets.all(15),
                                            child: DropdownTime()),
                                        hintText: "00:00",
                                        filled: true,
                                        fillColor: Colors.grey.shade100
                                            .withOpacity(0.5),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          borderSide: BorderSide(
                                              color: Colors.grey.shade100,
                                              width: 0.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(
                              left: 32, right: 32, bottom: 32),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Repeated in",
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: sColor,
                                ),
                              ),
                              const SizedBox(
                                height: 14,
                              ),
                              TextField(
                                decoration: InputDecoration(
                                  suffixIcon: Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Text(
                                        'Days',
                                        style: GoogleFonts.inter(
                                            fontSize: 18,
                                            color: sColor,
                                            fontWeight: FontWeight.w900),
                                      )),
                                  hintText: "Enter day(s)",
                                  filled: true,
                                  fillColor:
                                      Colors.grey.shade100.withOpacity(0.5),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade100,
                                        width: 0.0),
                                  ),
                                ),
                              ),
                            ],
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
                            onPressed: () {},
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 16, bottom: 16),
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
          ),
        );
      }),
    );
  }
}
