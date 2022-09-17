import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialise() {
    final InitializationSettings initializationSettings =
        InitializationSettings(
            // android: AndroidInitializationSettings("app_icon"));
            android: AndroidInitializationSettings("logo"));
    _notificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) {
      print(payload);
    });
  }

  static void showNotificationOnForground(RemoteMessage message) {
    final notifDetail = NotificationDetails(
        android: AndroidNotificationDetails(
            "com.example.licence_mobile", 'licence_mobile',
            importance: Importance.max, priority: Priority.high, icon: "logo"));
    _notificationsPlugin.show(DateTime.now().microsecond,
        message.notification!.title, message.notification!.body, notifDetail);
  }
}
