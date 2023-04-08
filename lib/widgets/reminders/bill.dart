// ignore_for_file: use_build_context_synchronously

import 'package:familist_2/constants.dart';
import 'package:familist_2/widgets/dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../utils/currency.dart';
import '../../utils/modules/reminders_helper.dart';

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
  int calculateDaysLeft() {
    if (widget.map["repeated in"] != "" || widget.map["start date"] != "") {
      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day);
      DateTime dd = RemindersHelpers().dateDue(widget.map);
      int res = dd.difference(today).inDays;
      if (res < 0) {
        dd = DateTime.now().add(
          Duration(days: widget.map["repeated in"]),
        );
      }
      return dd.difference(today).inDays;
    }
    return -1;
  }

  void togglePaid(bool paid) async {
    await RemindersHelpers()
        .togglePaidBills(widget.map['userID'], widget.map, paid);
    GoRouter.of(context).pushReplacement("/bills");
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
        onTap: () {
          setState(() {
            if (widget.map['paid']) {
              togglePaid(false);
            } else {
              togglePaid(true);
            }
          });
        },
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
                      color: calculateDaysLeft() < 0 ? Colors.red : tColor,
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
                        DateFormat('dd/MM/yyyy')
                            .format(
                              RemindersHelpers().dateDue(widget.map),
                            )
                            .toString(),
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
                        ? IconButton(
                            padding: const EdgeInsets.only(left: 25),
                            onPressed: () async {
                              bool delete = await deleteDialog(context);
                              if (delete) {
                                if (context.mounted) {
                                  await RemindersHelpers().deleteBill(
                                    context,
                                    widget.map['billID'],
                                  );
                                  GoRouter.of(context)
                                      .pushReplacement("/bills");
                                }
                              }
                            },
                            icon: const Icon(
                              Icons.delete_outline_rounded,
                              color: Colors.red,
                            ),
                          )
                        : Container(),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      widget.map['paid'] ? "Paid" : "Unpaid",
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          color: widget.map['paid'] ? Colors.green : Colors.red,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 10,
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
