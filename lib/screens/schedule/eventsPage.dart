import 'package:familist_2/widgets/reminders/event.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants.dart';

class EventsPage extends StatelessWidget {
  const EventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 24,
        right: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Upcoming Events",
            style: GoogleFonts.inter(
              fontSize: 14,
              color: sColor,
            ),
            textAlign: TextAlign.left,
          ),
          const Event(
              text: "Konser Kufaku", date: "15 Jan 2023", time: "2:45 p.m."),
          const Event(
              text: "Konser Kufaku", date: "15 Jan 2023", time: "2:45 p.m."),
          const Event(
              text: "Konser Kufaku", date: "15 Jan 2023", time: "2:45 p.m."),
        ],
      ),
    );
  }
}
