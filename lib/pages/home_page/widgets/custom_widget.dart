import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zini_pay/controllers/sms_controller.dart';
import 'package:zini_pay/pages/home_page/widgets/bottom_sheet.dart';

class HomePageWidgets {
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

  static Widget buildSyncButton(SmsSyncController controller) {
    return Obx(
      () => ElevatedButton(
        onPressed: controller.isSyncing.value
            ? controller.stopSyncing
            : controller.startSyncing,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1976D2),
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
}
