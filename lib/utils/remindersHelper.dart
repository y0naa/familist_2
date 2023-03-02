import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familist_2/utils/profile.dart';
import 'package:flutter/material.dart';

import '../widgets/dialog.dart';

class RemindersHelpers {
  CollectionReference users = FirebaseFirestore.instance.collection("users");

  Future addReminder(Map<String, dynamic> input, String uid) async {
    await users.doc(uid).collection("reminders").add(input);
  }

  Future addBill(Map<String, dynamic> input, String uid) async {
    await users.doc(uid).collection("bills").add(input);
  }

  Future getReminders(BuildContext context) async {
    try {
      CollectionReference usersRef =
          FirebaseFirestore.instance.collection('users');
      QuerySnapshot usersQuerySnapshot = await usersRef.get();
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
          reminderData['fullName'] = fullName; // add fullName to the map
          remindersList.add(reminderData);
        }
        remindersMap[userId] = remindersList;
      }
      print(remindersMap);
      return remindersMap;
    } catch (e) {
      dialog(
        context,
        e.toString(),
      );
    }
  }
}
