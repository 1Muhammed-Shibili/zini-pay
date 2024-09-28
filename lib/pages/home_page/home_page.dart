import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zini_pay/controllers/login_controller.dart';
import 'package:zini_pay/controllers/logout_controller.dart';
import 'package:zini_pay/controllers/sms_controller.dart';
import 'package:zini_pay/pages/home_page/widgets/bottom_sheet.dart';
import 'package:zini_pay/pages/home_page/widgets/custom_widget.dart';

class HomePage extends StatelessWidget {
  final SmsSyncController controller = Get.put(SmsSyncController());
  final LoginController loginController = Get.put(LoginController());
  final BottomSheetCustom bottomSheetCustom = BottomSheetCustom();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              logout();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HomePageWidgets.buildStatusIndicator(controller),
            const SizedBox(height: 10),
            HomePageWidgets.buildSyncStatusText(controller),
            const SizedBox(height: 100),
            HomePageWidgets.buildSyncButton(controller),
            const SizedBox(height: 20),
            HomePageWidgets.buildMessageAndDeviceButtons(
                controller, bottomSheetCustom),
            const SizedBox(height: 10),
            HomePageWidgets.buildSyncStoppedMessage(controller),
          ],
        ),
      ),
    );
  }
}
