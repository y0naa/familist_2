// ignore_for_file: depend_on_referenced_packages

import 'package:familist_2/widgets/schedule/date.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationApi {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static void initNotif() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));
    print("tz: ${tz.TZDateTime.now(tz.local)}");
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
            channelID, 'channelName', 'channelDescription',
            importance: Importance.high));
  }

  static Future showScheduledNotification({
    required String id,
    String? title,
    String? body,
    String? payload,
    required tz.TZDateTime date,
    required String channelID,
  }) async {
    return _notifications.zonedSchedule(
      id.hashCode,
      title,
      body,
      date,
      await _notificationDetails(channelID),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future showRepeatingNotification({
    required String id,
    String? title,
    String? body,
    String? payload,
    required DateTime startDate,
    required int repeated,
    required String channelID,
  }) async {
    return _notifications.zonedSchedule(
      id.hashCode,
      title,
      body,
      _nextInstanceOfTenAM(repeated, startDate),
      await _notificationDetails(channelID),
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  static tz.TZDateTime _nextInstanceOfTenAM(int days, DateTime startDate) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, startDate.day);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(Duration(days: days));
    }
    return scheduledDate;
  }

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async =>
      _notifications.show(
          id, title, body, await _notificationDetails("norm notif"),
          payload: payload);
}
