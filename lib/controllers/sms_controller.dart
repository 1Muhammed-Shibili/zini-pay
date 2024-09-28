import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';

class SmsSyncController extends GetxController {
  var isSyncing = false.obs;
  var isSyncStarted = false.obs;
  var isConnected = true.obs;
  var messages = <Map<String, dynamic>>[].obs;
  var devices = <Map<String, dynamic>>[].obs;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void onInit() {
    super.onInit();
    _initializeNotifications();
    _checkInternetConnectivity();
  }

  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(
            'app_icon'); // Ensure you have an icon named 'app_icon'
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Start syncing SMS messages
  void startSyncing() {
    if (!isConnected.value) {
      Get.snackbar('No Internet',
          'Cannot start syncing without an internet connection.');
      return; // Exit if not connected
    }

    isSyncing.value = true;
    isSyncStarted.value = true; // Set to true when syncing starts
    Get.snackbar('Syncing', 'Started syncing SMS messages in the background.');
    _showNotification('SMS Sync', 'Syncing SMS messages in the background.');

    // Schedule background sync using WorkManager
    Workmanager().registerPeriodicTask(
      'smsSyncTask', // Unique name for this task
      'smsSyncTask', // Task name
      frequency: const Duration(minutes: 15), // Sync every 15 minutes
    );
  }

  // Stop syncing SMS messages
  void stopSyncing() {
    isSyncing.value = false;
    isSyncStarted.value = false;
    Get.snackbar('Syncing', 'Stopped syncing SMS messages.');

    // Cancel the persistent notification and background task
    flutterLocalNotificationsPlugin.cancel(0);
    Workmanager().cancelAll();
  }

  Future<void> syncSms(String message, String from, String timestamp) async {
    const url = 'https://demo.zinipay.com/sms/sync';

    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        Get.snackbar('No Internet', 'Waiting for internet connection...');
        return;
      }

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'message': message,
          'from': from,
          'timestamp': timestamp,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          Get.snackbar('Success', 'SMS synced successfully.');
        } else {
          Get.snackbar('Error', responseData['message']);
        }
      } else {
        Get.snackbar('Sync Failed', 'Status code: ${response.statusCode}');
      }
    } catch (error) {
      Get.snackbar('Error', 'Failed to sync SMS due to an error: $error');
    }
  }

  // View all messages
  Future<void> fetchMessages() async {
    const url = 'https://demo.zinipay.com/sms';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          messages
              .assignAll(List<Map<String, dynamic>>.from(responseData['data']));
        } else {
          Get.snackbar('Error', 'Failed to fetch messages. Invalid response.');
        }
      } else {
        Get.snackbar('Error',
            'Failed to fetch messages. Status code: ${response.statusCode}');
      }
    } catch (error) {
      Get.snackbar('Error', 'Failed to fetch messages due to an error: $error');
    }
  }

  // View all devices or login credentials
  Future<void> fetchDevices() async {
    const url = 'https://demo.zinipay.com/devices';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          devices
              .assignAll(List<Map<String, dynamic>>.from(responseData['data']));
        } else {
          Get.snackbar('Error', 'Failed to fetch devices. Invalid response.');
        }
      } else {
        Get.snackbar('Error',
            'Failed to fetch devices. Status code: ${response.statusCode}');
      }
    } catch (error) {
      Get.snackbar('Error', 'Failed to fetch devices due to an error: $error');
    }
  }

  // Persistent notification
  Future<void> _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('your_channel_id', 'your_channel_name',
            channelDescription: 'your_channel_description',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false,
            ongoing: true);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
        0, title, body, platformChannelSpecifics);
  }

  void _checkInternetConnectivity() {
    Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      bool hasInternet =
          results.any((result) => result != ConnectivityResult.none);

      if (hasInternet) {
        if (isSyncing.value) {
          syncSms('Message after reconnection', '+1234567890',
              DateTime.now().toIso8601String());
        }
      } else {
        Get.snackbar('No Internet Connection', 'Waiting for internet...');
        print('No internet connection');
      }
    });
  }
}