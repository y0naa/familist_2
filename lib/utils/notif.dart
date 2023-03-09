// ignore_for_file: depend_on_referenced_packages

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
