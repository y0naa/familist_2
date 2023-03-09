import 'package:familist_2/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import '../../utils/currency.dart';
import '../../utils/remindersHelper.dart';

// ignore: todo
// TODO: add deadline date

class Bill extends StatefulWidget {
  final Map map;
  final bool canDelete;
  final Function() refresh;

  const Bill({
    super.key,
    required this.canDelete,
    required this.refresh,
    required this.map,
  });

  @override
  State<Bill> createState() => _BillState();
}

class _BillState extends State<Bill> {
  bool loading = false;

  DateTime dateDue() {
    if (widget.map["repeated in"] != "" || widget.map["start date"] != "") {
      int repeated = widget.map["repeated in"];
      DateTime startDate = DateTime.parse(
          Jiffy(widget.map['start date'], "dd/MM/yyyy").format("yyyy-MM-dd"));
      DateTime endDate = startDate.add(Duration(days: repeated));
      return endDate;
    } else {
      return DateTime.parse(
          Jiffy(widget.map['start date'], "dd/MM/yyyy").format("yyyy-MM-dd"));
    }
  }

  int calculateDaysLeft() {
    if (widget.map["repeated in"] != "" || widget.map["start date"] != "") {
      DateTime dd = dateDue();

      return dd.difference(DateTime.now()).inDays;
    }
    return -1;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: bgColor,
      child: InkWell(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(children: [
              Column(
                children: [
                  Text(
                    calculateDaysLeft().toString(),
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
                  Row(
                    children: [
                      const Icon(
                        Icons.alarm,
                        color: Colors.red,
                        size: 14,
                      ),
                      Text(
                        DateFormat('dd/MM/yyyy').format(dateDue()).toString(),
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.map['item name'],
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        color: sColor,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text(
                        "From: ",
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            color: sColor,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        widget.map['start date'],
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: sColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      "Every: ${widget.map['repeated in']} day(s)",
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: tColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      widget.map['fullName'],
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          color: tColor,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    widget.canDelete
                        ? SizedBox(
                            height: 20,
                            width: 25,
                            child: IconButton(
                              onPressed: () async {
                                await RemindersHelpers().deleteBill(
                                  context,
                                  widget.map['billID'],
                                );
                              },
                              icon: const Icon(
                                Icons.delete_outline_rounded,
                                color: Colors.red,
                              ),
                            ),
                          )
                        : Container(),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      Currency.convertToIdr(
                          double.tryParse(widget.map['price'].toString()) ?? 0),
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: sColor,
                      ),
                    ),
                  ],
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
