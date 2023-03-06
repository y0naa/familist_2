import 'package:familist_2/constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
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
              Text(
                "❗",
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
                    widget.map['item name'],
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
                          "Repeated every ",
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: sColor,
                          ),
                        ),
                        Text(
                          widget.map['repeated in'].toString(),
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
                      widget.map['fullName'],
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
                      height: 20,
                    ),
                    Text(
                      "Rp. ${widget.map['price']}",
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
