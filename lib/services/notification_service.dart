import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
  FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iOSSettings =
    DarwinInitializationSettings();

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iOSSettings,
    );

    await _notifications.initialize(settings);
    tz.initializeTimeZones();
  }

  static Future<void> scheduleNotification(
      int id,
      String title,
      String body,
      DateTime scheduledTime, {
        bool repeatDaily = false,
      }) async {
    try {
      final tz.TZDateTime tzScheduledTime =
      tz.TZDateTime.from(scheduledTime, tz.local);

      if (tzScheduledTime.isBefore(tz.TZDateTime.now(tz.local))) {
        return;
      }

      const AndroidNotificationDetails androidDetails =
      AndroidNotificationDetails(
        'med_channel_id',
        'Medicine Reminders',
        channelDescription: 'Reminds users to take medicine',
        importance: Importance.max,
        priority: Priority.high,
      );

      await _notifications.zonedSchedule(
        id,
        title,
        body,
        tzScheduledTime,
        const NotificationDetails(android: androidDetails),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: repeatDaily
            ? DateTimeComponents.time
            : null,
      );
    } catch (e) {
      print('Error scheduling notification: $e');
    }
  }
}