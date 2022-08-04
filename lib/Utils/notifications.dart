part of 'package:tum/Utils/utils.dart';

// const android = AndroidNotificationDetails(
//     "channelId", "Technical University of Mombasa",
//     channelDescription: "TUM notifications",
//     priority: Priority.high,
//     importance: Importance.max);

//      final notificationDetails =
//       const NotificationDetails(android: android, iOS: ios);
//   void showDownloadNotification({Map<String, dynamic>? downloadStatus}) {
//     final json = jsonEncode(downloadStatus);
//   }

// const ios = IOSNotificationDetails();

class NotificationsApi {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future _notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails('channel id', 'channel name',
          channelDescription: 'channel description',
          importance: Importance.max,
          icon: "splash",
          priority: Priority.high),
      iOS: IOSNotificationDetails(),
    );
  }

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    var bigTextStyleInformation = BigTextStyleInformation(body!);
    Future _notificationDetails() async {
      return NotificationDetails(
        android: AndroidNotificationDetails('channel id', 'channel name',
            channelDescription: 'channel description',
            importance: Importance.max,
            icon: "splash",
            priority: Priority.high,
            styleInformation: bigTextStyleInformation,
            enableLights: true,
            playSound: true,
            enableVibration: true),
        iOS: const IOSNotificationDetails(),
      );
    }

    return _notifications.show(id, title, body, await _notificationDetails(),
        payload: payload);
  }

  Future showDownloadNotification(Map<String, dynamic> downloadStatus) async {
    final json = jsonEncode(downloadStatus);
    final isSuccess = downloadStatus['isSuccess'];

    await showNotification(
        id: 10,
        title: isSuccess ? "Success" : "Error",
        body: isSuccess
            ? "${downloadStatus['fileName']} downloaded successfully."
            : "File not downloaded",
        payload: json);
  }
}
