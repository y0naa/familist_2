import 'package:familist_2/screens/reminders/remindersPage.dart';
import 'package:familist_2/utils/remindersHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:jiffy/jiffy.dart';

import '../../widgets/home/homeCard.dart';

class Reminders extends StatefulWidget {
  final Function callback;
  final Function refreshParent;
  const Reminders({
    super.key,
    required this.callback,
    required this.refreshParent,
  });

  @override
  State<Reminders> createState() => _RemindersState();
}

class _RemindersState extends State<Reminders> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder(
          future: RemindersHelpers().getReminders(context),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasData) {
              List<Widget> homeCards = [];
              List<Map<String, dynamic>> allReminders = [];

              snapshot.data.forEach((userId, reminders) {
                allReminders.addAll(reminders);
              });

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
              widget.callback(allReminders[0]);

              SchedulerBinding.instance.addPostFrameCallback(
                (_) => widget.refreshParent(),
              );

              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: ListView(
                  shrinkWrap: true,
                  children: homeCards,
                ),
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
        ),
      ],
    );
  }
}
