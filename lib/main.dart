import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:workmanager/workmanager.dart';
import 'package:zini_pay/controllers/notification_controller.dart';
import 'package:zini_pay/pages/splashpage/splash_page.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    NotificationService().showNotification(
      title: 'Background Syncing',
      body: 'SMS syncing is running in the background.',
    );

    await Future.delayed(Duration(seconds: 10));

    return Future.value(true);
  });
}

Future<void> performSmsSync() async {
  await Future.delayed(Duration(seconds: 10));
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  NotificationService notificationController = NotificationService();
  await notificationController.initNotification();

  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zini pay',
      home: SplashScreen(),
    );
  }
}
