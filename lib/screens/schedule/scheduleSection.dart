import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants.dart';
import '../../widgets/schedule/date.dart';
import '../../widgets/schedule/schedule.dart';

class Scheduler extends StatefulWidget {
  const Scheduler({super.key});

  @override
  State<Scheduler> createState() => _SchedulerState();
}

class _SchedulerState extends State<Scheduler> {
  var days_name = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];
  var days_short = [
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
    "Sun",
  ];

  int _days = 0;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(70),
                  topRight: Radius.circular(70),
                ),
              ),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                  //set border radius more than 50% of height and width to make circle
                ),
                elevation: 12,
                child: Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 15, bottom: 10),
                        child: Text(
                          "Days in week",
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: sColor,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Date(
                            day: "Mon",
                            initial: "M",
                            tapped: _days == 0 ? true : false,
                            ontap: () {
                              setState(() {
                                _days = 0;
                              });
                            },
                          ),
                          Date(
                            day: "Tue",
                            initial: "T",
                            tapped: _days == 1 ? true : false,
                            ontap: () {
                              setState(() {
                                _days = 1;
                              });
                            },
                          ),
                          Date(
                            day: "Wed",
                            initial: "W",
                            tapped: _days == 2 ? true : false,
                            ontap: () {
                              setState(() {
                                _days = 2;
                              });
                            },
                          ),
                          Date(
                            day: "Thu",
                            initial: "T",
                            tapped: _days == 3 ? true : false,
                            ontap: () {
                              setState(() {
                                _days = 3;
                              });
                            },
                          ),
                          Date(
                            day: "Fri",
                            initial: "F",
                            tapped: _days == 4 ? true : false,
                            ontap: () {
                              setState(() {
                                _days = 4;
                              });
                            },
                          ),
                          Date(
                            day: "Sat",
                            initial: "S",
                            tapped: _days == 5 ? true : false,
                            ontap: () {
                              setState(() {
                                _days = 5;
                              });
                            },
                          ),
                          Date(
                            day: "Sun",
                            initial: "S",
                            tapped: _days == 6 ? true : false,
                            ontap: () {
                              setState(() {
                                _days = 6;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(56),
                topRight: Radius.circular(56),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 32, top: 24, right: 36),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        days_name[_days],
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: sColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        days_short[_days],
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: sColor,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Container(
                      height: 1,
                      width: size.width,
                      color: sColor,
                    ),
                  ),
                  const Schedule(time: "09:00 - 12:00", title: "Kuliah"),
                  const Schedule(time: "12:00 - 13:00", title: "Makan"),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
