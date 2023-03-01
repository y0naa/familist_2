import 'package:familist_2/utils/scheduleHelper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants.dart';

class Event extends StatelessWidget {
  final String text;
  final String date;
  final String time;
  final String docID;
  final VoidCallback refresh;
  const Event({
    super.key,
    required this.text,
    required this.date,
    required this.time,
    required this.docID,
    required this.refresh,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    date.substring(0, 2),
                    style: GoogleFonts.inter(
                        fontSize: 36,
                        color: sColor,
                        fontWeight: FontWeight.w800),
                  ),
                  Text(
                    date.substring(3, date.length),
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        color: sColor,
                        fontWeight: FontWeight.w600),
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
                    text,
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        color: sColor,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        size: 14,
                        color: sColor,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        time,
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
                  Text(
                    "Jowna",
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: sColor,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () async {
                        ScheduleHelper().deleteEvent(context, docID);
                        refresh();
                      },
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              )
            ]),
      ),
    );
  }
}
