// ignore_for_file: depend_on_referenced_packages
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familist_2/utils/profile.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'bg_service.dart';
import 'modules/reminders_helper.dart';
import 'modules/schedule_helper.dart';

class NotificationApi {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future cancelAll() async {
    String currID = await Profile.getUserID();
    print("cancelling all notifications...");
    await _notifications.cancelAll();
    QuerySnapshot billsSnapshot = await RemindersHelpers.users
        .doc(currID)
        .collection('bills')
        .where('repeated in', isNotEqualTo: null)
        .get();
    if (billsSnapshot.docs.isNotEmpty) {
      List<DocumentSnapshot> billsList = billsSnapshot.docs;
      for (DocumentSnapshot billDoc in billsList) {
        await AndroidAlarmManager.cancel(billDoc.id.hashCode);
      }
    }
  }

  static void setAllReminders() async {
    initNotif();
    cancelAll();
    await ScheduleHelper().setEventsNotif();
    await RemindersHelpers().setReminderNotif();
    await RemindersHelpers.setBillsNotif();
  }

  static Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(
      tz.getLocation(timeZoneName),
    );
  }

  @pragma('vm:entry-point')
  static void initNotif() async {
    _configureLocalTimeZone();
    tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await _notifications.initialize(
      initializationSettings,
    );
  }

  static Future _notificationDetails(String channelID) async {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        channelID,
        'channelName',
        'channelDescription',
        importance: Importance.max,
        priority: Priority.max,
      ),
    );
  }

  static Future showScheduledNotification({
    required String id,
    String? title,
    String? body,
    String? payload,
    required tz.TZDateTime date,
    required String channelID,
  }) async {
    if (date.isAfter(tz.TZDateTime.now(tz.local))) {
      print('Setting Events Notifications...');
      print("$title Due Time: $date");
      return _notifications.zonedSchedule(
        id.hashCode,
        title,
        body,
        date,
        await _notificationDetails(channelID),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dateAndTime,
        payload: payload,
      );
    }
  }

  @pragma('vm:entry-point')
  static Future showRepeatingNotification({
    required String id,
    required Map<String, dynamic> bill,
    required DateTime startDate,
    required int repeated,
  }) async {
    print("setting alarm manager for ${nextInstance(repeated, startDate)}");
    BackgroundService.setAlarmManager(
      id,
      nextInstance(repeated, startDate),
      bill,
    );
  }

  @pragma('vm:entry-point')
  static tz.TZDateTime nextInstance(int days, DateTime startDate) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, startDate.year,
        startDate.month, startDate.day, startDate.hour, startDate.minute, 0);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(Duration(days: days));
    }
    print("scheduled date: $scheduledDate");
    return scheduledDate;
  }

  @pragma('vm:entry-point')
  static Future showNotification({
    required String id,
    String? title,
    String? body,
    String? payload,
  }) async =>
      _notifications.show(
        id.hashCode,
        title,
        body,
        await _notificationDetails("normal notif"),
        payload: payload,
      );
}
