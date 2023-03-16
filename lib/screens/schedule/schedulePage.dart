import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:familist_2/constants.dart';
import 'package:familist_2/screens/schedule/eventsPage.dart';
import 'package:familist_2/screens/schedule/scheduleSection.dart';
import 'package:familist_2/widgets/dialog.dart';
import 'package:familist_2/widgets/schedule/dropdown.dart';
import 'package:familist_2/widgets/tagButton.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../utils/profile.dart';
import '../../utils/scheduleHelper.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  bool loading = false;
  int _index = 0;
  List<String> items = ["Loading..."];
  Map<String, dynamic> members = {};
  String uid = "";
  String userid = "xxxxxxxxxx"; // dummy data first
  CollectionReference users = FirebaseFirestore.instance.collection("users");

  // text controllers - schedule
  String daySchedule = "";
  DateTime date = DateTime.now();
  //DateTime time = DateTime.now();
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  // Methods

  Future getMembers() async {
    print("get members");
    String fuid = await Profile().getFamilyID();
    QuerySnapshot snapshot = await users.where("fuid", isEqualTo: fuid).get();
    List<String> memberNames = [];

    for (QueryDocumentSnapshot doc in snapshot.docs) {
      String name = doc.get("full name");
      members[name] = doc.id;
      memberNames.add(name);
    }
    return memberNames;
  }

  Future addSchedule() async {
    try {
      DateTime start =
          DateTime.parse("2000-01-01 ${_startTimeController.text.trim()}:00");
      DateTime end =
          DateTime.parse("2000-01-01 ${_endTimeController.text.trim()}:00");
      if (start.compareTo(end) < 0) {
        ScheduleHelper().addSchedule({
          "item name": _itemNameController.text.trim(),
          "day": daySchedule.trim() == "" ? "Monday" : daySchedule.trim(),
          "start time": _startTimeController.text.trim(),
          "end time": _endTimeController.text.trim(),
        }, uid);

        dialog(context, "Data saved successfully");
        Navigator.of(context).pop();
      } else {
        throw Exception("Start time must be before  end time");
      }
    } catch (e) {
      dialog(context, e.toString());
    }
  }

  Future addEvent() async {
    try {
      String dateCut = DateFormat("yyyy-MM-dd").format(date);
      DateTime picked =
          DateTime.parse("$dateCut ${_timeController.text.trim()}:59");
      if (picked.compareTo(DateTime.now()) > 0) {
        ScheduleHelper().addEvent({
          "item name": _itemNameController.text.trim(),
          "date": _dateController.text.trim(),
          "time": _timeController.text.trim(),
        }, uid);
        dialog(context, "Data saved successfully");
      } else {
        throw Exception("Please enter a valid time and date");
      }

      dialog(context, "Data saved successfully");
    } catch (e) {
      dialog(context, e.toString());
      print("tes")
    }
  }

  void getUid() async {
    userid = await Profile().getUserID();
    uid = await Profile().getUserID();
    setState(() {}); // refresh to insert value
  }

  @override
  void initState() {
    super.initState();
    getUid();
  }

  @override
  Widget build(BuildContext context) {
    //final size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0A369D),
        child: const Icon(Icons.add),
        onPressed: () {
          showScheduleModal();
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
                      child: FutureBuilder(
                        future: getMembers(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final items = snapshot.data as List<String?>;
                            final itemValues = items
                                .where((item) => item != null)
                                .map((item) => item!)
                                .toList();
                            return Dropdown(
                              isFuture: true,
                              onChanged: (value) {
                                if (mounted) {
                                  setState(() {
                                    userid = members[value];
                                    print("user id dd: $userid");
                                  });
                                }
                              },
                              items: itemValues,
                            );
                          } else if (snapshot.hasError) {
                            return Text("Error: ${snapshot.error}");
                          } else {
                            return const Text("Loading...");
                          }
                        },
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
                              print("user id schedule: $userid");
                              if (mounted) {
                                setState(() {
                                  _index = 0;
                                });
                              }
                            },
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          TagButton(
                            tapped: _index == 1 ? true : false,
                            text: "Events",
                            onTap: () {
                              print("user id events: $userid");
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

                    _index == 0
                        ? Expanded(
                            child: Scheduler(
                              userID: userid,
                            ),
                          )
                        : EventsPage(userId: userid),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<dynamic> showScheduleModal() {
    return showBarModalBottomSheet(
      context: context,
      builder: (ctx) =>
          StatefulBuilder(builder: (BuildContext context, setState) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            controller: ModalScrollController.of(context),
            child: loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Padding(
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
                                if (mounted) {
                                  setState(() {
                                    _index = 0;
                                  });
                                }
                              },
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            TagButton(
                              tapped: _index == 1 ? true : false,
                              text: "Events",
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
                            controller: _itemNameController,
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
                            ? Center(
                                child: Dropdown(
                                  isFuture: false,
                                  onChanged: (value) {
                                    print("day picked: $value");

                                    daySchedule = value;
                                  },
                                  items: const [
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
                                  controller: _dateController,
                                  readOnly: true,
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime(99999999),
                                    );
                                    if (pickedDate != null) {
                                      _dateController.text =
                                          DateFormat("dd/MM/yyyy")
                                              .format(pickedDate);
                                      date = pickedDate;
                                    }
                                  },
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
                              ),
                        _index == 0
                            ? Padding(
                                padding: const EdgeInsets.only(
                                    left: 32, top: 24, right: 32),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.35,
                                          child: TextField(
                                            readOnly: true,
                                            onTap: () async {
                                              TimeOfDay? pickedTime =
                                                  await showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay.now(),
                                              );

                                              if (pickedTime != null &&
                                                  context.mounted) {
                                                _startTimeController.text =
                                                    pickedTime.format(context);
                                              }
                                            },
                                            controller: _startTimeController,
                                            decoration: InputDecoration(
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.35,
                                          child: TextField(
                                            controller: _endTimeController,
                                            readOnly: true,
                                            onTap: () async {
                                              TimeOfDay? pickedTime =
                                                  await showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay.now(),
                                              );

                                              if (pickedTime != null &&
                                                  context.mounted) {
                                                _endTimeController.text =
                                                    pickedTime.format(context);
                                              }
                                            },
                                            decoration: InputDecoration(
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
                                      "Time",
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        color: sColor,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 14,
                                    ),
                                    TextField(
                                      controller: _timeController,
                                      readOnly: true,
                                      onTap: () async {
                                        TimeOfDay? pickedTime =
                                            await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        );

                                        if (pickedTime != null &&
                                            context.mounted) {
                                          _timeController.text =
                                              pickedTime.format(context);
                                        }
                                      },
                                      decoration: InputDecoration(
                                        prefixIcon: const Padding(
                                          padding: EdgeInsets.all(15),
                                          child: Icon(
                                            Icons.alarm_rounded,
                                            color: sColor,
                                          ),
                                        ),
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
                                    backgroundColor:
                                        MaterialStatePropertyAll<Color>(
                                      const Color(0xFF0A369D).withOpacity(0.8),
                                    ),
                                  ),
                                  onPressed: _index == 0
                                      ? () async {
                                          await addSchedule();

                                          if (context.mounted) {
                                            GoRouter.of(context)
                                                .pushReplacement("/schedule");
                                          }
                                        }
                                      : () async {
                                          await addEvent();
                                          if (context.mounted) {
                                            GoRouter.of(context)
                                                .pushReplacement("/schedule");
                                          }
                                        },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 16, bottom: 16),
                                    child: Text(
                                      "Save",
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
