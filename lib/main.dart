import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:workmanager/workmanager.dart';
import 'package:zini_pay/controllers/notification_controller.dart';
import 'package:zini_pay/pages/splashpage/splash_page.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  await NotificationService.initialize();

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
