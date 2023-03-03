import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familist_2/utils/profile.dart';
import 'package:flutter/material.dart';

import '../widgets/dialog.dart';

class RemindersHelpers {
  CollectionReference users = FirebaseFirestore.instance.collection("users");

  Future deleteReminder(BuildContext context, String docID) async {
    try {
      String userID = await Profile().getUserID();
      DocumentSnapshot snapshot =
          await users.doc(userID).collection("reminders").doc(docID).get();
      await users.doc(userID).collection("reminders").doc(docID).delete();
      if (snapshot.exists) {
        if (context.mounted) {
          dialog(
            context,
            "Delete Successful",
          );
        }
      } else {
        if (context.mounted) {
          dialog(
            context,
            "You can only delete your own items",
          );
        }
      }
    } catch (e) {
      dialog(context, e.toString());
    }
  }

  Future deleteBill(BuildContext context, String docID) async {
    try {
      String userID = await Profile().getUserID();
      await users.doc(userID).collection("bills").doc(docID).delete();
      if (context.mounted) {
        dialog(
          context,
          "Delete Successful",
        );
      }
    } catch (e) {
      dialog(context, e.toString());
    }
  }

  Future addReminder(Map<String, dynamic> input, String uid) async {
    await users.doc(uid).collection("reminders").add(input);
  }

  Future addBill(Map<String, dynamic> input, String uid) async {
    await users.doc(uid).collection("bills").add(input);
  }

  Future updateReminder(String uid, String reminderId, bool toggle) async {
    print("thiis workspace");
    await users
        .doc(uid)
        .collection("reminders")
        .doc(reminderId)
        .update({"completed": toggle});
  }

  Future updateBills(String uid, String billId, bool toggle) async {
    print("bill update");
    await users
        .doc(uid)
        .collection("bills")
        .doc(billId)
        .update({"completed": toggle});
  }

  Future getBills(BuildContext context) async {
    try {
      String currID = await Profile().getUserID();
      CollectionReference usersRef =
          FirebaseFirestore.instance.collection('users');
      QuerySnapshot usersQuerySnapshot = await usersRef.get();
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
      print(billsMap);
      return billsMap;
    } catch (e) {
      dialog(
        context,
        e.toString(),
      );
    }
  }

  Future getReminders(BuildContext context) async {
    try {
      String currID = await Profile().getUserID();
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
          reminderData['fullName'] = fullName;
          reminderData['userID'] = userId;
          reminderData['reminderID'] = reminderDoc.id;
          reminderData['currentID'] = currID;
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
