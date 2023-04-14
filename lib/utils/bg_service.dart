import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:familist_2/utils/modules/reminders_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'notif.dart';

class BackgroundService {
  @pragma('vm:entry-point')
  static void runBgTask(int alarmId, Map<String, dynamic> bill) async {
    print(
      "BG SERVICE STARTED",
    );
    DateTime today = DateTime.now();
    DateTime dateAtMidnight = DateTime(
      today.year,
      today.month,
      today.day,
      0,
      0,
      1,
    );

    await Firebase.initializeApp();
    NotificationApi.initNotif();
    if (!bill['paid']) {
      print("running !bill[paid]");
      await NotificationApi.showNotification(
        id: bill['billID'],
        body: "Don't forget to pay your bills!",
        title: bill['item name'],
      );
      cancelAlarmManager(bill['billID']);
    } else {
      RemindersHelpers.bgNotificationTogglePaid(
        bill['billID'],
        bill['currentUserID'],
      );
      bill['paid'] = false;
    }
    setAlarmManager(
      bill['billID'],
      dateAtMidnight.add(
        Duration(
          days: bill['repeated in'],
        ),
      ),
      bill,
    );
    print(
      "[${DateTime.now}] Hello, world! function='$runBgTask' bill=$bill setAlarm=$setAlarmManager date at midnight=${dateAtMidnight.add(
        Duration(
          days: bill['repeated in'],
        ),
      )}",
    );
  }

  static void initializeBgTask() async {
    await AndroidAlarmManager.initialize();
  }

  static void cancelAlarmManager(String id) async {
    await AndroidAlarmManager.cancel(id.hashCode);
  }

  static void setAlarmManager(
      String id, DateTime time, Map<String, dynamic> bill) async {
    initializeBgTask();
    await AndroidAlarmManager.oneShotAt(
      time,
      id.hashCode,
      runBgTask,
      allowWhileIdle: true,
      rescheduleOnReboot: true,
      params: bill,
    );
    print("set alarm manager trigerred for $time");
  }
}
