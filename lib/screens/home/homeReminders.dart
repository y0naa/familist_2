import 'package:familist_2/widgets/home/homeCard.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jiffy/jiffy.dart';

import '../../utils/remindersHelper.dart';

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
              Dismissible(
                key: Key(reminder['item name']),
                direction: reminder['userID'] == reminder['currentID']
                    ? DismissDirection.endToStart
                    : DismissDirection.none,
                onDismissed: (direction) {
                  RemindersHelpers().deleteReminder(
                    context,
                    reminder['reminderID'],
                  );
                  GoRouter.of(context).pushReplacement("/reminders");
                },
                background: Container(
                  color: Colors.red,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.delete, color: Colors.white),
                      SizedBox(width: 16),
                    ],
                  ),
                ),
                secondaryBackground: Container(
                  color: Colors.red,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.delete, color: Colors.white),
                      SizedBox(width: 16),
                    ],
                  ),
                ),
                child: HomeCard(
                  home: false,
                  shoppingList: false,
                  map: reminder,
                  title: reminder['item name'],
                  initCompleted: reminder['completed'],
                  extra: "",
                ),
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
