import 'package:familist_2/utils/scheduleHelper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants.dart';

class Schedule extends StatelessWidget {
  final String time;
  final String title;
  final String docID;
  final VoidCallback refresh;
  final Function loading;
  final Function notLoading;
  const Schedule(
      {super.key,
      required this.time,
      required this.title,
      required this.docID,
      required this.refresh,
      required this.loading,
      required this.notLoading});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              time,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: sColor,
              ),
            ),
            const SizedBox(width: 15),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: sColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        Row(
          children: [
            SizedBox(
              width: 20,
              child: IconButton(
                onPressed: () async {
                  loading();
                  await ScheduleHelper().deleteSchedule(context, docID);
                  notLoading();
                  refresh();
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
