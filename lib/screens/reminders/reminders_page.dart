import 'package:familist_2/constants.dart';
import 'package:familist_2/screens/reminders/bills_section.dart';
import 'package:familist_2/screens/reminders/reminders_section.dart';
import 'package:familist_2/utils/modules/reminders_helper.dart';
import 'package:familist_2/widgets/tag_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../utils/profile.dart';
import '../../widgets/dialog.dart';

class RemindersPage extends StatefulWidget {
  final int? pageIndex;
  const RemindersPage({super.key, this.pageIndex});
  @override
  State<RemindersPage> createState() => _RemindersPageState();
}

class _RemindersPageState extends State<RemindersPage> {
  // Variables
  bool loading = false;
  Widget remindersList = Container();
  bool isCardSet = false;
  int _index = 0;
  String uid = "";
  Map<String, dynamic> topCard = {};

  void getTopCardDetails(Map<String, dynamic> card) {
    // to break infintie loop of setState
    print("top card here");
    if (topCard.isEmpty) {
      isCardSet = false;
    } else {
      isCardSet = true;
    }
    topCard = card;
  }

  // text controllers
  DateTime date = DateTime.now();
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _dateDueController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _repeatedInController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();

  // Futures
  Future addReminder() async {
    try {
      if (_itemNameController.text.trim().isEmpty ||
          _dateDueController.text.trim().isEmpty) {
        if (_index == 0) {
          if (_dateDueController.text.trim().isEmpty) {
            dialog(context, "Please enter all fields");
            return false;
          }
        }
      } else {
        RemindersHelpers().addReminder({
          "item name": _itemNameController.text.trim(),
          "date due": _dateDueController.text.trim(),
          "completed": false,
        }, uid);
        if (context.mounted) {
          dialog(
            context,
            "Saved Successfully",
            route: "/reminders",
          );
        }
      }
    } catch (e) {
      dialog(context, e.toString());
    }
  }

  Future addBill() async {
    try {
      if (_itemNameController.text.trim().isEmpty ||
          _priceController.text.trim().isEmpty ||
          _repeatedInController.text.trim().isEmpty ||
          _startDateController.text.trim().isEmpty) {
        dialog(context, "Please enter all fields");
        return false;
      } else {
        RemindersHelpers().addBill({
          "item name": _itemNameController.text.trim(),
          "price": _priceController.text.trim(),
          "start date": _startDateController.text.trim(),
          "repeated in": int.tryParse(_repeatedInController.text.trim()) ?? -1,
        }, uid);
        if (context.mounted) {
          dialog(
            context,
            "Saved Successfully",
            route: "/bills",
          );
        }
      }
    } catch (e) {
      dialog(context, e.toString());
    }
  }

  // * Other Methods
  void getRemindersList() {
    loading = true;
    remindersList =
        RemindersHelpers().remindersFuture(context, getTopCardDetails, () {
      setState(() {
        loading = false;
      });
    });
  }

  void getUid() async {
    uid = await Profile().getUserID();
  }

  int dayDifference(String startDate) {
    String day = startDate.substring(0, 2);
    String month = startDate.substring(3, 5);
    String year = startDate.substring(6, startDate.length);
    DateTime dt = DateTime.parse("$year-$month-$day");
    DateTime now = DateTime.now();
    return dt.difference(now).inDays;
  }

  // * built in methods
  @override
  void initState() {
    super.initState();

    getRemindersList();
    widget.pageIndex == null ? null : _index = widget.pageIndex!;
    getUid();
  }

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
      body: loading
          ? Container(
              height: double.infinity,
              color: bgColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Opacity(opacity: 0.0, child: remindersList),
                  const CircularProgressIndicator(),
                ],
              ),
            )
          : Padding(
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
                                    padding:
                                        EdgeInsets.only(top: size.height * 0.1),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                    padding: const EdgeInsets.only(
                                        left: 24, right: 24),
                                    child:
                                        // separate widget
                                        _index == 0
                                            ? Reminders(
                                                list: remindersList,
                                              )
                                            : Bills(
                                                refresh: () {
                                                  setState(() {});
                                                },
                                              ),
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
                                padding:
                                    const EdgeInsets.only(left: 24, right: 24),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const CircleAvatar(
                                      backgroundColor: pColor,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 32, bottom: 32),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            topCard["item name"] ?? "",
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
                                                topCard["date due"] ?? "",
                                                style: GoogleFonts.inter(
                                                  fontSize: 14,
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            topCard["fullName"] ?? "",
                                            style: GoogleFonts.inter(
                                              fontSize: 14,
                                              color: pColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 32, bottom: 32),
                                      child: Column(
                                        children: [
                                          Text(
                                            topCard["date due"] != null
                                                ? dayDifference(
                                                        topCard["date due"])
                                                    .toString()
                                                : "",
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
                    child: Text(
                      _index == 0 ? "Date due" : "Item price",
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: sColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 32, right: 32, top: 14, bottom: 32),
                    child: _index == 0
                        ? TextField(
                            controller: _dateDueController,
                            readOnly: true,
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(99999999),
                              );
                              if (pickedDate != null) {
                                _dateDueController.text =
                                    DateFormat("dd/MM/yyyy").format(pickedDate);
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
                              fillColor: Colors.grey.shade100.withOpacity(0.5),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                    color: Colors.grey.shade100, width: 0.0),
                              ),
                            ),
                          )
                        : TextField(
                            keyboardType: TextInputType.number,
                            controller: _priceController,
                            decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Text(
                                  'Rp.',
                                  style: GoogleFonts.inter(
                                      fontSize: 18,
                                      color: sColor,
                                      fontWeight: FontWeight.w900),
                                ),
                              ),
                              hintText: "Enter item price",
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
                  _index == 1
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 32),
                              child: Text(
                                "Start date",
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
                                controller: _startDateController,
                                readOnly: true,
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(99999999),
                                  );
                                  if (pickedDate != null) {
                                    _startDateController.text =
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
                          ],
                        )
                      : Container(),
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
                                controller: _repeatedInController,
                                keyboardType: TextInputType.number,
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
                                        color: Colors.grey.shade100,
                                        width: 0.0),
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
                            onPressed: _index == 0
                                ? () async {
                                    await addReminder();
                                  }
                                : () async {
                                    await addBill();
                                  },
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 16, bottom: 16),
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
