import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familist_2/utils/profile.dart';
import 'package:familist_2/widgets/dialog.dart';
import 'package:flutter/material.dart';

class ScheduleHelper {
  CollectionReference users = FirebaseFirestore.instance.collection("users");

  Future<int> checkUser(List<String> items) async {
    int index = 0;
    String uid = await Profile().getUserID();
    DocumentSnapshot documentSnapshot = await users.doc(uid).get();
    if (documentSnapshot.exists) {
      String fullName = documentSnapshot.get("full name");
      print("Full name: $fullName");
      index = items.indexOf(fullName);
      print("Index: $index");
      return index;
    }
    return index;
  }

  Future deleteSchedule(BuildContext context, String docID) async {
    try {
      String userID = await Profile().getUserID();
      await users.doc(userID).collection("schedule").doc(docID).delete();
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

  Future deleteEvent(BuildContext context, String docID) async {
    try {
      String userID = await Profile().getUserID();
      await users.doc(userID).collection("events").doc(docID).delete();
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

  Future addSchedule(Map<String, dynamic> input, String id) async {
    await users.doc(id).collection("schedule").add(input);
  }

  Future addEvent(Map<String, dynamic> input, String id) async {
    await users.doc(id).collection("events").add(input);
  }

  Future getEvents(BuildContext context) async {
    try {
      String userID = await Profile().getUserID();
      List<Map<String, dynamic>> events = [];
      QuerySnapshot snapshot =
          await users.doc(userID).collection("events").get();

      List<Future<DocumentSnapshot>> futures = [];
      for (QueryDocumentSnapshot document in snapshot.docs) {
        final documentPath = document.reference.path;
        if (documentPath != null && documentPath.isNotEmpty) {
          futures.add(document.reference.get());
        }
      }

      List<DocumentSnapshot> documents = await Future.wait(futures);

      for (int i = 0; i < documents.length; i++) {
        DocumentSnapshot document = documents[i];
        if (document.exists) {
          Map<String, dynamic> eventData =
              document.data() as Map<String, dynamic>;
          eventData['docID'] = snapshot.docs[i].id; // Add the document ID
          events.add(eventData);
        }
      }

      return events;
    } catch (e) {
      dialog(
        context,
        e.toString(),
      );
    }
  }

  Future getSchedules(BuildContext context, String userID) async {
    try {
      // String userID = await Profile().getUserID();

      List<Map<String, dynamic>> schedules = [];
      QuerySnapshot snapshot =
          await users.doc(userID).collection("schedule").get();

      List<Future<DocumentSnapshot>> futures = [];
      for (QueryDocumentSnapshot document in snapshot.docs) {
        final documentPath = document.reference.path;
        if (documentPath != null && documentPath.isNotEmpty) {
          futures.add(document.reference.get());
        }
      }

      List<DocumentSnapshot> documents = await Future.wait(futures);

      for (int i = 0; i < documents.length; i++) {
        DocumentSnapshot document = documents[i];
        if (document.exists) {
          Map<String, dynamic> scheduleData =
              document.data() as Map<String, dynamic>;
          scheduleData['docID'] = snapshot.docs[i].id; // Add the document ID
          schedules.add(scheduleData);
        }
      }

      return schedules;
    } catch (e) {
      dialog(
        context,
        e.toString(),
      );
    }
  }
}
