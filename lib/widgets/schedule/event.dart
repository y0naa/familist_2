import 'package:familist_2/utils/modules/schedule_helper.dart';
import 'package:familist_2/widgets/dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants.dart';

class Event extends StatelessWidget {
  final Map map;
  final VoidCallback refresh;
  final bool canDelete;
  const Event({
    super.key,
    required this.refresh,
    required this.map,
    required this.canDelete,
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
                      map['date'].substring(0, 2),
                      style: GoogleFonts.inter(
                          fontSize: 36,
                          color: sColor,
                          fontWeight: FontWeight.w800),
                    ),
                    Text(
                      map['date'].substring(3, map['date'].length),
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
                      map['item name'],
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
                          map['time'],
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
                      map['fullName'],
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: sColor,
                      ),
                    ),
                  ],
                ),
                canDelete
                    ? Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () async {
                                bool delete = await deleteDialog(context);
                                if (delete) {
                                  if (context.mounted) {
                                    ScheduleHelper()
                                        .deleteEvent(context, map['eventID']);
                                    refresh();
                                  }
                                }
                              },
                              icon: const Icon(
                                Icons.delete_outline_rounded,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(),
              ])),
    );
  }
}
