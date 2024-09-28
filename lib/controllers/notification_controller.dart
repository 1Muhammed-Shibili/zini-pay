import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Initialize notifications
  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Show persistent notification
  static Future<void> showPersistentNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'persistent_channel_id', // Channel ID
      'Persistent Notifications', // Channel name
      channelDescription: 'This channel is used for persistent notifications',
      importance: Importance.max,
      priority: Priority.high,
      ongoing: true, // This makes the notification persistent
      visibility: NotificationVisibility.public,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      'App Running', // Notification title
      'Your app is running in the background', // Notification body
      platformChannelSpecifics,
    );
  }

  // Remove persistent notification
  static Future<void> removeNotification() async {
    await _flutterLocalNotificationsPlugin
        .cancel(0); // Cancel notification by ID
  }
}
