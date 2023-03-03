import 'package:familist_2/utils/remindersHelper.dart';
import 'package:flutter/material.dart';

import '../../widgets/home/homeCard.dart';

class Reminders extends StatelessWidget {
  final VoidCallback refresh;
  const Reminders({super.key, required this.refresh});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder(
          future: RemindersHelpers().getReminders(context),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasData) {
              // Build a list of HomeCard widgets using the data from the snapshot
              List<Widget> homeCards = [];
              snapshot.data.forEach((userId, reminders) {
                reminders.forEach((reminder) {
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
                        refresh();
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
                        title: reminder['item name'],
                        deadline: reminder['date due'],
                        user: reminder['fullName'],
                        uid: reminder['userID'],
                        initCompleted: reminder['completed'],
                        reminderId: reminder['reminderID'],
                        extra: "",
                      ),
                    ),
                  );
                });
              });

              return ListView(
                shrinkWrap: true,
                children: homeCards,
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
