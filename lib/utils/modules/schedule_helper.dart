import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familist_2/utils/profile.dart';
import 'package:familist_2/widgets/dialog.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
// ignore: depend_on_referenced_packages
import 'package:timezone/timezone.dart' as tz;

import '../notif.dart';

class ScheduleHelper {
  CollectionReference users = FirebaseFirestore.instance.collection("users");
  Future<int> checkUser(List<String> items) async {
    int index = 0;
    String uid = await Profile().getUserID();
    DocumentSnapshot documentSnapshot = await users.doc(uid).get();
    if (documentSnapshot.exists) {
      String fullName = documentSnapshot.get("full name");
      index = items.indexOf(fullName);
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
      await NotificationApi.cancelAll();
      NotificationApi.setAllReminders();
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
    print("uid: $id");
    await users.doc(id).collection("schedule").add(input);
    print("success");
  }

  Future? getOverlappingSchedule(
      String id, String startTime, String endTime) async {
    final userScheduleCollection = users.doc(id).collection("schedule");
    final collectionSnapshot = await userScheduleCollection.get();
    if (collectionSnapshot.docs.isEmpty) {
      print("Collection does not exist");
      return null;
    }
    // Check if collection is empty
    final overlappingSchedules = await userScheduleCollection
        .where('start time', isLessThan: endTime)
        .get();
    if (overlappingSchedules.docs.isEmpty) {
      print("Collection is empty");
      return null;
    }
    print("Overlapping schedule");
    return overlappingSchedules;
  }

  Future addEvent(Map<String, dynamic> input, String id) async {
    await users.doc(id).collection("events").add(input);
    await NotificationApi.cancelAll();
    NotificationApi.setAllReminders();
  }

  Future getEvents(BuildContext context, String userId) async {
    try {
      String currID = await Profile().getUserID();
      CollectionReference eventsRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('events');
      QuerySnapshot eventsQuerySnapshot = await eventsRef.get();
      String fullName = '';
      List<Map<String, dynamic>> eventsList = [];
      for (QueryDocumentSnapshot eventDoc in eventsQuerySnapshot.docs) {
        if (fullName.isEmpty) {
          DocumentSnapshot userDocSnapshot = await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .get();
          fullName = userDocSnapshot.get('full name');
        }
        Map<String, dynamic> eventData =
            eventDoc.data() as Map<String, dynamic>;
        eventData['fullName'] = fullName;
        eventData['userID'] = userId;
        eventData['eventID'] = eventDoc.id;
        eventData['currentID'] = currID;
        eventsList.add(eventData);
      }
      return eventsList;
    } catch (e) {
      dialog(
        context,
        e.toString(),
      );
    }
  }

  Future getSchedules(BuildContext context, String userID) async {
    try {
      List<Map<String, dynamic>> schedules = [];
      QuerySnapshot snapshot =
          await users.doc(userID).collection("schedule").get();
      List<Future<DocumentSnapshot>> futures = [];
      for (QueryDocumentSnapshot document in snapshot.docs) {
        final documentPath = document.reference.path;
        if (documentPath.isNotEmpty) {
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

  Future setEventsNotif() async {
    String currID = await Profile().getUserID();
    QuerySnapshot eventsSnapshot =
        await users.doc(currID).collection('events').where('date').get();
    if (eventsSnapshot.docs.isNotEmpty) {
      List<DocumentSnapshot> eventsList = eventsSnapshot.docs;
      for (DocumentSnapshot eventDoc in eventsList) {
        Map eventData = eventDoc.data() as Map;
        DateTime eventDate = DateTime.parse(
            Jiffy(eventData['date'], "dd/MM/yyyy").format("yyyy-MM-dd"));
        final timeParts = eventData['time'].split(":");
        final hour = int.parse(timeParts[0]);
        final minute = int.parse(timeParts[1]);
        final date = DateTime(eventDate.year, eventDate.month, eventDate.day,
            hour, minute, 0, 0, 0);
        if (date.isAfter(tz.TZDateTime.now(tz.local))) {
          NotificationApi.showScheduledNotification(
            id: eventDoc.id,
            date: tz.TZDateTime.from(date, tz.local),
            channelID: "events",
            body: "You have an important event today!",
            title: eventData['item name'],
          );
          print(
              "${eventData["item name"]} Set Time: ${tz.TZDateTime.now(tz.local)}");
        }
      }
    }
  }
}
