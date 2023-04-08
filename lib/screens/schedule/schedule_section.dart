import 'package:familist_2/utils/modules/schedule_helper.dart';
import 'package:familist_2/widgets/dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants.dart';
import '../../utils/profile.dart';
import '../../widgets/schedule/date.dart';
import '../../widgets/schedule/schedule.dart';

class Scheduler extends StatefulWidget {
  final String userID;
  const Scheduler({super.key, required this.userID});

  @override
  State<Scheduler> createState() => _SchedulerState();
}

class _SchedulerState extends State<Scheduler> {
  String currentID = "";
  bool loading = false;
  int _days = 0;
  List schedules = [];

  void getCurrentID() async {
    String id = await Profile.getUserID();
    if (mounted) {
      setState(() {
        currentID = id;
      });
    }
  }

  List<Map<String, dynamic>> filterMap(List<Map<String, dynamic>> schedules) {
    List<Map<String, dynamic>> filtered = [];
    if (_days == 0) {
      filtered =
          schedules.where((schedule) => schedule["day"] == "Monday").toList();
    } else if (_days == 1) {
      filtered =
          schedules.where((schedule) => schedule["day"] == "Tuesday").toList();
    } else if (_days == 2) {
      filtered = schedules
          .where((schedule) => schedule["day"] == "Wednesday")
          .toList();
    } else if (_days == 3) {
      filtered =
          schedules.where((schedule) => schedule["day"] == "Thursday").toList();
    } else if (_days == 4) {
      filtered =
          schedules.where((schedule) => schedule["day"] == "Friday").toList();
    } else if (_days == 5) {
      filtered =
          schedules.where((schedule) => schedule["day"] == "Saturday").toList();
    } else if (_days == 6) {
      filtered =
          schedules.where((schedule) => schedule["day"] == "Sunday").toList();
    }
    return filtered;
  }

  @override
  void initState() {
    super.initState();
    getCurrentID();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return loading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Column(
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
                      ),
                      elevation: 12,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 24, right: 24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 15, bottom: 10),
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
                    padding:
                        const EdgeInsets.only(left: 32, top: 24, right: 36),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              daysName[_days],
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: sColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              daysShort[_days],
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
                        FutureBuilder(
                          future: ScheduleHelper()
                              .getSchedules(context, widget.userID),
                          builder: ((context, snapshot) {
                            try {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  if (snapshot.data != null) {
                                    final schedules = snapshot.data!;
                                    final filtered = filterMap(schedules);
                                    filtered.sort((a, b) {
                                      DateTime aTime = DateTime.parse(
                                          '2021-02-17 ${a['start time']}');
                                      DateTime bTime = DateTime.parse(
                                          '2021-02-17 ${b['start time']}');
                                      return aTime.compareTo(bTime);
                                    });

                                    return SizedBox(
                                      height: size.height * 0.35,
                                      child: filtered.isNotEmpty
                                          ? ListView.builder(
                                              shrinkWrap: true,
                                              padding: EdgeInsets.zero,
                                              itemCount: filtered.length,
                                              itemBuilder: (context, index) {
                                                final schedule =
                                                    filtered[index];
                                                return Schedule(
                                                  canDelete:
                                                      widget.userID == currentID
                                                          ? true
                                                          : false,
                                                  map: schedule,
                                                  loading: () {
                                                    setState(() {
                                                      loading = true;
                                                    });
                                                  },
                                                  notLoading: () {
                                                    setState(() {
                                                      loading = false;
                                                    });
                                                  },
                                                  refresh: () {
                                                    setState(() {});
                                                  },
                                                );
                                              })
                                          : const Center(
                                              child: Text("No Data Found")),
                                    );
                                  } else {
                                    return const Center(
                                        child: Text("No Data Found"));
                                  }
                                }
                              }
                            } catch (e) {
                              dialog(context, e.toString());
                            }
                            return const Center(child: Text("Loading..."));
                          }),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
  }
}
