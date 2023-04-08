import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:uuid/uuid.dart';

import 'notif.dart';

class BackgroundService {
  @pragma('vm:entry-point')
  static void runBgTask(int alarmId, Map<String, dynamic> bill) async {
    print("[${DateTime.now}] Hello, world! function='$runBgTask' bill=$bill");
    NotificationApi.initNotif();
    NotificationApi.showNotification(
      id: const Uuid().v4(),
      body: "Don't forget to pay your bills!",
      title: bill['item name'],
    );

    setAlarmManager(
        const Uuid().v4(),
        DateTime.now().add(
          Duration(days: bill['repeated in']),
        ),
        bill);
  }

  static void initializeBgTask() async {
    await AndroidAlarmManager.initialize();
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
