import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zini_pay/controllers/sms_controller.dart';
import 'package:zini_pay/pages/home_page/widgets/bottom_sheet.dart';

class HomePageWidgets {
  // Status Indicator Widget
  static Widget buildStatusIndicator(SmsSyncController controller) {
    return Obx(() {
      if (controller.isSyncing.value) {
        return Column(
          children: [
            SvgPicture.asset('assets/images/Group 49.svg'),
            const SizedBox(height: 10),
          ],
        );
      }
      return const SizedBox.shrink();
    });
  }

  // Sync Status Text Widget
  static Widget buildSyncStatusText(SmsSyncController controller) {
    return Obx(() => Text(
          controller.isSyncing.value ? 'Active' : 'Not active',
          style: GoogleFonts.acme(
            textStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400,
              fontSize: 36,
            ),
          ),
        ));
  }

  // Sync Button Widget
  static Widget buildSyncButton(SmsSyncController controller) {
    return Obx(
      () => ElevatedButton(
        onPressed: controller.isSyncing.value
            ? controller.stopSyncing // Stop syncing if active
            : controller.startSyncing, // Start syncing if not active
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1976D2), // Button color
          fixedSize: const Size(300, 64),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          controller.isSyncing.value ? 'Stop' : 'Start',
          style: GoogleFonts.acme(
            textStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontSize: 36,
            ),
          ),
        ),
      ),
    );
  }

  // Message and Device Buttons Widget
  static Widget buildMessageAndDeviceButtons(
      SmsSyncController controller, BottomSheetCustom bottomSheetCustom) {
    return Obx(() {
      if (!controller.isSyncing.value) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.message, size: 36),
              onPressed: bottomSheetCustom.showMessages,
            ),
            const SizedBox(width: 20),
            IconButton(
              icon: const Icon(Icons.devices, size: 36),
              onPressed: bottomSheetCustom.showDevices,
            ),
          ],
        );
      }
      return const SizedBox.shrink();
    });
  }

  // Sync Stopped Message Widget
  static Widget buildSyncStoppedMessage(SmsSyncController controller) {
    return Obx(() {
      if (!controller.isSyncing.value && controller.isSyncStarted.value) {
        return Text(
          'SMS syncing has stopped due to no internet connection.',
          style: TextStyle(color: Colors.red),
        );
      }
      return const SizedBox.shrink();
    });
  }

  // static void showOfflineDialog() {
  //   Get.dialog(
  //     Dialog(
  //       backgroundColor: Colors.transparent, // Makes background transparent
  //       insetPadding: EdgeInsets.all(0), // Adjust padding
  //       child: Stack(
  //         children: [
  //           Positioned(
  //             top: Get.height * 0.8, // Position it near the bottom
  //             left: 0,
  //             right: 0,
  //             child: Container(
  //               margin: EdgeInsets.symmetric(horizontal: 20),
  //               padding: EdgeInsets.all(20),
  //               decoration: BoxDecoration(
  //                 color: Colors.black.withOpacity(0.7), // Semi-transparent
  //                 borderRadius: BorderRadius.circular(16),
  //               ),
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   Icon(
  //                     Icons.wifi_off,
  //                     color: Colors.white,
  //                     size: 36,
  //                   ),
  //                   SizedBox(width: 10),
  //                   Text(
  //                     'No internet connection!',
  //                     style: TextStyle(
  //                       color: Colors.white,
  //                       fontSize: 18,
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //     barrierDismissible:
  //         true, // Allows the dialog to be dismissed by tapping outside
  //   );
  // }
}
