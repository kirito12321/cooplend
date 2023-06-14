import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationApi {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future _notificationDetails() async {
    return const NotificationDetails(
        android: AndroidNotificationDetails(
            'high_importance_channel', // id
            'High Importance Notifications', //
            channelDescription:
                'This channel is used for important notifications.', // description
            importance: Importance.high,
            icon: 'mipmap/ic_launcher'),
        iOS: DarwinNotificationDetails());
  }

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async =>
      _notifications.show(id, title, body, await _notificationDetails());
}
