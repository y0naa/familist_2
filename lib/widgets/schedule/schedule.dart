import 'package:familist_2/utils/modules/schedule_helper.dart';
import 'package:familist_2/widgets/dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants.dart';

class Schedule extends StatelessWidget {
  final Map map;
  final VoidCallback refresh;
  final Function loading;
  final Function notLoading;
  final bool canDelete;
  const Schedule(
      {super.key,
      required this.refresh,
      required this.loading,
      required this.notLoading,
      required this.map,
      required this.canDelete});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              "${map["start time"]} - ${map["end time"]}",
              style: GoogleFonts.inter(
                fontSize: 14,
                color: sColor,
              ),
            ),
            const SizedBox(width: 15),
            Text(
              map["item name"],
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
              child: canDelete
                  ? IconButton(
                      onPressed: () async {
                        bool delete = await deleteDialog(context);
                        if (delete) {
                          loading();
                          if (context.mounted) {
                            await ScheduleHelper()
                                .deleteSchedule(context, map["docID"]);
                          }
                          notLoading();
                          refresh();
                        }
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                        size: 16,
                      ),
                    )
                  : Container(
                      height: 16,
                    ),
            ),
          ],
        ),
      ],
    );
  }
}
