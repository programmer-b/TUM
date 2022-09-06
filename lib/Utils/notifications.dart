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

  // static Future _notificationDetails() async {
  //   return const NotificationDetails(
  //     android: AndroidNotificationDetails('channel id', 'channel name',
  //         channelDescription: 'channel description',
  //         importance: Importance.max,
  //         icon: "splash",
  //         priority: Priority.high),
  //     iOS: IOSNotificationDetails(),
  //   );
  // }

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    var bigTextStyleInformation = BigTextStyleInformation(body!);
    Future notificationDetails() async {
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

    return _notifications.show(id, title, body, await notificationDetails(),
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

class DailyNotificationsApi {
  static List<Map<String, dynamic>> notificationMessages = [
    {
      "message":
          "SCHEDULE 2 ISSUANCE OF CERTIFICATES FOR GRADUANDS OF THE 9 TH GRADUATION CEREMONY 2022",
      "payload": "https://www.tum.ac.ke/noticeboard/dl?id=30hibzqtd4891w0"
    },
    {
      "message": "NEW STUDENTS REGISTRATION",
      "payload": "https://www.tum.ac.ke/noticeboard/dl?id=958fz9afu5lf0p0"
    },
    {
      "message": "GROUP PERSONAL ACCIDENT POLICY SEP-DEC LIST 2",
      "payload": "https://www.tum.ac.ke/noticeboard/dl?id=fzsm1y4kypjqj"
    },
    {
      "message": "GROUP PERSONAL ACCIDENT POLICY SEP-DEC LIST 1",
      "payload": "https://www.tum.ac.ke/noticeboard/dl?id=1vyt25pogr6h1p2"
    },
    {
      "message":
          "ISSUANCE OF CERTIFICATES FOR GRADUANDS OF THE 9TH GRADUATION CEREMONY 2022",
      "payload": "https://www.tum.ac.ke/noticeboard/dl?id=81wj0kq0r8qwl7"
    },
    {
      "message":
          "Online Room Reservation and Booking for New Students - SEPTEMBER INTAKE",
      "payload": "https://www.tum.ac.ke/noticeboard/dl?id=6nc2qgqsb56zvi"
    },
    {
      "message": "FINAL AWARD LIST FOR THE 9TH GRADUATION CEREMONY",
      "payload": "https://www.tum.ac.ke/noticeboard/dl?id=el6a2vrh39y30"
    },
    {
      "message": "ANNOUNCEMENT FOR 9TH GRADUATION CEREMONY",
      "payload": "https://www.tum.ac.ke/news/read?id=ofv2o2dutu0lvyln"
    },
    {
      "message":
          "FINAL AWARD LIST FOR STUDENTS EXPECTED TO GRADUATE DURING THE UPCOMING 9TH GRADUATION CEREMONY",
      "payload": "https://www.tum.ac.ke/noticeboard/dl?id=3si20foa2xaq91"
    },
    {
      "message":
          "SUBJECT: RELEASE OF APRIL 2022 SERIES END OF SEMESTER EXAMINATION RESULTS",
      "payload": "https://www.tum.ac.ke/noticeboard/dl?id=2u354f7jxwitdy4"
    },
    {
      "message": "COURSE APPLICATION FORM",
      "payload": "https://www.tum.ac.ke/downloads/get?file=3tv7yfr75zx09jmn"
    },
    {
      "message": "FULL-TIME AND EVENING COURSES FOR JANUARY, MAY AND SEPTEMBER",
      "payload": "https://www.tum.ac.ke/downloads/get?file=5y1vr2l6x0rsgiq"
    },
    {
      "message": "Online Application for KUCCPS Sponsored Students Guide",
      "payload": "https://www.tum.ac.ke/downloads/get?file=3pavhedxrb23ok2"
    },
    {
      "message":
          "Online_Admission_for_Both_Self_Sponsored_KUCCPS_Students_Guide",
      "payload": "https://www.tum.ac.ke/downloads/get?file=el79b6opet3e"
    },
  ];

  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  static Future init({bool initScheduled = false}) async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOS = IOSInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: iOS);
    await _notifications.initialize(settings,
        onSelectNotification: (payload) async {
      onNotifications.add(payload);
    });
  }

  static Future showNotification(
      {int id = 0, String? title, String? body, String? payload}) async {
    var bigTextStyleInformation = BigTextStyleInformation(body!);
    Future notificationDetails() async {
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

    _notifications.show(id, title, body, await notificationDetails(),
        payload: payload);
  }

  static Future initializetimezone() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Africa/Nairobi'));
  }

  static Future showScheduledNotification({
    int id = 0,
  }) async {
    int randomInt() {
      Random random = Random();
      int randomNumber = random.nextInt(14);
      return randomNumber;
    }

    final randomINT = randomInt();
    var bigTextStyleInformation = BigTextStyleInformation(
      notificationMessages[randomINT]["message"],
    );
    Future notificationDetails() async {
      return NotificationDetails(
        android: AndroidNotificationDetails('channel id', 'channel name',
            channelDescription: 'channel description',
            importance: Importance.max,
            icon: "splash",
            priority: Priority.high,
            styleInformation: bigTextStyleInformation,
            enableLights: true,
            playSound: true,
            ongoing: true,
            visibility: NotificationVisibility.public,
            enableVibration: true),
        iOS: const IOSNotificationDetails(),
      );
    }

    await initializetimezone();

    _notifications.zonedSchedule(
        id,
        'Technical University of Mombasa',
        notificationMessages[randomINT]["message"],
        _convertTime(19,00),
        await notificationDetails(),
        payload: notificationMessages[randomINT]["payload"],
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  static tz.TZDateTime _convertTime(int hour, int minutes) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduleDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minutes,
    );
    if (scheduleDate.isBefore(now)) {
      scheduleDate = scheduleDate.add(const Duration(days: 1));
    }
    return scheduleDate;
  }
}
