import 'package:familist_2/widgets/reminders/event.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants.dart';
import '../../utils/scheduleHelper.dart';
import '../../widgets/dialog.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
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
          FutureBuilder(
            future: ScheduleHelper().getEvents(context),
            builder: ((context, snapshot) {
              try {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    if (snapshot.data != null) {
                      final events = snapshot.data!;
                      return events.length > 0
                          ? SingleChildScrollView(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  itemCount: events.length,
                                  itemBuilder: (context, index) {
                                    final event = events[index];
                                    return ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        title: Event(
                                          refresh: () {
                                            setState(() {});
                                          },
                                          docID: event["docID"],
                                          text: event["item name"],
                                          date: event["date"],
                                          time: event["time"],
                                        ));
                                  }),
                            )
                          : const Center(child: Text("No Data Found"));
                    } else {
                      return const Center(child: Text("No Data Found"));
                    }
                  }
                }
              } catch (e) {
                dialog(context, e.toString());
              }
              return const Center(child: Text("Loading..."));
            }),
          ),
          // const Event(
          //     text: "Konser Kufaku", date: "15 Jan 2023", time: "2:45 p.m."),
          // const Event(
          //     text: "Konser Kufaku", date: "15 Jan 2023", time: "2:45 p.m."),
          // const Event(
          //     text: "Konser Kufaku", date: "15 Jan 2023", time: "2:45 p.m."),
        ],
      ),
    );
  }
}
