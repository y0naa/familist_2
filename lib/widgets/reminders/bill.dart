import 'package:familist_2/constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/remindersHelper.dart';

class Bill extends StatefulWidget {
  final String text;
  final String price;
  final String repeated;
  final String user;
  final String uid;
  final String billId;
  final bool initCompleted;
  final bool canDelete;
  final VoidCallback refresh;
  const Bill(
      {super.key,
      required this.text,
      required this.price,
      required this.repeated,
      required this.user,
      required this.uid,
      required this.billId,
      required this.initCompleted,
      required this.canDelete,
      required this.refresh});

  @override
  State<Bill> createState() => _BillState();
}

class _BillState extends State<Bill> {
  bool _flag = false;
  bool loading = false;

  Future updateCompleted() async {
    await RemindersHelpers().updateBills(widget.uid, widget.billId, _flag);
  }

  @override
  void initState() {
    super.initState();
    _flag = widget.initCompleted;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: bgColor,
      child: InkWell(
        onTap: () async {
          setState(() {
            _flag = !_flag;
          });
          await updateCompleted();
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    _flag ? "✅" : "❗",
                    style: GoogleFonts.inter(fontSize: 48),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.text,
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            color: sColor,
                            fontWeight: FontWeight.w600),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Row(
                          children: [
                            Text(
                              "Repeated in ",
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: sColor,
                              ),
                            ),
                            Text(
                              widget.repeated,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: sColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              " days",
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: sColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          widget.user,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: sColor,
                          ),
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
                                height: 30,
                                child: IconButton(
                                  onPressed: () async {
                                    await RemindersHelpers().deleteBill(
                                      context,
                                      widget.billId,
                                    );

                                    if (mounted) {
                                      GoRouter.of(context)
                                          .pushReplacement('/super');
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.delete_outline_rounded,
                                    color: Colors.red,
                                  ),
                                ),
                              )
                            : Container(),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Rp. ${widget.price}",
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
