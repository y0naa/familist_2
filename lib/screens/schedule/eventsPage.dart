// ignore_for_file: file_names

import 'package:familist_2/widgets/schedule/event.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants.dart';
import '../../utils/scheduleHelper.dart';

class EventsPage extends StatefulWidget {
  final String userId;
  const EventsPage({super.key, required this.userId});

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
            future: ScheduleHelper().getEvents(context, widget.userId),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                List<Event> eventCards = [];
                List<Map<String, dynamic>> allEvents = [];
                List<Map<String, dynamic>> events = snapshot.data;
                allEvents.addAll(events);

                for (var event in allEvents) {
                  eventCards.add(
                    Event(
                      canDelete:
                          event['userID'] == event['currentID'] ? true : false,
                      map: event,
                      refresh: () {
                        setState(() {});
                      },
                    ),
                  );
                }

                if (eventCards.isEmpty) {
                  return const Center(
                    child: Text('No events found'),
                  );
                } else {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: ListView(
                      shrinkWrap: true,
                      children: eventCards,
                    ),
                  );
                }
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
