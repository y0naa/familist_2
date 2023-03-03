import 'package:familist_2/constants.dart';
import 'package:familist_2/utils/remindersHelper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeCard extends StatefulWidget {
  final String title;
  final String extra;
  final bool shoppingList;
  final bool home;
  final bool? initCompleted;
  final String? deadline;
  final String? user;
  final String? uid;
  final String? reminderId;
  const HomeCard(
      {super.key,
      required this.title,
      required this.shoppingList,
      required this.extra,
      this.deadline,
      this.user,
      this.uid,
      this.reminderId,
      this.initCompleted,
      required this.home});

  @override
  State<HomeCard> createState() => _HomeCardState();
}

class _HomeCardState extends State<HomeCard> {
  bool _flag = false;
  bool loading = false;
  Future updateCompleted() async {
    if (widget.uid != null && widget.reminderId != null) {
      await RemindersHelpers()
          .updateReminder(widget.uid!, widget.reminderId!, _flag);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _flag = widget.initCompleted ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: bgColor,
      child: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : InkWell(
              onTap: () async {
                setState(() {
                  _flag = !_flag;
                });
                await updateCompleted();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _flag
                      ? Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF00B828).withOpacity(0.22),
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Color(0xFF00B828),
                          ),
                        )
                      : Container(
                          height: 10,
                          width: 45,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                widget.shoppingList ? Colors.green : Colors.red,
                          ),
                        ),
                  const SizedBox(
                    width: 25,
                  ),
                  Expanded(
                    child: Card(
                      shadowColor: Colors.black,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.title,
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  color: sColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 15),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    widget.user ?? "", // change to user
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: sColor,
                                    ),
                                  ),
                                  widget.shoppingList
                                      ? Text(
                                          "Rp. ${widget.extra}",
                                          style: GoogleFonts.inter(
                                            fontSize: 14,
                                            color: sColor,
                                          ),
                                        )
                                      : Row(
                                          children: [
                                            const Icon(
                                              Icons.alarm,
                                              color: Colors.red,
                                              size: 14,
                                            ),
                                            Text(
                                              widget.deadline ?? "",
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
                            ]),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
