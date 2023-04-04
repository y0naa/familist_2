// ignore_for_file: file_names, depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familist_2/utils/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'package:jiffy/jiffy.dart';
import 'package:timezone/timezone.dart' as tz;
import '../../widgets/dialog.dart';
import '../../widgets/home/home_card.dart';
import '../notif.dart';

class RemindersHelpers {
  CollectionReference users = FirebaseFirestore.instance.collection("users");

  Future deleteReminder(BuildContext context, String docID) async {
    try {
      String userID = await Profile().getUserID();
      DocumentSnapshot snapshot =
          await users.doc(userID).collection("reminders").doc(docID).get();
      if (snapshot.exists) {
        await users.doc(userID).collection("reminders").doc(docID).delete();
        await NotificationApi.cancelAll();
        NotificationApi.setAllReminders();
        if (context.mounted) {
          dialog(
            context,
            "Delete Successful",
          );
        } else {
          if (context.mounted) {
            dialog(
              context,
              "You can only delete your own items",
            );
          }
        }
      } else {}
    } catch (e) {
      dialog(context, e.toString());
    }
  }

  Future deleteBill(BuildContext context, String docID) async {
    try {
      String userID = await Profile().getUserID();
      await users.doc(userID).collection("bills").doc(docID).delete();
      await NotificationApi.cancelAll();
      NotificationApi.setAllReminders();
      if (context.mounted) {
        GoRouter.of(context).pushReplacement("/bills");
        dialog(context, "Delete Successful", route: "/bills");
      }
    } catch (e) {
      dialog(context, e.toString());
    }
  }

  Future addReminder(Map<String, dynamic> input, String uid) async {
    await users.doc(uid).collection("reminders").add(input);
    await NotificationApi.cancelAll();
    NotificationApi.setAllReminders();
  }

  Future addBill(Map<String, dynamic> input, String uid) async {
    await users.doc(uid).collection("bills").add(input);
    await NotificationApi.cancelAll();
    NotificationApi.setAllReminders();
  }

  Future updateReminder(String uid, String reminderId, bool toggle) async {
    await users
        .doc(uid)
        .collection("reminders")
        .doc(reminderId)
        .update({"completed": toggle});
  }

  Future updateBills(String uid, String billId, bool toggle) async {
    await users
        .doc(uid)
        .collection("bills")
        .doc(billId)
        .update({"completed": toggle});
  }

  Future getBills(BuildContext context) async {
    try {
      String fuid = await Profile().getFamilyID();
      String currID = await Profile().getUserID();
      CollectionReference usersRef =
          FirebaseFirestore.instance.collection('users');
      QuerySnapshot usersQuerySnapshot =
          await usersRef.where('fuid', isEqualTo: fuid).get();
      Map<String, List<Map<String, dynamic>>> billsMap = {};
      for (QueryDocumentSnapshot userDoc in usersQuerySnapshot.docs) {
        String userId = userDoc.id;
        String fullName = userDoc.get("full name");
        CollectionReference billsRef = usersRef.doc(userId).collection('bills');
        QuerySnapshot billsQuerySnapshot = await billsRef.get();
        List<Map<String, dynamic>> billsList = [];
        for (QueryDocumentSnapshot billDoc in billsQuerySnapshot.docs) {
          Map<String, dynamic> billData =
              billDoc.data() as Map<String, dynamic>;
          billData['fullName'] = fullName;
          billData['userID'] = userId;
          billData['billID'] = billDoc.id;
          billData['currentID'] = currID;
          billsList.add(billData);
        }
        billsMap[userId] = billsList;
      }
      return billsMap;
    } catch (e) {
      dialog(
        context,
        e.toString(),
      );
    }
  }

  Future getReminders(BuildContext? context) async {
    try {
      String fuid = await Profile().getFamilyID();
      String currID = await Profile().getUserID();
      CollectionReference usersRef =
          FirebaseFirestore.instance.collection('users');
      QuerySnapshot usersQuerySnapshot =
          await usersRef.where('fuid', isEqualTo: fuid).get();
      Map<String, List<Map<String, dynamic>>> remindersMap = {};
      for (QueryDocumentSnapshot userDoc in usersQuerySnapshot.docs) {
        String userId = userDoc.id;
        String fullName = userDoc.get("full name");
        CollectionReference remindersRef =
            usersRef.doc(userId).collection('reminders');
        QuerySnapshot remindersQuerySnapshot = await remindersRef.get();
        List<Map<String, dynamic>> remindersList = [];
        for (QueryDocumentSnapshot reminderDoc in remindersQuerySnapshot.docs) {
          Map<String, dynamic> reminderData =
              reminderDoc.data() as Map<String, dynamic>;
          reminderData['fullName'] = fullName;
          reminderData['userID'] = userId;
          reminderData['reminderID'] = reminderDoc.id;
          reminderData['currentID'] = currID;
          remindersList.add(reminderData);
        }
        remindersMap[userId] = remindersList;
      }
      return remindersMap;
    } catch (e) {
      if (context != null) {
        dialog(
          context,
          e.toString(),
        );
      }
    }
  }

  DateTime dateDue(Map bill) {
    if (bill["repeated in"] != "" || bill["start date"] != "") {
      int repeated = bill["repeated in"];
      DateTime startDate = DateTime.parse(
          Jiffy(bill['start date'], "dd/MM/yyyy").format("yyyy-MM-dd"));
      if (startDate.isBefore(DateTime.now())) {
        DateTime endDate = startDate.add(
          Duration(days: repeated),
        );
        print("end date: $endDate");
        if (endDate.isBefore(DateTime.now()) && endDate.isBefore(startDate)) {
          print("time to reset, end date: $endDate");
          endDate = DateTime.now().add(
            Duration(days: repeated),
          );
        }
        return endDate;
      } else {
        return startDate;
      }
    } else {
      return DateTime.parse(
        Jiffy(bill['start date'], "dd/MM/yyyy").format("yyyy-MM-dd"),
      );
    }
  }

  Future setReminderNotif() async {
    String currID = await Profile().getUserID();
    QuerySnapshot remindersSnapshot =
        await users.doc(currID).collection('reminders').where('date due').get();
    if (remindersSnapshot.docs.isNotEmpty) {
      List<DocumentSnapshot> remindersList = remindersSnapshot.docs;
      for (DocumentSnapshot reminderDoc in remindersList) {
        Map reminderData = reminderDoc.data() as Map;
        if (reminderData['completed'] == false) {
          DateTime remindersDate = DateTime.parse(
              Jiffy(reminderData['date due'], "dd/MM/yyyy")
                  .format("yyyy-MM-dd"));
          if (remindersDate.isAfter(tz.TZDateTime.now(tz.local))) {
            print('Setting Reminders Notifications...');
            print(
                "${reminderData["item name"]} Due Time: ${tz.TZDateTime.from(remindersDate, tz.local)}");
            NotificationApi.showScheduledNotification(
              id: reminderDoc.id,
              date: tz.TZDateTime.from(remindersDate, tz.local),
              channelID: "reminders",
              body: "Don't miss your task today!",
              title: reminderData['item name'],
            );
            print(
                "${reminderData["item name"]} Set Time: ${tz.TZDateTime.now(tz.local)}");
          }
        }
      }
    }
  }

  Future setBillsNotif() async {
    String currID = await Profile().getUserID();
    QuerySnapshot billsSnapshot =
        await users.doc(currID).collection('bills').where('repeated in').get();
    if (billsSnapshot.docs.isNotEmpty) {
      List<DocumentSnapshot> billsList = billsSnapshot.docs;
      for (DocumentSnapshot billDoc in billsList) {
        Map billData = billDoc.data() as Map;
        DateTime billStartDate = DateTime.parse(
            Jiffy(billData['start date'], "dd/MM/yyyy").format("yyyy-MM-dd"));
        print('Setting bills notifications... ');
        print(
            "${billData["item name"]} Due Time:${tz.TZDateTime.from(billStartDate, tz.local)}");
        NotificationApi.showRepeatingNotification(
            id: billDoc.id,
            startDate: tz.TZDateTime.from(billStartDate, tz.local),
            channelID: "bills",
            body: "Don't forget to pay your bills!",
            title: billData['item name'],
            repeated: billData['repeated in']);
        print(
            "${billData["item name"]} Set Time: ${tz.TZDateTime.now(tz.local)}");
      }
    }
  }

  FutureBuilder<dynamic> remindersFuture(
    BuildContext context,
    Function callback,
    Function refreshParent,
  ) {
    return FutureBuilder(
      future: getReminders(context),
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
                confirmDismiss: (DismissDirection direction) {
                  return confirmDismissDialog(context, () {
                    if (context.mounted) {
                      RemindersHelpers().deleteReminder(
                        context,
                        reminder['reminderID'],
                      );
                      GoRouter.of(context).pushReplacement("/reminders");
                    }
                  });
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

          SchedulerBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              callback(allReminders[0]);
              refreshParent();
              print("scheduler binding");
            }
          });

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
    );
  }
}
