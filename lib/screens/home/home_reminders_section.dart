import 'package:familist_2/widgets/home/home_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';

import '../../utils/modules/reminders_helper.dart';

class HomeReminders extends StatefulWidget {
  const HomeReminders({super.key});

  @override
  State<HomeReminders> createState() => _HomeRemindersState();
}

class _HomeRemindersState extends State<HomeReminders> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: RemindersHelpers().getReminders(context),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          List<Widget> homeCards = [];
          List<Map<String, dynamic>> allReminders = [];

          snapshot.data.forEach((userId, reminders) {
            allReminders.addAll(reminders);
          });

          if (allReminders.isEmpty) {
            return Center(
              child: Text(
                "No items found",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }

          allReminders = allReminders
              .where((item) => item['userID'] == item['currentID'])
              .toList();
          allReminders.sort((a, b) {
            if (a["completed"] == b["completed"]) {
              DateTime aDateDue = DateTime.parse(
                  Jiffy(a['date due'], "dd/MM/yyyy").format("yyyy-MM-dd"));
              DateTime bDateDue = DateTime.parse(
                  Jiffy(b['date due'], "dd/MM/yyyy").format("yyyy-MM-dd"));
              return aDateDue.compareTo(bDateDue);
            }
            return a["completed"] ? 1 : -1;
          });

          for (var reminder in allReminders) {
            homeCards.add(
              HomeCard(
                home: true,
                shoppingList: false,
                map: reminder,
                title: reminder['item name'],
                initCompleted: reminder['completed'],
                extra: "",
              ),
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            itemCount: homeCards.length > 5 ? 5 : homeCards.length,
            itemBuilder: (BuildContext context, int index) {
              return homeCards[index];
            },
          );
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
    );
  }
}
